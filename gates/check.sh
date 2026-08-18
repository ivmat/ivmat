#!/bin/sh
# Minimal check suite for this repo's markdown content.
#
# Checks:
#   (a) every relative markdown link and image reference resolves to a real file
#   (b) no key-shaped strings (a simple secret scan)
#   (c) markdown files are valid UTF-8 and non-empty
#
# Usage: gates/check.sh [repo-root]
#   repo-root defaults to the git repo containing this script.
#
# Zero dependencies beyond sh, python3, and git. Meant to run in well under 5s.
set -u

if [ "${1:-}" != "" ]; then
    ROOT="$1"
else
    ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
fi

cd "$ROOT" || exit 1

FILES="$(git -C "$ROOT" ls-files '*.md' 2>/dev/null)"
if [ -z "$FILES" ]; then
    FILES="$(find "$ROOT" -name '*.md')"
fi

if [ -z "$FILES" ]; then
    echo "check: no markdown files found, nothing to check"
    exit 0
fi

FILELIST="$(mktemp "${TMPDIR:-/tmp}/check.filelist.XXXXXX")"
trap 'rm -f "$FILELIST"' EXIT
printf '%s\n' "$FILES" > "$FILELIST"

python3 - "$ROOT" "$FILELIST" <<'PYEOF'
import sys
import re
import os

root = sys.argv[1]
with open(sys.argv[2]) as fh:
    files = [f for f in fh.read().splitlines() if f]

fail = False

link_re = re.compile(r'!?\[[^\]]*\]\(([^)]+)\)')

# Simple, generic "key-shaped string" patterns. Deliberately conservative to
# avoid false positives on ordinary prose while catching common credential shapes.
secret_patterns = [
    re.compile(r'-----BEGIN [A-Z ]*PRIVATE KEY-----'),
    re.compile(r'AKIA[0-9A-Z]{16}'),
    re.compile(r'gh[oprsu]_[0-9A-Za-z]{20,}'),
    re.compile(r'sk-[0-9A-Za-z]{20,}'),
    re.compile(r'xox[baprs]-[0-9A-Za-z-]{10,}'),
    re.compile(r'AIza[0-9A-Za-z_-]{35}'),
    re.compile(r'(?i)\b(api|secret|access)[_-]?key\b\s*[:=]\s*[\'"]?[0-9A-Za-z/+_-]{16,}'),
]

for rel in files:
    path = os.path.join(root, rel)
    if not os.path.isfile(path):
        continue

    with open(path, 'rb') as fh:
        raw = fh.read()

    if len(raw) == 0:
        print("FAIL: %s is empty" % rel)
        fail = True
        continue

    try:
        text = raw.decode('utf-8')
    except UnicodeDecodeError as e:
        print("FAIL: %s is not valid UTF-8 (%s)" % (rel, e))
        fail = True
        continue

    for pat in secret_patterns:
        m = pat.search(text)
        if m:
            print("FAIL: %s contains a key-shaped string near '%s...'" % (rel, m.group(0)[:12]))
            fail = True

    file_dir = os.path.dirname(path)
    for m in link_re.finditer(text):
        target = m.group(1).strip()
        # Drop an optional "title" part: (url "some title")
        target = target.split(' ', 1)[0].strip('<>')
        if not target:
            continue
        if target.startswith('#'):
            continue  # in-page anchor
        if re.match(r'^[a-zA-Z][a-zA-Z0-9+.-]*:', target):
            continue  # has a URL scheme (http:, https:, mailto:, ...) -> external
        if target.startswith('//'):
            continue  # protocol-relative URL
        path_part = target.split('#', 1)[0]
        if not path_part:
            continue
        resolved = os.path.normpath(os.path.join(file_dir, path_part))
        if not os.path.exists(resolved):
            print("FAIL: %s -> broken relative link '%s'" % (rel, target))
            fail = True

sys.exit(1 if fail else 0)
PYEOF
py_status=$?

if [ "$py_status" -ne 0 ]; then
    echo "check: FAILED"
    exit 1
fi

echo "check: OK"
exit 0

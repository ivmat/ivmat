#!/bin/sh
# Installs the pre-push check hook into .git/hooks. Safe to re-run.
#
# If a pre-push hook is already present and it isn't this one, it is
# preserved as pre-push.pre-guard and still gets run (chained) after checks
# pass. pre-commit and commit-msg hooks are left untouched.
set -eu

repo_root="$(git rev-parse --show-toplevel)"
hooks_dir="$(git rev-parse --git-path hooks)"
mkdir -p "$hooks_dir"

src="$repo_root/gates/pre-push"
dest="$hooks_dir/pre-push"
chained="$hooks_dir/pre-push.pre-guard"
marker="installed-by: gates/install_hooks.sh"

if [ -f "$dest" ] && ! grep -qF "$marker" "$dest" 2>/dev/null; then
    if [ -f "$chained" ]; then
        echo "install_hooks: $chained already exists, leaving it as-is" >&2
    else
        cp "$dest" "$chained"
        chmod +x "$chained"
        echo "install_hooks: preserved existing pre-push hook as $chained"
    fi
fi

cp "$src" "$dest"
chmod +x "$dest"
echo "install_hooks: installed $dest"

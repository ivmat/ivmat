# ivo matijasevic

- masters in math and CS
- 10+ years in Erlang systems

# project

## MODEL CHECKING

i feel we are going into a world of more complex applications with almost no faults: a similar jump to the one civil engineering made going from brick to reinforced concrete. build higher and stronger, but it requires deeper foundations and steel.
in this case model checking is the steel, and depth is clarity of the assumptions, definitions and rules of the system — with the rest proven.

model checking has long been used in practice in hw development, while software mostly went without it. manually written specs and proofs were too slow and too expensive (besides a few niches and academia).

my view is that llms change the economics. writing verifiable code and actually verifying it becomes cheap at scale.
i would say the future has 3 paths for software:

- legacy code and apps — not optimized for llm autonomy
- "disposable code" — an llm-produced app for a use case
- "correct code" — not just unit-tested code: code derived from a spec, shipped with proofs for the relevant characteristics

what does this mean:

- we need good & fast & llm-friendly model checkers for the relevant languages (my assumption is rust will be most relevant in the future, so i choose to rely on kani and aeneas for now)
- we need an easy way to ship code together with its spec and correctness proofs (and any extra tests for what the model checks don't cover)
- the most critical parts of the core of a system need to be:
    - **CORRECT** — satisfies the SPEC on *every* input, covered by proofs and tests
    - **SOUND** — no panics, no undefined behavior, no silent corruption
    - **SECURE** — the properties that protect users hold by construction, not by testing effort

## GROUND WHAT CAN BE GROUNDED — no hidden assumptions

every system rests on assumptions. the dangerous ones are the hidden ones — trust taken without ever being named. our way of work: either a statement is proven correct from other statements and/or assumptions OR it is stated as assumed.
one obvious place where we assume correctness without explicitly stating it: we trust 3rd party libs, tools, compilers, hw, etc. with llms we should make these assumptions loud — let them check it, i don't have time to do it myself.

goal: prove the whole chain, from core assumptions up to the actual code running for a given system. meaning: we prove facts and/or correctness of the specs until we hit definitions and rules/principles good enough to prove against.
in other words: EVERYTHING becomes mathematics, not just mathematics and theoretical physics :) — because llms make it cheap

reduce assumptions, never eliminate them — and know what's left

## obvious: hard part is moved to SPEC

llms make it easy to check code against the spec, but the hard part then is: what should the spec say. i think we humans still have a say there, even though llms write better specs. once llms cover model checking, our focus should move to specs.
this is the second pillar of future software development in my view — writing specs that correspond to intent (the first being quick and easy model checking).
(no ongoing work on this at the moment)

## my involvement and work

- [rs-verified-der](https://github.com/ivmat/rs-verified-der) — a formally verified DER (X.690) encoder/decoder in rust. kani for memory safety and bounded correctness, aeneas → lean for functional correctness of the pure core. i also back kani and aeneas, since my work relies on them.
- i looked for existing papers on the subject and found none, so i wrote three:
    - [a fault-tolerance threshold for gated agentic computation](https://zenodo.org/records/20820968)
    - [generated gates inherit their generator's blind spots](https://zenodo.org/records/20837102)
    - [escape, cost, and correlation at the verification floor of gated agentic computation](https://zenodo.org/records/21456783)

## pretty readme

llms do write nicer presentations with more detail, so if you want to read this "refined", check the [pretty readme](pretty_readme.md)

## note

of course none of the steps here are easy or really manageable by one person but i think steps are feasible and necessary longterm for llm-generated code in serious enough systems

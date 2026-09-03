# me
- masters in math and CS
- 10+ years in Erlang systems


## in few words
reduce assumptions, never eliminate them — and know what's left

## pretty readme

i propose you read [pretty readme](pretty_readme.md). its not just pretty, its refined and more accurate representation of ideas i wanted to share. i dont have patience for it all, and llms are  grammarly for idea expresion -- steering the llm output is orders of magnitute simpler than writing it precisely myself, especially when talking about rigourous things. i do review it and i find it more clearly represents the ideas i want to share. i still keep this readme handwritten, with all the roughness it brings since its direct output of me typing on the keyboard.

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

llms make it easy to check code against the spec, but the hard part then is: what should the spec say. this still stays critically people endeavour due to intent agreement. (even though llms may draft and do the "mechanical" part). once llms cover model checking, our focus should move to specs.
this is the second pillar of future software development in my view — writing specs that correspond to intent (the first being quick and easy model checking).

## my involvement and work

- [acceptance-format](https://github.com/ivmat/acceptance-format) - a format that records what verification decided including what it did not, and refuses weight rather than inflating it. artifact agnostic, so its not only for rust code but any artifact that can be grounded by an oracle.
- [autoprover-core](https://github.com/ivmat/autoprover-core) - core pattern of "proof producing autonymous LLM based machine" (used for showcase)
- [rs-verified-der](https://github.com/ivmat/rs-verified-der) — a partially formally verified DER (X.690) encoder/decoder in rust. kani for memory safety and bounded correctness, aeneas → lean for functional correctness of the pure core. i also back kani and aeneas, since my work relies on them.
- i looked for existing papers on the subject and 'did not find the same synthesis or threshold formulation', to be more precise, so i wrote three preprints:
    - [a fault-tolerance threshold for gated agentic computation](https://zenodo.org/records/20820968)
    - [generated gates inherit their generator's blind spots](https://zenodo.org/records/20837102)
    - [escape, cost, and correlation at the verification floor of gated agentic computation](https://zenodo.org/records/21456783)

## note

- of course none of the steps here are easy or really manageable by one person but i think steps are feasible and necessary longterm for llm-generated code in serious enough systems. autonymous artefact-producing-systems still need to be easily auditable, person-overridable and safe -- that's the point of "shift left" move: reduce problem-source surfaces to specs and mechanize most elements so no hidden non-wanted intend leaks into produced artefacts (in general, we talk about code, i.e commit as primiary example of a produced artefact)

- only handwritten text in the repos i own is this one -- rest are LLM produced but mostly reviewed/adapted. repos act as holders of product, with its document and maintance info. but even more, they hold llm-longterm memory about how to act and work in the repo so it may be sometimes difficult to navigate. i've tried to keep it tidy, acceptance-format is clean as it can be comparable to the rs-verified-der. at one point i will audit/clean up rs-verified-der itself, but this is not my current priority. priority is that repos do not overstate their results and claims while also not losing the history and all important data (and rules for llm workers). i will at one point audit and clean up things, but first need learning on what is best approach. i've addopted simple technical english (where possible) and arc42 organization which seems to keep repos more clean.

- llms used are claude as main think and workhorse, chatgpt and gemini as cross class reviewers (would like to include more cross model reviewers when i can). i dont consider this critical thing: work done by llms may be considered nondeterministic programing and with sound and correct proofs being the target of FV work we could assume imporant thing is that llms need to be "good enough heuristic" to be able to jump from local maximas when searching for a good proof for a certain item. i.e FV has strong oracles therefore llm failures may be local failure but longterm oracle-grounding should straighten any local failure, at least when we talk about proofs.

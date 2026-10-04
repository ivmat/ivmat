## in few words

my goal: see how far llms plus formalization can take everyday software work, starting with my own projects, and share what holds up.

reduce assumptions, never eliminate them — and know what's left.
also, formalize.
also also, check [acceptance-format](https://github.com/ivmat/acceptance-format) - i consider this first useful public repo i have and would suggest you try to use it on your system.

## preface

why does this page exist? because i want to share how i envision what software production will be in 10 years, not bound by legacy limitations. also i would like to find people interested in same topics and results. especially if you have any more ideas, critcisms, counterexamples or similar work ( ivomatijasevic@gmail.com ).

i am quite confident we are nowhere near the end what the combination of human ingenuity and llms and the missing element in my view, formalization, can bring. 

i do work here in my personal time as a personal project - i want to build a system that automates many aspects of my life but also would like to share findings with the world. other reason why i publicize most of it: to show the world i know what i'm talking about and direction of what im doing (most of the time). a short talk or mail correspondance doesnt show much and i am not involed in academia.... so best way is to show and produce something useful to the world in open format.

## me
- masters in math and CS
- 10+ years in Erlang systems

## foundry engine and crystal

i started with the idea of foundry and the underlying crystal - just my ilustative way to describe it. ive built 4 iterations of foundry and stopped on 5th - too large of a project and started way too early. every pillar below is really a pillar for the foundry...

to explain what it is - an artefact producing engine with spaces for LLMs and people both but mostly mechanized - really consider an automatic code producing machine. LLMs can do this today , i understand but there is no guaranteee the code is correct. main point of foundry is the gating and valiation become critical elements of the artefact itself. but alas, it was too big of a project and is now stopped and as mentioned i now focus on 3 pillars that first need to be well developed before i consider reopening the foundry.

and crytal - its a corpus of lean proofs underlyign the foundry GROUDING it in reality. autoprover core is really a crystal core however its generaliyed so it has use in verificaiton work. foundry is not one program: its an idea which can be adapted. consider producing game software and control software for airplane. you cannot model a producing engine in same way: one accepts bugs as normal but other one has a bug, well not good. so foundry can have different assumptions and definitons but - the core - is invariant. model of such foundry is in the crystal - deepest groundign possible. variant theorems are also to be added to the crystal as need grows but really every foundry build is better built to a larger crystal which grows.

- of course none of the steps here are easy or really manageable by one person but i think steps are feasible and necessary longterm for llm-generated code in serious enough systems. autonymous artefact-producing-systems still need to be easily auditable, person-overridable and safe -- that's the point of "shift left" move: reduce problem-source surfaces to specs and mechanize most elements so no hidden non-wanted intend leaks into produced artefacts (in general, we talk about code, i.e commit as primiary example of a produced artefact)

## pillar 1 — model checking and formal verification

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
- the most critical parts of the core of a system need to be:
    - **CORRECT** — satisfies the SPEC on *every* input, covered by proofs and tests
    - **SOUND** — no panics, no undefined behavior, no silent corruption
    - **SECURE** — the properties that protect users hold by construction, not by testing effort

## pillar 2 — protocols and formats

_(written by claude, from my notes — i'll rewrite it later)_ a check only helps if its result can travel. this pillar is about the shapes that carry work between whoever produces it and whoever accepts it — a person, an llm, or a program. a protocol fixes the steps: what is asked, what is delivered, who decides. a format fixes the record: the claim, its evidence, its assumptions and its open gaps, in a file a tool can re-check without trusting the producer. [acceptance-format](https://github.com/ivmat/acceptance-format) is the public example; [accepted-work](https://github.com/ivmat/accepted-work) holds the formats around an acceptance decision (duties, dependencies, checks, findings).

- we need an easy way to ship code together with its spec and correctness proofs (and any extra tests for what the model checks don't cover)

- dont have patience at the moment to type it all so check pretty readme for more

## pillar 3 — intent and specification

llms make it easy to check code against the spec, but the hard part then is: what should the spec say. this still stays critically people endeavour due to intent agreement. (even though llms may draft and do the "mechanical" part). once llms cover model checking, our focus should move to specs.

## working principle — ground what can be grounded

every system rests on assumptions. the dangerous ones are the hidden ones — trust taken without ever being named. our way of work: either a statement is proven correct from other statements and/or assumptions OR it is stated as assumed.
one obvious place where we assume correctness without explicitly stating it: we trust 3rd party libs, tools, compilers, hw, etc. with llms we should make these assumptions loud... also acceptance format is created exactly for that.

goal: prove the whole chain, from core assumptions up to the actual code running for a given system. meaning: we prove facts and/or correctness of the specs until we hit definitions and rules/principles good enough to prove against.
in other words: EVERYTHING becomes mathematics, not just mathematics and theoretical physics :) — because llms make it cheap

reduce assumptions, never eliminate them — and know what's left

## public work today

- [acceptance-format](https://github.com/ivmat/acceptance-format) - a format that records what verification decided including what it did not, and refuses weight rather than inflating it. artifact agnostic, so its not only for rust code but any artifact that can be grounded by an oracle.
- [autoprover-core](https://github.com/ivmat/autoprover-core) - core pattern of "proof producing autonymous LLM based machine" (used for showcase)
- [rs-verified-der](https://github.com/ivmat/rs-verified-der) — a partially formally verified DER (X.690) encoder/decoder in rust. kani for memory safety and bounded correctness, aeneas → lean for functional correctness of the pure core. i also back kani and aeneas, since my work relies on them.
- [accepted-work](https://github.com/ivmat/accepted-work) - record formats for accepted work, developed in public. still in development, so no open licence yet: public to read, all rights reserved. the licence opens once the formats are in use in my own systems. or if you want them, ping me and i will put them under MIT if you want to use them before they have been proven at least once.
- contributions to acceptance-format are welcome. for accepted-work, comments are welcome for now. either way, mail me: ivomatijasevic@gmail.com

- i looked for existing papers on the subject and 'did not find the same synthesis or threshold formulation', to be more precise, so i wrote four preprints:
    - [a fault-tolerance threshold for gated agentic computation](https://zenodo.org/records/20820968)
    - [generated gates inherit their generator's blind spots](https://zenodo.org/records/20837102)
    - [escape, cost, and correlation at the verification floor of gated agentic computation](https://zenodo.org/records/21456783)
    - [progressive semantic mechanization: compiling intellectual work into deterministic programs with typed semantic holes](https://zenodo.org/records/23119225)

## some thoughts on llms

i consider llms necessary but kind of like mitochnordria is for cell. yes, you would not have complex mulicellular organisms without it but still its not the main target. its a neccessray ingreedeint (not ideal comparison but - just for scale of multiceluar organism and systems i woudl say llms could build)

another comparisson i like to use: llms used today are like 18th century clerks, they do everything manually, or maybe build themselves some useful tools. to get "nonviby" output we need to first gate but maybe more importantly formalize the way work output is combined into larger outputs.

## some thoughts on mathematics

i think the future needs more mathematicians, not fewer. machines will increasingly produce the proofs... but - what i consider at least, mathematics is the science of structures: every possible combination of definitions, axioms and logics (what does this not cover?). point is people with math bacground are good with formalizations and generalizations and this is something really missing in the vibed world.

## pretty readme

_(update, llm-filled: the pretty readme is now claude's own introduction of me and my work — not a polished copy of this page.)_

i propose you read [pretty readme](pretty_readme.md). its not just pretty, its refined and more accurate representation of ideas i wanted to share. i dont have patience for it all, and llms are  grammarly for idea expresion -- steering the llm output is orders of magnitute simpler than writing it precisely myself, especially when talking about rigourous things. i do review it and i find it more clearly represents the ideas i want to share. i still keep this readme handwritten, with all the roughness it brings since its direct output of me typing on the keyboard.

- one of only handwritten texts in the repos i own is this one -- rest are LLM produced but mostly reviewed/adapted. repos act as holders of product, with its document and maintance info. but even more, they hold llm-longterm memory about how to act and work in the repo so it may be sometimes difficult to navigate. i've tried to keep it tidy, acceptance-format is clean as it can be comparable to the rs-verified-der. at one point i will audit/clean up rs-verified-der itself, but this is not my current priority. priority is that repos do not overstate their results and claims while also not losing the history and all important data (and rules for llm workers). i will at one point audit and clean up things, but first need learning on what is best approach. i've addopted simple technical english (where possible) and arc42 organization which seems to keep repos more clean.

- llms used are claude as main think and workhorse, chatgpt as cross class reviewer. i dont consider this critical thing: work done by llms may be considered nondeterministic programing and with sound and correct proofs being the target of FV work we could assume imporant thing is that llms need to be "good enough heuristic" to be able to jump from local maximas when searching for a good proof for a certain item. i.e FV has strong oracles therefore llm failures may be local failure but longterm oracle-grounding should straighten any local failure, at least when we talk about proofs.

---
title: 'A smart folder? A working approach to organizing project knowledge'
sources: []
sessions: ["2026-10-26"]
---

*Have you ever chatted with your own files? What if that conversation helped you examine not only their contents, but how you were developing the project itself?*

![The project folder connects the work, working instructions and development history. A human and AI assistant engage with those records; human review selects updates that return to the folder. People decide what to preserve, checks catch some inconsistencies, and the record remains incomplete.](assets/smart-folder-overview.png){#fig-smart-folder width=100% fig-alt="A cycle connecting project files and working context, human–AI interaction, and human review that selects updates to the folder."}

That question introduces what I am exploring here. Beyond asking an AI assistant to summarize documents, I am working with a folder that records instructions, sources, discussions, decisions, and current understanding—and makes some relationships among them explicit.

The conversation can then turn toward the work's development: Where did this interpretation come from? What changed? Which assumptions remain unresolved? What should we revisit next?

## From keeping files to preserving relationships

Folders already help us organize work through filenames, locations, and versions. But reconstructing why something changed often depends on our memory, an email exchange, or a colleague's explanation.

In this project, I am trying to record selected relationships alongside the files:

- A current interpretation points to the discussions and sources behind it.
- A decision records its rationale and status.
- A session identifies what changed and what remains unresolved.
- A project-state record identifies the next work to undertake.

The aim is to make those connections available when returning to the project. Whether the record is sufficient—or too demanding to maintain—remains part of the exploration.

## What travels with the folder?

The workspace carries both project content and guidance for engaging with it.

| Element | What it contributes |
| --- | --- |
| Working instructions | Explain the project's purpose, responsibilities, boundaries, and reading order. |
| Current project state | Identifies open decisions, next actions, and unfinished work. |
| Session records | Preserve selected discussion, changes in understanding, and unresolved questions. |
| Decision records | Identify choices, their rationale, and whether they remain active. |
| Synthesized knowledge | Separates current understanding from the history of its development. |
| Sources and assessments | Record supporting material, what was checked, and the limits of that reading. |
| Links and metadata | Connect these records so their relationships can be followed. |
| Automated checks | Detect specified inconsistencies, such as references to missing sources or sessions. |

For example, `AGENTS.md` tells an assistant how to begin working in this repository, including what to read and which actions require authorization. Those instructions are also readable by a person. They guide work; they do not guarantee compliance.

Likewise, an automated check can establish that a source identifier exists. It cannot establish that the source supports the argument being made.

## What does the conversation add?

An AI assistant can work with the available records to help locate relevant material, compare formulations, identify apparent inconsistencies, and propose revisions.

The interaction becomes more specific when the folder carries an explicit working context. Instead of repeatedly explaining the project from the beginning, I can ask questions such as:

> How does this proposal relate to our recorded decisions?

> Which parts of this account have been checked, and which remain my interpretation?

> What would need updating if we changed this definition?

The assistant's response still needs review. It may overlook material, misunderstand a relationship, or produce a plausible reconstruction that the records do not support. The files provide grounds for examining its answer.

## A small example from this project

During development of the presentation, we explored several meanings for a symbol in the conceptual model. Through discussion, I accepted a working definition while leaving its foundations and diagrammatic use open for further review.

We then preserved a checkpoint connecting:

```text
Discussion and alternatives considered
                  ↓
Accepted working definition
                  ↓
Updated synthesis and decision record
                  ↓
Questions requiring further review
```

The checkpoint records a change in the project's understanding. It does not turn that understanding into a verified claim.

Choosing to preserve that moment also became part of the discussion: I was deciding that this change was consequential enough to record before continuing. The record therefore reflects judgment about what matters, rather than capturing everything that happened.

The [October 26 session](../sessions/2026-10-26.md#conceptual-checkpoint-before-review), [current synthesis](../knowledge-base/01_core-thesis-and-contribution.md) and [decision](../admin/decisions-register.md#working-w-prime-and-challenge-narrative) provide a concrete trail to follow.

## Why “smart”—and why the question mark?

“Smart” describes the arrangement I am exploring: content accompanied by instructions, explicit relationships, and checks that can support further interaction.

It does not mean the folder understands the project. Its usefulness depends on people recording enough context, recognizing errors, and maintaining the connections.

The question mark also reflects a practical difficulty encountered in TAPs development. Preserving interactions and developing knowledge produced an administrative burden that interfered with product work. More documentation was not automatically more useful.

This repository is another attempt to work through that tension. It introduces further questions:

- What deserves preservation, and what can be left out?
- When does a discussion belong in the current synthesis?
- How do we distinguish an accepted decision from a plausible suggestion?
- Can another person follow the record without the original conversations?
- How much effort does maintaining the structure require?
- Which instructions and organizational choices remain appropriate as the project changes?

## Where the work stands

The repository currently contains editable records, working instructions, linked source and session metadata, provenance checks, and browsable project pages. The author retains responsibility for its claims and decisions, and the records remain maintainable without AI.

I will present it as one approach emerging from the work: a response to difficulties in preserving and engaging with developing project knowledge that brings its own choices and demands.

The open question is what this arrangement makes possible in practice—and what we learn about our working approach by trying to use it.

<!-- Assistant-prepared draft authorized for addition by the author. Graphic is
     deterministically drawn with tools/render-smart-folder.ps1; no external assets.
     This page describes the work in progress, not a team-adoption proposal. -->

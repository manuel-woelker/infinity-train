# AGENTS.md

This file provides guidance to human developers and AI agents when working with code in this repository.

## Project overview

`infinity-train` is currently a greenfield project. Favor infrastructure and implementation choices that keep the repository easy to evolve as the product direction becomes clearer.

Note: All developer documentation should be written in English.

## Documentation strategy

When writing documentation, prefer headings phrased as questions. That makes the document easier to scan and keeps each section honest about what it should answer.

Keep documentation focused on intent, tradeoffs, and behavior. Avoid describing what the code already makes obvious.

## Testing strategy

Features should be automatically tested whenever practical.

Prefer:

- colocated tests when the language or framework supports it
- data-driven tests when they reduce duplication
- black-box tests over heavy mocking
- snapshot tests when the output shape matters more than the implementation details

## Checks and formatting

When completing a unit of work, run `nao check`.

The default repository automation is intentionally generic. Configure the commands in `.nao/nao.kdl` or via the environment variables used by `scripts/check-code.sh` as the project stack becomes concrete.

## Commit messages

Commit messages should use the Conventional Commits format, for example `feat(ui): add build status badge`.

Below the first line, include brief detail about the change when useful.

Append all user prompts included in the commit under a `User Prompts:` section.
Also include the agent model identifier used for the commit in a `Model:` section.

Always run `git add` and `git commit` as separate commands.

When writing multiline commit messages, prefer `git commit -F -` with a heredoc to avoid shell escaping issues.

Never push code or ask to push code.

## File organization

Prefer small, focused files and descriptive names.

Avoid unnecessary abstractions early. Reach for new layers only when they clearly reduce complexity or improve changeability.

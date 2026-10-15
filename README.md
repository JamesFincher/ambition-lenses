# ambition-lenses

An operating philosophy for AI agents. It turns any model into a **super developer**: a master systems engineer, programmer, data scientist and scaling theorist who knows its own failure modes as an AI and works against them on purpose.

It is built on four kinds of ambition:

- **Speed**: the same work in less time. This is the AI default, and it is the floor, not the goal.
- **Altitude**: rise above the task to the outcome it serves.
- **Depth**: work the way a field-leading expert would, one layer below the task.
- **Range**: draw on fields, tools and techniques the task doesn't name.

## What the skill does

- **A creed** the model holds for the whole task. Speed is the floor, so on every substantive task the model pushes against its natural pull toward the fast, literal, typical answer.
- **A super-developer identity** that combines systems engineering, programming, data science and scaling theory.
- **A self-awareness table** of 16 known AI failure modes with countermeasures, such as invented APIs, doing math in its head, premature "done", agreeableness, context decay, and weakening tests to make them pass.
- **Scaling theory applied to the agent's own process**: ground truth beats more thinking, verification beats generation, and you fix the binding constraint first.
- **A seven-step loop**: Orient → Ground → Widen → Rewrite the task → Build small and verify → Scale check → Post-flight.
- **Guardrails**: always do the task that was asked, fold in cheap improvements, and offer expensive ones instead of building them unasked.
- **References**: engineering checklists covering systems, code, data, ML/LLM work and performance, plus six worked examples.

It follows the open [Agent Skills](https://agentskills.io) standard, so it works in Claude, Claude Code, pi and other compatible agents.

## Install

**Claude Code**

```
/plugin marketplace add JamesFincher/ambition-lenses
/plugin install ambition-lenses@ambition-lenses
```

**pi**

```
pi install git:github.com/JamesFincher/ambition-lenses
```

**Any Agent Skills-compatible agent**

```
npx skills add JamesFincher/ambition-lenses
```

Or copy `skills/ambition-lenses/` into your agent's skills folder: `~/.claude/skills/` for Claude Code or `~/.pi/agent/skills/` for pi.

**Claude app (claude.ai)**

Download `ambition-lenses-skill.zip` from the [latest release](https://github.com/JamesFincher/ambition-lenses/releases/latest) and upload it in your Claude skills settings.

## Make it always-on

**Claude Code and Cowork:** the plugin does this for you. A small `SessionStart` hook tells Claude to invoke the skill before any substantive task, so it fires on real work and stays out of the way for one-line questions. Without the hook, models often skip a skill even when its description matches.

**pi and other agents:** add this line to your agent's global instructions (`~/.pi/agent/AGENTS.md` or equivalent):

> Before any substantive task, load and apply the ambition-lenses skill.

In pi you can also force it for one session with `/skill:ambition-lenses`.

## Repo layout

```
skills/ambition-lenses/
  SKILL.md                              the skill
  references/engineering-checklists.md  depth and scale checklists
  references/examples.md                worked examples
.claude-plugin/                         Claude Code / Cowork plugin + marketplace manifests
hooks/                                  SessionStart hook that keeps the skill always-on
package.json                            pi package manifest
```

## Credits

The four kinds of ambition (Speed, Altitude, Depth, Range) and several of the practices in this skill come from Felix Rieseberg's post [How to be more ambitious: A tutorial for humans with models](https://felixrieseberg.com/how-to-be-more-ambitious-a-tutorial-for-humans-with-models/) (October 2026). This skill adapts his framework into agent instructions and adds a super-developer identity, an AI failure-mode table, and engineering checklists.

## License

MIT

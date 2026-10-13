# Shadow Run

**Shadow Run** is a 2D action-platformer built with **Godot 4** where movement, stealth, timing, and a living shadow mechanic are combined into short replayable levels.

Play the browser version here:

**https://yass29.github.io/shadow-run/**

---

## About the game

In Shadow Run, the player moves through a dark futuristic city after the Core begins erasing memories and controlling the population.

The main mechanic is the ability to transform into a **Shadow form**. Shadow form is not simply an invincibility mode: different hazards, enemies, gates, puzzles, and routes require switching between normal and Shadow states at the right moment.

The game currently includes:

- 6 playable levels
- Shadow transformation and Shadow Dash
- drones and Hunter enemies
- moving platforms and timed gates
- blackout zones
- Shadow-only portals and switches
- hidden routes and collectible memories
- collectible shards and character skins
- S / A / B / C level grades
- best-time tracking
- checkpoints
- a final Core Sentinel boss encounter
- story intro and ending sequences
- browser save/progression support

---

## Built with

- **Godot 4**
- **GDScript**
- 2D physics and collision systems
- procedural 2D shapes and UI
- Godot scene system
- Web export / WebAssembly
- Git and GitHub
- GitHub Pages

The game was designed to run directly in the browser using Godot's **GL Compatibility** renderer.

---

## What I learned

Shadow Run started as a small experiment and gradually became a much larger project.

While building it, I learned how to:

- structure a game using reusable Godot scenes and scripts
- work with CharacterBody2D, Area2D, StaticBody2D, and AnimatableBody2D
- design collision layers and gameplay interactions
- implement player movement, jumping, dashing, and alternate player states
- create enemy behavior and simple AI
- design checkpoints, hazards, collectibles, puzzles, and boss mechanics
- build persistent progression and save data
- create menus, character selection, level selection, and result screens
- design replayability through grades, best times, secrets, and unlockable cosmetics
- create visual feedback with particles, camera effects, transitions, and procedural audio
- debug gameplay problems such as impossible obstacles, unfair collision zones, and progression bugs
- export a Godot project to WebAssembly
- deploy a playable game using GitHub Pages
- use Git branches, pull requests, commits, and iterative testing throughout development

One of the biggest lessons was that making a game fun is not just about adding features. A large part of the work was **testing, removing frustrating mechanics, balancing difficulty, improving feedback, and repeatedly redesigning levels based on how they actually felt to play**.

---

## AI-assisted development

This project was built with the help of **AI-assisted development using ChatGPT**.

I used AI as a development tool for things such as:

- brainstorming gameplay mechanics
- helping write and refactor GDScript
- debugging errors
- reviewing level design ideas
- generating implementation approaches
- planning Git/GitHub workflows
- iterating faster on UI, progression, and game systems

I remained responsible for the game's direction, feature choices, playtesting, balancing, debugging feedback, and deciding what stayed or was removed.

Using AI on this project also taught me how to work effectively with AI-generated code: **understanding what it does, testing it, identifying failures, giving precise feedback, and iterating until the system behaves correctly**.

---

## Game design philosophy

I wanted Shadow Run to reward switching between abilities instead of allowing one mechanic to solve everything.

For example:

- drones encourage Shadow stealth
- some hazards force the player back into normal form
- Shadow Rifts create alternate routes
- Shadow switches unlock paths
- Hunters continue searching your last known position
- timed sections reward movement and planning
- hidden memories reward exploration
- grades and best times encourage replaying levels

The goal is to create a simple control scheme with increasingly interesting decisions.

---

## Current status

Shadow Run is currently a playable browser prototype / early indie game build.

I am continuing to improve:

- game feel
- level pacing
- visual polish
- accessibility
- sound and music
- storytelling
- balancing
- player feedback

---

## Play

**Browser:** https://yass29.github.io/shadow-run/

Controls:

- **Arrow Keys** — Move
- **Space** — Jump
- **Shift** — Shadow form
- **Shift + E** — Shadow Dash
- **Esc** — Pause / menu

---

## Repository

Built and maintained by **Yass29** as a personal game-development and programming project.

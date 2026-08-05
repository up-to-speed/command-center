# Command Center

**Don't let AI slop ruin your codebase.**

The fastest code-review and refactoring agent — turn good code into great code 20× faster.

Website: **[cc.dev](https://www.cc.dev/)**

---

## Install

### Desktop app (recommended)

Download for macOS, Linux, or Windows from **[cc.dev](https://www.cc.dev/)**.

### NixOS

The AppImage cannot run directly on NixOS — its bundled binaries hardcode
`/lib64/ld-linux-*` and other FHS library paths that NixOS does not provide. This
repo publishes a flake that wraps it in an FHS sandbox:

```bash
nix profile install github:command-center-ai/command-center
```

Or try it without installing:

```bash
nix run github:command-center-ai/command-center
```

To pin it in a system or home-manager configuration, add this repo as a flake
input and use `overlays.default`, which provides `pkgs.command-center`. Command
Center is proprietary, so the package is marked unfree — set
`nixpkgs.config.allowUnfree = true` (the flake's own outputs already do).

Updates come from your package manager rather than the app's built-in updater,
which cannot work against a read-only Nix store:

```bash
nix profile upgrade --refresh command-center
```

### CLI

```bash
npm install -g @command-center/command-center
```

After install, run `command-center` to start the local service, then open <http://localhost:9000/>.

---

## What is this?

Command Center makes you far more productive at wielding AI coding agents, beginning with solving what for many is the largest bottleneck: understanding the code that an agent has written.

GitHub-style diffs update live as the agent modifies your code. Add Hooks, Subagents, Commands, MCP & Tools in seconds with no configuration.

---

## A note on this repository

This repo previously hosted standalone binary releases. Those release URLs continue to work via GitHub's redirect, but the **canonical install paths are now [cc.dev](https://www.cc.dev/) (desktop app) and npm (CLI)** — please use those.

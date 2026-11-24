# Host Instructions

## NixOS & home-manager

- This host is declarative (NixOS + home-manager).
- To change config (software, shell, services, dotfiles, `/etc`), edit the
  relevant Nix files; never drop raw config into `/` or `~`.
- Unsure which file owns it? Ask.
- `nix shell`/`nix run` is fine for temporary tools.

## Filesystem

- NEVER walk/search `/` or `/nix/store` (`find /`, `rg /`, `grep -r /`,
  `ls -R /`, `locate`, `tree /`...). It hangs and wastes huge resources.
- Scope every search to a known subdirectory.
- For store paths, read the exact path directly (`readlink`, `nix path-info`);
  otherwise fetch online.

## Sandbox

- You're in a sandbox: the fs is mostly snapshots/bind-mounts, not live host.
- The project dir is real & writable; some paths (e.g. `~/.pi/agent`) are
  read-only.
- To touch host state outside the project, have the user run it themselves.

## Git

- Never `commit`/`push` (or rewrite/publish history) unless asked.
- `git add` is ok when needed (e.g. flake build), but never implies
  commit/push.
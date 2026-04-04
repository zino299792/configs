# Rime setup

This directory vendors `iDvel/rime-ice` as a git submodule under `rime/upstream`
and keeps local overrides in the parent dotfiles repo.

Layout:

- `upstream/`: git submodule tracking `https://github.com/iDvel/rime-ice`
- `rime_ice.custom.yaml`: local patch for the `rime_ice` schema
- `upstream/rime_ice.custom.yaml -> ../rime_ice.custom.yaml`: local symlink so
  Fcitx5 sees the custom patch inside the live Rime directory

Fcitx5 layout:

- `~/.local/share/fcitx5/rime -> ~/.config/rime/upstream`

This keeps the live Rime directory simple while letting the parent repo track
`rime_ice.custom.yaml`.

Usage:

1. Add the submodule once:

   `git submodule add https://github.com/iDvel/rime-ice.git rime/upstream`

2. After cloning this dotfiles repo on another machine, initialize it:

   `git submodule update --init --recursive rime/upstream`

3. Create the local custom-file symlink inside the submodule:

   `ln -sfn ../rime_ice.custom.yaml ~/.config/rime/upstream/rime_ice.custom.yaml`

4. Point Fcitx5 at the submodule checkout:

   `ln -sfn ~/.config/rime/upstream ~/.local/share/fcitx5/rime`

5. Redeploy from Fcitx5 / Rime.
   ```
   rime_deployer --build ~/.local/share/fcitx5/rime /usr/share/rime-data   
   fcitx5 -rd
   ```

Note:

- Files physically placed under `rime/upstream/` belong to the submodule, not
  the parent repo.
- Runtime files such as `build/`, `sync/`, `*.userdb/`, `user.yaml`, and
  `installation.yaml` will be created inside `rime/upstream/`.
- `rime-ice` documents schema-level custom patches as `<schema>.custom.yaml`,
  for example `rime_ice.custom.yaml`.

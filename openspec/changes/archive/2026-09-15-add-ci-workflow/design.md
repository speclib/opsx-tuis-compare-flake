# Design: CI workflow

## One system, not three

The briefing says CI only needs to prove one. `nix flake check --all-systems`
on a Linux runner evaluates the darwin outputs but cannot build them, so the
extra coverage it buys is evaluation only, which a local run already gives.
The workflow runs the plain `nix flake check` and leaves cross-platform builds
out until someone needs them.

## Why a tolerant default build

`packages.default` does not exist until milestone 06. A workflow that hard-fails
on its absence would be red for most of this run, which trains everyone to
ignore it. The step asks the flake whether the attribute exists and skips with a
notice when it does not, so the first red build is a real one.

## Cache

`cachix/install-nix-action` plus the public `cache.nixos.org` is enough. No
private binary cache, because the interesting cost here is the Go and Rust
builds, and those are not shared with anyone yet.

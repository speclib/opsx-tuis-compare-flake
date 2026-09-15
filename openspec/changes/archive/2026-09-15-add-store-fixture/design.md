# Design: the store fixture

## Registration runs inside the build sandbox

`openspec store register` writes to the machine's store registry under
`$XDG_DATA_HOME/openspec/stores/`. The briefing forbids touching the user's
real one, and this repo's permission policy deliberately leaves the command off
the allowlist so that running it on a developer's machine prompts.

Running it inside a Nix build is the stronger form of the same guarantee: the
sandbox makes reaching the real registry impossible rather than merely
discouraged, so the protection does not depend on anyone reading a prompt
carefully. The scenario then asserts where the registry actually landed:

```
ok  /build/work/sandbox/home/.local/share/openspec/stores/registry.yaml
```

## What the scenario proves beyond registration

Registering and listing would pass even if `--store` silently resolved to the
working directory. The scenario therefore also runs an unscoped `openspec list`
from inside the fixture and asserts the store's change is absent, which is the
"silently editing plans in the wrong repo" failure the briefing's section 7
names as the thing to get right.

Its falsification is an unregistered id, which must be refused rather than
quietly falling back.

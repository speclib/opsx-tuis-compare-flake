# Derive a package version from a flake input, so a build is honest about being
# a snapshot of a date rather than an upstream release.
#
# Returns "0-unstable-YYYY-MM-DD+<shortRev>". Both halves degrade on their own:
# a local path input has no rev, and an input with no lastModifiedDate still
# yields a usable string instead of throwing during evaluation.
{ lib }:

input:

let
  raw = input.lastModifiedDate or null;

  date =
    if raw == null then
      "unknown"
    else
      let
        s = builtins.toString raw;
      in
      lib.concatStringsSep "-" [
        (builtins.substring 0 4 s)
        (builtins.substring 4 2 s)
        (builtins.substring 6 2 s)
      ];

  rev = input.shortRev or "dirty";
in
"0-unstable-${date}+${rev}"

# ──────────────────────────────────────────────────────────────────────────
# Published from the private Command Center repository, which is the SOURCE OF
# TRUTH for this file: it lives there as `packaging/nix/flake.nix`, and is copied
# here by the `nix-flake` stage of that repository's release pipeline on every
# release. Edits made in this repository are silently overwritten by the next
# release — report a problem instead of patching it here.
# ──────────────────────────────────────────────────────────────────────────

{
  description = "Command Center — the fastest code-review and refactoring agent";

  inputs = {
    # Tracks nixos-unstable deliberately. This is the public distribution
    # channel and is intentionally NOT pinned to the internal dev environment's
    # nixpkgs revision — coupling them would let a dev-env bump churn what
    # users install.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachSystem
      [
        "x86_64-linux"
        "aarch64-linux"
      ]
      (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            # Command Center is proprietary, so the derivation is correctly
            # marked unfree. We are the vendor, so we allow it here rather than
            # making `nix run` fail on our own licence. Consumers using
            # overlays.default against their own nixpkgs still set allowUnfree
            # themselves.
            config.allowUnfree = true;
          };
          command-center = pkgs.callPackage ./package.nix { };
        in
        {
          packages = {
            inherit command-center;
            default = command-center;
          };

          apps.default = {
            type = "app";
            program = pkgs.lib.getExe command-center;
          };
        }
      )
    // {
      overlays.default = final: _prev: {
        command-center = final.callPackage ./package.nix { };
      };
    };
}

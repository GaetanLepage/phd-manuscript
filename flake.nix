{
  description = "PhD manuscript";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # Last revision with Typst 0.13.1
    # nixpkgs.url = "github:nixos/nixpkgs/01f116e4df6a15f4ccdffb1bcd41096869fb385c";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        { pkgs, ... }:
        {
          treefmt.config = {
            projectRootFile = "flake.nix";
            flakeCheck = true;
            programs = {
              nixfmt.enable = true;
              typstyle = {
                enable = true;
                lineWidth = 120;
              };
            };
          };

          devShells.default = import ./shell.nix { inherit pkgs; };
        };
    };
}

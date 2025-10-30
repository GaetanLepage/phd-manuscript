{
  description = "PhD manuscript";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # Last revision with Typst 0.13.1
    # nixpkgs.url = "github:nixos/nixpkgs/01f116e4df6a15f4ccdffb1bcd41096869fb385c";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      system = "x86_64-linux";
    in
    {
      devShells.${system}.default = import ./shell.nix {
        pkgs = import nixpkgs { inherit system; };
      };
    };
}

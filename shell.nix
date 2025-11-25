{
  pkgs ? import <nixpkgs> { },
}:
let
  fonts = pkgs.symlinkJoin {
    name = "typst-fonts";
    paths = with pkgs; [
      liberation-sans-narrow
    ];
  };
  font-paths = "${fonts}/share/fonts";
in
pkgs.mkShellNoCC {
  packages = with pkgs; [
    tinymist
    (typst.overrideAttrs (old: rec {
      version = "0.13.1";
      src = pkgs.fetchFromGitHub {
        owner = "typst";
        repo = "typst";
        tag = "v${version}";
        hash = "sha256-SGFD6KhBoFFL9mBS3Pdid7exDhWCfieLiFpt1C4SWHo=";
        leaveDotGit = true;
        postFetch = ''
          cd $out
          git rev-parse HEAD > COMMIT
          rm -rf .git
        '';
      };
      cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
        inherit src;
        inherit (old) pname version;
        hash = "sha256-4kVj2BODEFjLcrh5sxfcgsdLF2Zd3K1GnhA4DEz1Nl4=";
      };
      doCheck = false;
      doInstallCheck = false;
      postPatch = ''
        substituteInPlace tests/src/tests.rs --replace-fail 'ARGS.num_threads' 'ARGS.test_threads'
        substituteInPlace tests/src/args.rs --replace-fail 'num_threads' 'test_threads'
      '';
    }))
    typstyle
  ];

  env = {
    TYPST_FONT_PATHS = font-paths;
  };

  shellHook = ''
    TYPST_FONTS_LOCAL=".typst-fonts"
    rm -f "$TYPST_FONTS_LOCAL"
    ln -s "${font-paths}" "$TYPST_FONTS_LOCAL"
  '';
}

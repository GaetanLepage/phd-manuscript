{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShellNoCC {
  packages = with pkgs; [
    tinymist
    typst
    typstyle
  ];

  env = {
    TYPST_FONT_PATHS =
      let
        typst-fonts = pkgs.symlinkJoin {
          name = "typst-fonts";
          paths = with pkgs; [
            liberation-sans-narrow
          ];
        };
      in
      "${typst-fonts}/share/fonts";
  };
}

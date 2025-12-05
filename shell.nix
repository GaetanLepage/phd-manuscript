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
    typst
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

{ lib , stdenv , makeWrapper, nix-index, nix, fzy

# We use this to add matchers for stuff that's not in upstream nixpkgs, but is
# in our own overlay. No fuzzy matching from multiple options here, it's just:
# Was the command `, mything`? Run `nixpkgs.mything`.
, overlayPackages ? []
}:

stdenv.mkDerivation {
  pname = "comma";
  version = "1.1.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ nix-index nix fzy ];

  installPhase = let
    caseCondition = lib.concatStringsSep "|" (overlayPackages ++ [ "--placeholder--" ]);
  in ''
    mkdir -p $out/bin
    sed -e 's/@OVERLAY_PACKAGES@/${caseCondition}/' < , > $out/bin/,
    chmod +x $out/bin/,
    wrapProgram $out/bin/, \
      --prefix PATH : ${nix-index}/bin \
      --prefix PATH : ${nix}/bin \
      --prefix PATH : ${fzy}/bin

    ln -s $out/bin/, $out/bin/comma
  '';
}

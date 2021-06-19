{
  description = "Comma runs software without installing it";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
  flake-utils.lib.eachDefaultSystem (system:
  let
    comma = import ./. { pkgs = nixpkgs.legacyPackages.${system}; };
  in
  rec {
    packages.comma = comma;
    defaultPackage = packages.comma;
    apps.comma = flake-utils.lib.mkApp { drv = packages.comma; };
    defaultApp = apps.comma;
  });
}

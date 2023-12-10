{
  description = "xameer's emacs.d configuration";

  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixos, emacs-overlay, flake-utils }@inputs:
    let
      importer = overlays: system:
        (import nixos {
          system = system;
          overlays = overlays;
        });
    in ({
      overlays.default = with nixos.lib;
        let
          concatEmacsConfig = dir:
            foldl (a: b: a + b) "" (attrsets.mapAttrsToList
              (n: v: "${builtins.readFile (dir + "/${n}")}")
              (builtins.readDir dir));
        in (final: prev:
          (recursiveUpdate (builtins.listToAttrs (map (system:
            attrsets.nameValuePair ("xameer-emacs-${system}")
            ((importer [ emacs-overlay.overlay ]
              system).emacsWithPackagesFromUsePackage {
                config = concatEmacsConfig ./config/elisp;
                package = (importer [ emacs-overlay.overlay ] system).pkgs.emacs-pgtk;
                alwaysEnsure = true;
              })) flake-utils.lib.defaultSystems)) {
                xameer-emacs-source =
                  (prev.callPackage ./pkgs/xameer-emacs-source.nix { });
              }));
    } // (flake-utils.lib.eachDefaultSystem (system: rec {
      packages = {
        xameer-emacs-source = (importer [ self.overlays.default ] system).xameer-emacs-source;
        "xameer-emacs" = (importer [ self.overlays.default ] system)."xameer-emacs-${system}";
      };

      checks = packages;
    })));
}

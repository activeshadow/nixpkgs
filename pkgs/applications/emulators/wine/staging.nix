{ lib, callPackage, autoconf, hexdump, perl, python3, wineUnstable }:

with callPackage ./util.nix {};

let patch = (callPackage ./sources.nix {}).staging;
    build-inputs = pkgNames: extra:
      (mkBuildInputs wineUnstable.pkgArches pkgNames) ++ extra;
in assert lib.versions.majorMinor wineUnstable.version == lib.versions.majorMinor patch.version;

(lib.overrideDerivation (wineUnstable.override { wineRelease = "staging"; }) (self: {
  buildInputs = build-inputs [ "perl" "util-linux" "autoconf" "gitMinimal" ] self.buildInputs;
  nativeBuildInputs = [ autoconf hexdump perl python3 ] ++ self.nativeBuildInputs;

  prePatch = self.prePatch or "" + ''
    patchShebangs tools
    cp -r ${patch}/patches ${patch}/staging .
    chmod +w patches
    patchShebangs ./patches/gitapply.sh
    python3 ./staging/patchinstall.py DESTDIR="$PWD" --all ${lib.concatMapStringsSep " " (ps: "-W ${ps}") patch.disabledPatchsets}
  '';
})) // {
  meta = wineUnstable.meta // {
    description = wineUnstable.meta.description + " (with staging patches)";
  };
}

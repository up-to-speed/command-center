# ──────────────────────────────────────────────────────────────────────────
# Published from the private Command Center repository, which is the SOURCE OF
# TRUTH for this file: it lives there as `packaging/nix/package.nix`, and is copied
# here by the `nix-flake` stage of that repository's release pipeline on every
# release. Edits made in this repository are silently overwritten by the next
# release — report a problem instead of patching it here.
# ──────────────────────────────────────────────────────────────────────────

{
  lib,
  stdenv,
  fetchurl,
  runCommand,
  appimageTools,
  sources ? lib.importJSON ./sources.json,
}:

let
  pname = "command-center";
  inherit (sources) version;

  asset =
    sources.assets.${stdenv.hostPlatform.system}
      or (throw "command-center: no AppImage is published for ${stdenv.hostPlatform.system}");

  src = fetchurl { inherit (asset) url hash; };

  extracted = appimageTools.extractType2 { inherit pname version src; };

  # Strip the auto-updater config before wrapping. The Nix store is read-only and
  # there is no $APPIMAGE for electron-updater to rewrite, so leaving this in
  # place would let the app offer an "Install Update" that cannot possibly work.
  # Removing it makes isAutoUpdateConfigured() in
  # apps/electron/src/auto-update/update-mechanism.ts return false, which is what
  # routes the UI to the CC_UPDATE_CHANNEL path.
  contents = runCommand "${pname}-${version}-contents" { } ''
    cp -r ${extracted} $out
    chmod -R u+w $out
    rm -f $out/resources/app-update.yml
  '';
in
appimageTools.wrapAppImage {
  inherit pname version;
  src = contents;

  # appimage-run's default FHS set, plus the two libraries the bundled binaries
  # dlopen at runtime: libsecret backs Electron's safeStorage/keyring and
  # libnotify backs desktop notifications. Neither is a link-time dependency, so
  # omitting them fails at runtime rather than at build time.
  extraPkgs = p: [
    p.libsecret
    p.libnotify
  ];

  # Tells the app it was installed by a package manager, so the update UI points
  # at `nix profile upgrade` instead of driving electron-updater. Read by
  # getUpdateMechanism() in apps/electron/src/auto-update/update-mechanism.ts,
  # which is the only consumer — keep the value in step with the union there.
  #
  # This is deliberately the same value for profile and NixOS-system installs:
  # both come from this derivation, and nothing at build time knows which one it
  # will become. The app distinguishes them at runtime instead.
  profile = ''
    export CC_UPDATE_CHANNEL=nix
  '';

  extraInstallCommands = ''
    install -Dm444 ${contents}/*.desktop -t $out/share/applications

    # electron-builder emits Exec=AppRun; repoint it at the FHS wrapper. Rewriting
    # the whole line rather than matching the old value keeps this working if
    # electron-builder changes the template.
    sed -i "s|^Exec=.*|Exec=${pname} %U|" $out/share/applications/*.desktop

    if [ -d ${contents}/usr/share/icons ]; then
      mkdir -p $out/share
      cp -r ${contents}/usr/share/icons $out/share/icons
    fi
  '';

  meta = {
    description = "The fastest code-review and refactoring agent";
    longDescription = ''
      Command Center makes you far more productive at wielding AI coding agents,
      beginning with understanding the code an agent has written: GitHub-style
      diffs that update live as the agent works.

      This package wraps the official Linux AppImage in an FHS sandbox, because
      the bundled binaries hardcode /lib64/ld-linux-* and other FHS library
      paths that NixOS does not provide.
    '';
    homepage = "https://www.cc.dev/";
    downloadPage = "https://www.cc.dev/";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = pname;
  };
}

{
  lib,
  writeShellScriptBin,
  dbus,
  symlinkJoin,
  river,
  extraSessionCommands ? "",
  dbusSupport ? true,
  withBaseWrapper ? true,
  withGtkWrapper ? true,
  makeWrapper,
  wrapGAppsHook,
  gdk-pixbuf,
  glib,
  gtk3,
  extraOptions ? [],
}: let
  baseWrapper = writeShellScriptBin "river" ''
    set -o errexit
    if [ ! "$_RIVER_WRAPPER_ALREADY_EXECUTED" ]; then
      export XDG_CURRENT_DESKTOP=river
      ${extraSessionCommands}
      export _RIVER_WRAPPER_ALREADY_EXECUTED=1
    fi
    if [ "$DBUS_SESSION_BUS_ADDRESS" ]; then
      export DBUS_SESSION_BUS_ADDRESS
      exec ${river}/bin/river "$@"
    else
      exec ${
      if !dbusSupport
      then ""
      else "${dbus}/bin/dbus-run-session"
    } ${river}/bin/river "$@"
    fi
  '';
in
  symlinkJoin {
    name = "river-${river.version}";

    paths =
      (lib.optional withBaseWrapper baseWrapper)
      ++ [river];

    strictDeps = false;
    nativeBuildInputs =
      [makeWrapper]
      ++ (lib.optional withGtkWrapper wrapGAppsHook);

    buildInputs = lib.optionals withGtkWrapper [gdk-pixbuf glib gtk3];

    # We want to run wrapProgram manually
    dontWrapGApps = true;

    postBuild = ''
      ${lib.optionalString withGtkWrapper "gappsWrapperArgsHook"}
      wrapProgram $out/bin/river \
        ${lib.optionalString withGtkWrapper ''"''${gappsWrapperArgs[@]}"''} \
        ${lib.optionalString (extraOptions != []) "${lib.concatMapStrings (x: " --add-flags " + x) extraOptions}"}
    '';
  }

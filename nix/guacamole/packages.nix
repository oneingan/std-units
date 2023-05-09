{
  inputs,
  cell,
}: {
  default = inputs.nixpkgs.callPackage ./packages/default.nix {};
}
# guacamole> ------------------------------------------------
# guacamole> guacamole-server version 1.5.0
# guacamole> ------------------------------------------------
# guacamole>    Library status:
# guacamole>      freerdp2 ............ yes
# guacamole>      pango ............... yes
# guacamole>      libavcodec .......... no
# guacamole>      libavformat.......... no
# guacamole>      libavutil ........... no
# guacamole>      libssh2 ............. yes
# guacamole>      libssl .............. yes
# guacamole>      libswscale .......... no
# guacamole>      libtelnet ........... yes
# guacamole>      libVNCServer ........ yes
# guacamole>      libvorbis ........... yes
# guacamole>      libpulse ............ yes
# guacamole>      libwebsockets ....... no
# guacamole>      libwebp ............. yes
# guacamole>      wsock32 ............. no
# guacamole>    Protocol support:
# guacamole>       Kubernetes .... no
# guacamole>       RDP ........... yes
# guacamole>       SSH ........... yes
# guacamole>       Telnet ........ yes
# guacamole>       VNC ........... yes
# guacamole>    Services / tools:
# guacamole>       guacd ...... yes
# guacamole>       guacenc .... no
# guacamole>       guaclog .... yes
# guacamole>    FreeRDP plugins: /nix/store/74pcyn15rx6hgm3rzlm7rkhci3fr10g8-freerdp-2.10.0/lib/freerdp2
# guacamole>    Init scripts: no
# guacamole>    Systemd units: no


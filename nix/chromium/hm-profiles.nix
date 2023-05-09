{
  inputs,
  cell,
}: {
  default = {
    programs.browserpass = {
      enable = true;
      browsers = ["chromium"];
    };

    programs.chromium.enable = true;
    programs.chromium.package = cell.packages.ungoogled;
    programs.chromium.extensions = let
      extensions = [
        {
          name = "rabby";
          id = "acmacodkjbdgmoleebolmdjonilkdbch";
        }
        {
          name = "ublock-origin";
          id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
        }
        {
          name = "browserpass";
          id = "naepdomgkenhinolocfifgehidddafch";
        }
        {
          name = "metamask";
          id = "nkbihfbeogaeaoehlefnkodbefgpgknn";
        }
        {
          name = "urbit-visor";
          id = "oadimaacghcacmfipakhadejgalcaepg";
        }
        {
          name = "pricelabs.co";
          id = "ahfbjnblgpemcceknnebmkjgbgkfdfod";
        }
      ];
      nvfetcherChromiumExtension = _: v: {
        inherit (v) id version;
        crxPath = v.src;
      };
    in
      # passthru.sources = lib.mkChromiumExtensionsSource extensions
      #
      builtins.attrValues (builtins.mapAttrs nvfetcherChromiumExtension (builtins.removeAttrs cell.sources.generated ["override" "overrideDerivation"]));
  };
}

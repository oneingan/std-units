{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  l = nixpkgs.lib // builtins;

  inherit (nixpkgs) ungoogled-chromium writeText writeTextDir;
in {

  chromeExtensions = let

    nvfetcherToJson = ext: builtins.toJSON {
      external_crx = ext.src;
      external_version = ext.version;
    };
    
    generated = l.removeAttrs cell.sources.generated ["override" "overrideDerivation"];

    externalJson = _: ext: writeTextDir "${ext.id}.json" "${nvfetcherToJson ext}";
    
  in builtins.mapAttrs externalJson generated;
  
  extensions = let
    browserVersion = l.versions.major ungoogled-chromium.version;
    extensions-list = [
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

    # { rabby = { id = "acmacodkjbdgmoleebolmdjonilkdbch";};};
    # l.map mkChromeExt rabby

    # mkChromeExt = name: id: browserVersion: {
    #   $name = {
    #     src.cmd = "curl -L https://chrome.google.com/webstore/detail/${id} | sed 's/noscript//g' | ${nixpkgs.pup}/bin/pup 'meta[itemprop=\"version\"] attr{content}'";
    #     fetch.url =  "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc&extversion=$ver";
    #   };
    # };

    sourcesFile = list:
      writeText "sources.toml" ''
        ${(sourcesEntries list)}
      '';
    sourcesEntry = {
      name,
      id,
    }: let
      data = {
        rabby = {
          src = {
            cmd = "curl -L https://chrome.google.com/webstore/detail/${id} | sed 's/noscript//g' | ${nixpkgs.pup}/bin/pup 'meta[itemprop=\"version\"] attr{content}'";
            foo = "bar";
          };
          fetch.url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc&extversion=$ver";
          passthru.id = "${id}";
        };
      };
    in ''
      ${cell.lib.mkNvfetcher data}
      src.cmd = "curl -L https://chrome.google.com/webstore/detail/${id} | sed 's/noscript//g' | ${nixpkgs.pup}/bin/pup 'meta[itemprop=\"version\"] attr{content}'"
      fetch.url =  "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc&extversion=$ver"
      passthru = { id = "${id}" }
    '';
    sourcesEntries = list: let
      content = l.concatStringsSep "\n" (l.map sourcesEntry list);
    in ''
      ${content}
    '';
  in
    sourcesFile extensions-list;
}

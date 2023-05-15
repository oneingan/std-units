{
  inputs,
  cell,
}: let
  inherit (inputs.nixpkgs) fetchurl wrapFirefox firefox-unwrapped;
  ublock_origin = fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/3871774/ublock_origin-1.39.0-an+fx.xpi";
    hash = "sha256-8IQ591SEazISRRlbrJyr2QphJMQWJfI/7HFLLlVRMYc=";
  };
  i_d_c_a_c = fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/3859850/i_dont_care_about_cookies-3.3.4-an+fx.xpi";
    hash = "sha256-wBMqKFBLPeVq8QCIv98YnQNUAgFRXmFN4yvdpF6Nbto=";
  };
  browserpass = fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/3711209/browserpass-3.7.2-fx.xpi";
    sha256 = "15wjqpmxaahhjg03ai7wdysjmjjd4qwk3dc5g1lp8ckgnh2i8y5i";
  };
  privacy_redirect = fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/3815058/privacy_redirect-1.1.49.xpi";
    hash = "sha256-nxz25Y+j+G0YC1uZVJ+mZvqFOoJ8SMsjFVhWawwcPHU=";
  };
  nordvpn = fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/4096431/nordvpn_proxy_extension-2.73.8.xpi";
    hash = "sha256-pp/b4XIvozM5+PsUItO75l4TdaEJLmkAq150crKyZX8=";
  };
in {
  firefox = wrapFirefox firefox-unwrapped {
    extraPolicies = {
      CaptivePortal = false;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxAccounts = true;
      DontCheckDefaultBrowser = true;
      FirefoxHome = {
        Pocket = false;
        Snippets = false;
        SponsoredTopSites = false;
        SponsoredPocket = false;
        Highlights = false;
      };
      PasswordManagerEnabled = false;
      UserMessaging = {
        WhatsNew = false;
        FeatureRecommendations = false;
        ExtensionRecommendations = false;
        UrlbarInterventions = true;
        SkipOnboarding = true;
        MoreFromMozilla = false;
      };
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      Preferences = {
        "extensions.htmlaboutaddons.recommendations.enabled" = {
          Value = false;
          Status = "locked";
        };
        "browser.tabs.firefox-view" = {
          Value = false;
          Status = "locked";
        };
      };
      ExtensionUpdate = false;
      ExtensionSettings = {
        #default
        "*" = {
          installation_mode = "blocked";
          blocked_install_message = "Custom error message.";
        };
        # ublock
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "file://${ublock_origin}";
        };
        "jid1-KKzOGWgsW3Ao4Q@jetpack" = {
          installation_mode = "force_installed";
          install_url = "file://${i_d_c_a_c}";
        };
        "browserpass@maximbaz.com" = {
          installation_mode = "force_installed";
          install_url = "file://${browserpass}";
        };
        "{b7f9d2cd-d772-4302-8c3f-eb941af36f76}" = {
          installation_mode = "force_installed";
          install_url = "file://${privacy_redirect}";
        };
        "nordvnproxy@nordvpn.com" = {
          installation_mode = "force_installed";
          install_url = "file://${nordvpn}";
        };
      };
    };

    extraPrefs = ''
      // Show more ssl cert infos
      lockPref("security.identityblock.show_extended_validation", true);
      //lockPref("network.protocol-handler.app.afirma", "autofirma");
      lockPref("network.protocol-handler.warn-external.afirma", true);
      lockPref("network.protocol-handler.external.afirma", true);
      // Workaround firefox bug in sway #1628431
      lockPref("privacy.webrtc.hideGlobalIndicator", true);
      lockPref("privacy.webrtc.legacyGlobalIndicator", false);
    '';
  };
}

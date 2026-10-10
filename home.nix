{ config, pkgs, inputs, ... }: {
  home = {
    username = "krisk";
    homeDirectory = "/home/krisk";
    stateVersion = "26.05"; # dont mess with
    packages = with pkgs; [
      brightnessctl
    ];
  };
  programs.home-manager.enable = true;

  imports = [
    inputs.noctalia.homeModules.default
    inputs.nix-index-database.homeModules.default
  ];

  programs.firefox = {
    enable = true;
    languagePacks = [ "en-CA" ];
    policies = {
      AppAutoUpdate                 = false;
      BackgroundAppUpdate           = false;
      DisableFirefoxStudies         = true;
      DisableFirefoxAccounts        = true;
      DisablePocket                 = true;
      DisableTelemetry              = true;
      BlockAboutConfig              = false;
      BlockAboutProfiles            = false;
      BlockAboutSupport             = false;
      DisplayMenuBar                = "never";
      DontCheckDefaultBrowser       = true;

      ExtensionSettings = let
        moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
      in {
        "*".installation_mode = "blocked";
        "uBlock0@raymondhill.net" = {
          install_url       = moz "ublock-origin";
          installation_mode = "force_installed";
          updates_disabled  = true;
        };

        "firefox@tampermonkey.net" = {
          install_url       = moz "tampermonkey";
          installation_mode = "force_installed";
          updates_disabled  = true;
        };

        "sponsorBlocker@ajay.app" = {
          install_url       = moz "sponsorblock";
          installation_mode = "force_installed";
          updates_disabled  = true;
        };

        "simple-tab-groups@drive4ik" = {
          install_url       = moz "simple-tab-groups";
          installation_mode = "force_installed";
          updates_disabled  = true;
        };

        "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" = {
          install_url       = moz "auto-tab-discard";
          installation_mode = "force_installed";
          updates_disabled  = true;
        };
      };
    };
  };

  programs.noctalia = {
    enable = false;
    settings = {};
  };

  programs.niri = {
    settings = {
      input.touchpad.tap = false;
      input.touchpad.natural-scroll = true;
      input.keyboard.xkb.options = "caps:escape";
      layout.default-column-width.proportion = 0.5;
      binds = {
        "Mod+Shift+Slash".action.show-hotkey-overlay = {};
        "Mod+T".action.spawn = "kitty";
        "Mod+D".action.spawn = "fuzzel";

        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+ -l 1.0";
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          action.spawn-sh = "brightnessctl -d acpi_video0 -e s 1+";
        };
        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          action.spawn-sh = "brightnessctl -d acpi_video0 -e s 1-";
        };

        "Mod+O".action.toggle-overview = {};
        "Mod+Q".action.close-window = {};
        "Mod+F".action.maximize-column = {};
        "Mod+P".action.screenshot = {};
        "Mod+Shift+P".action.power-off-monitors = {};

        "Mod+H".action.focus-column-left = {};
        "Mod+J".action.focus-window-down = {};
        "Mod+K".action.focus-window-up = {};
        "Mod+L".action.focus-column-right = {};
        "Mod+Shift+J".action.focus-workspace-down = {};
        "Mod+Shift+K".action.focus-workspace-up = {};
        "Mod+Alt+H".action.move-column-left = {};
        "Mod+Alt+J".action.move-window-down = {};
        "Mod+Alt+K".action.move-window-up = {};
        "Mod+Alt+L".action.move-column-right = {};
        "Mod+Shift+Alt+J".action.move-column-to-workspace-down = {};
        "Mod+Shift+Alt+K".action.move-column-to-workspace-up = {};

        "Mod+Alt+W" = {
          allow-when-locked = true;
          hotkey-overlay.hidden = true;
          action.spawn-sh = "sudo bash ~/fix-wifi.sh";
        };
      };
    };
  };

  programs.nix-index-database = {
    comma.enable = true;
  };

  programs.nix-index.enable = true;

  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = "0";
      enable_audio_bell = "no";
    };
  };

  services.redshift = {
    enable = true;
    temperature = {
      day = 5500;
      night = 3500;
    };

    dawnTime = "6:00-8:00";
    duskTime = "19:00-21:00";
  };
}

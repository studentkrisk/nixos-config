{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix 
    inputs.niri-flake.nixosModules.niri
  ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.bash-prompt-suffix = " (nix shell)\\[ \\]";
  };


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  # potentially unnecessary?
  hardware.firmware = [
    (pkgs.stdenvNoCC.mkDerivation (final: {
      name = "brcm-firmware";
      src = ./firmware/brcm;
      installPhase = ''
        mkdir -p $out/lib/firmware/brcm
        cp ${final.src}/* "$out/lib/firmware/brcm"
      '';
    }))
  ];

  hardware.apple.touchBar = {
    enable = true;
    package = pkgs.tiny-dfr;
    settings = {
      MediaLayerDefault = true;
      EnablePixelShift = true;
      MediaLayerKeys = [
        { Time = "24hr";  Locale = "en_CA"; Action = "Time"; Stretch = 2;  }
        { Battery = "percentage";   Action = "Battery";        }
        # { Icon = "search";          Action = "Search";         }
        { Icon = "brightness_low";  Action = "BrightnessDown"; }
        { Icon = "brightness_high"; Action = "BrightnessUp";   }
        { Icon = "volume_off";      Action = "Mute";           }
        { Icon = "volume_down";     Action = "VolumeDown";     }
        { Icon = "volume_up";       Action = "VolumeUp";       }
      ];
    };
  };


  systemd.sleep.settings.Sleep = {
    AllowSuspend = "yes";
    AllowHibernation = "yes";
    AllowHybridSleep = "yes";
    AllowSuspendThenHibernate = "yes";
  };



  networking = {
    hostName = "krisk";
    networkmanager.enable = true;
  };

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_CA.UTF-8";
  console.keyMap = "us";

  hardware.bluetooth.enable = true;

  services = {
    upower.enable = true;
    libinput.enable = true;
    libinput.touchpad.tapping = false;
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0="75";
        STOP_CHARGE_THRESH_BAT0="80";
        PLATFORM_PROFILE_ON_BAT="low-power";
      };
    };
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
          user = "greeter";
        };
      };
    };
  };


  users.users.krisk = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };


  nixpkgs.config.allowUnfree = true; # =(


    environment.systemPackages = with pkgs; [
      vim-full
      wget
      git
      fuzzel
      unzip
      xdg-utils
      wl-clipboard
      kdePackages.dolphin
      quickemu
      gh
      bulletty
      obsidian
      python3
      anki
      lutris
      musescore
      fooyin
    ];


    system.stateVersion = "26.11"; # do not change!!!

    programs.niri.enable = true;
  }


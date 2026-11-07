{ config, pkgs, inputs, lib, ... }: {
  home = {
    username = "krisk";
    homeDirectory = "/home/krisk";
    stateVersion = "26.05"; # dont mess with
    packages = with pkgs; [
      brightnessctl
      xwayland-satellite
      wl-clipboard

      python3

      fooyin
    ];
  };
  programs.home-manager.enable = true;

  imports = [
    inputs.nix-index-database.homeModules.default
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config.niri = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };
  };

  programs.firefox = 
  let
    lock-true = {
      Value = true;
      Status = "locked";
    };
    lock-false = {
      Value = false;
      Status = "locked";
    };
  in {
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
      AIControls.Default = false;
      AIControls.Translations = true;
      Preferences = {
        "browser.tabs.insertAfterCurrent" = lock-false;
        "browser.tabs.insertAfterCurrentExceptPinned" = lock-true;
        "browser.tabs.insertRelatedAfterCurrent" = lock-true;
      };

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
        /* "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
        install_url = moz "vimium-ff";
        installation_mode = "force_installed";
        updates_disabled = true;
        }; */
        "linkhints@lydell.github.io" = {
          install_url = moz "linkhints";
          installation_mode = "force_installed";
          updates_disabled = true;
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
      input.touchpad.accel-speed = 0.3;
      input.keyboard.xkb.options = "caps:escape";
      layout.default-column-width.proportion = 0.5;
      binds = {
        "Mod+Shift+Slash".action.show-hotkey-overlay = {};
        "Mod+T".action.spawn-sh = "kitty -1";
        "Mod+Space".action.spawn-sh = "vicinae open";

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
        "Mod+Shift+F".action.fullscreen-window = {};
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

  programs.bluetuith = {
    enable = true;
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

  programs.git = {
    enable = true;
    settings = {
      user.name = "studentkrisk";
      user.email = "krishnaearth2@gmail.com";
      core.editor = "vim";
    };
  };
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings.editor = "vim";
  };

  programs.lutris.enable = true;

  programs.anki.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "obsidian"
  ];
  programs.obsidian.enable = true;

  programs.yazi.enable = true;

  programs.vicinae = {
    enable = true;
    systemd = {
      enable = true; # default: false
      autoStart = true; # default: true (if systemd.enable is true)
    };
    settings.launcher_window.layer_shell.enabled = false;
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [ vimtex ];
    # based on https://github.com/nvim-zh/minimal_vim/
    extraConfig = ''
      let g:tex_flavor='latex'
      let g:vimtex_view_method='zathura'
      let g:vimtex_quickfix_mode=0
      set conceallevel=2

      set encoding=utf-8
      scriptencoding utf-8
      language en_US.utf-8
      filetype plugin indent on
      set nocompatible

      syntax on

      set timeoutlen=500
      set splitbelow splitright
      set noswapfile

      set number relativenumber

      set fileencoding=utf-8
      set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

      set linebreak
      set showbreak=↪

      set wildmode=list:full

      set scrolloff=5

      if has('mouse')
        set mouse=nic  " Enable mouse in several mode
        set mousemodel=popup  " Set the behaviour of mouse
      endif

      set ruler

      set visualbell

      set confirm

      set title
      set titlestring=
      set titlestring+=%(%{hostname()}\ \ %)
      set titlestring+=%(%{expand('%:p')}\ \ %)
      set titlestring+=%{strftime('%Y-%m-%d\ %H:%M',getftime(expand('%')))}

      set completeopt+=menuone  " Show menu even if there is only one item
      set completeopt-=preview  " Disable the preview window

      set pumheight=15  " Maximum number of items to show in popup menu
      if exists('&pumblend')
      set pumblend=5  " Pesudo blend effect for popup menu
      endif

      set complete+=k,kspell complete-=w complete-=b complete-=u complete-=t

      set spelllang=en

      set shiftround

      set virtualedit=block

      set formatoptions+=mM

      set tildeop

      set nojoinspaces

      set wildmenu

      " Whitespace
      set wrap
      set textwidth=0
      set wrapmargin=0
      set foldlevel=0
      set formatoptions=tcqrn1
      set tabstop=4
      set shiftwidth=4
      set softtabstop=4
      set expandtab
      set noshiftround

      " Cursor motion
      set scrolloff=3
      set backspace=indent,eol,start
      set matchpairs+=<:> " use % to jump between pairs
      runtime! macros/matchit.vim

      set hidden

      " Rendering
      set ttyfast

      " Status bar
      set laststatus=2

      " Last line
      set showmode
      set showcmd

      " Searching
      nnoremap / /\v
      vnoremap / /\v
      set hlsearch
      set incsearch
      set ignorecase
      set smartcase
      set showmatch
      map <leader><space> :let @/=\'\'<cr> " clear search
      " Remap help key.
      inoremap <F1> <ESC>:set invfullscreen<CR>a
      nnoremap <F1> :set invfullscreen<CR>
      vnoremap <F1> :set invfullscreen<CR>
      " Textmate holdouts

      " Color scheme (terminal)
      set t_Co=256
      set background=dark
      let g:solarized_termcolors=256
      let g:solarized_termtrans=1
      " put https://raw.github.com/altercation/vim-colors-solarized/master/colors/solarized.vim
      " in ~/.vim/colors/ and uncomment:
      " colorscheme solarized
    '';
  };

  programs.ssh = {
    enable = true;
    settings = {
      "koi.ocf.io" = {
        User = "studentkrisk";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
      };
      "*.ocf.io !koi.ocf.io" = {
        User = "studentkrisk";
        ProxyJump = "koi.ocf.io";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
      };
    };
  };
}

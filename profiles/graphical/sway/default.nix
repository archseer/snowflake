{ lib, config, options, pkgs, ... }:
let
  inherit (builtins) readFile;

  left = "h";
  down = "j";
  up = "k";
  right = "l";

  font = "Inter:style=Regular 10";
  terminal = "${pkgs.alacritty}/bin/alacritty";
  browser = "${pkgs.firefox-wayland}/bin/firefox";

  menu = "${pkgs.rofi}/bin/rofi -terminal ${terminal} -show drun -theme sidestyle -show-icons -icon-theme Paper";

  # inherit (config.hardware) pulseaudio;
  in_touchpad = "1118:2479:Microsoft_Surface_045E:09AF_Touchpad";
  in_keyboard = "1118:2478:Microsoft_Surface_045E:09AE_Keyboard";
  out_laptop = "eDP-1";
  out_monitor = "DP-1";

  # Theme colors
  # bg = "#281733";
  # fg = "#eff1f5";
  # br = "#a4a0e8";
  # ia = "#232425";
in
{
  imports = [ ];

  programs.sway.enable = true; # needed for swaylock/pam stuff
  programs.sway.extraPackages = []; # block rxvt

  # xdg.portal stuff?
  
  environment.systemPackages = with pkgs; [
    capitaine-cursors
  ];

  # programs.mako.enable = true;
  home-manager.users.speed = { pkgs, ... }: {
    imports = [ ./waybar ];

    # rofi menu style
    xdg.configFile."rofi/sidestyle.rasi".source = ./sidestyle.rasi;

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_USE_XINPUT2 = "1";

      #WLR_DRM_NO_MODIFIERS = "1";
      SDL_VIDEODRIVER = "wayland";
      # needs qt5.qtwayland in systemPackages
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";

      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "sway";
    };

    home.packages = with pkgs;
      options.programs.sway.extraPackages.default ++ [
        rofi-wayland
        libinput-gestures
        qt5.qtwayland
        alacritty
        libnotify
        mako
        volnoti
        wl-clipboard
        waybar
        # (waybar.override { pulseSupport = pulseaudio.enable; })
        grim
        slurp
        # ydotool-git
        # xwayland
      ];

    wayland.windowManager.sway = {
      enable = true;
      systemdIntegration = true; # beta
      wrapperFeatures = {
        base = true; # this is the default, but be explicit for now
        gtk = true;
      };
      # extraSessionCommands = ''
      #   export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
      #   systemctl --user import-environment
      # '';
      xwayland = true;
      extraConfig = ''
          set $bg #281733
          set $fg #eff1f5
          set $br #a4a0e8
          set $ia #232425


          # class                 border  backgr. text    indicator child_border
          client.focused          $br     $br     $bg     $bg       $br
          client.focused_inactive $bg     $bg     $fg     $bg       $bg
          client.unfocused        $bg     $bg     $fg     $bg       $bg
          client.urgent           $br     $br     $fg     $bg       $br
          client.placeholder      $br     $br     $fg     $bg       $br
          client.background $bg

           seat seat0 xcursor_theme "capitaine-cursors"
      '';
      config = rec {
        modifier = "Mod4";
        inherit terminal;
        inherit left up right down;
        fonts = [ font ];

        focus.followMouse = "always";

        window = {
          titlebar = false; # pixel border
          border = 3;
          commands = [
            { criteria = { app_id = "mpv"; }; command = "sticky enable"; }
            { criteria = { app_id = "mpv"; }; command = "floating enable"; }

            # {
            #   criteria = { title = "^(.*) Indicator"; };
            #   command = "floating enable";
            # }

            # {
            #   criteria = { instance = "pinentry"; };
            #   command = "fullscreen on";
            # }
          ];
        };

        floating = {
          titlebar = false; # pixel border
          border = 0;
        };

        gaps = {
          outer = 5;
          inner = 10;
        };

        startup = [
        ];

        input = {
          "${in_touchpad}" = {
            # click_method = "clickfinger";
            # scroll_method = "two_finger";
            tap = "enabled";
            dwt = "enabled"; # disable while typing
            natural_scroll = "enabled";
            scroll_factor = "0.75";
            middle_emulation = "enabled";
            accel_profile = "adaptive";
            pointer_accel = "0.33";
          };
          "${in_keyboard}" = {
            xkb_layout = "us";
            xkb_variant = "norman";
            xkb_options = "ctrl:nocaps,compose:ralt";
          };
        };

        output = {
          "${out_laptop}" = {
            scale = "1.498";
          };
          "${out_monitor}" = {
            mode = "2560x1440@59.951Hz";
            # subpixel = "rgb";
            # scale = "1.0";
            # adaptive_sync = "on";
          };
          "*" = {
            background = "#185373 solid_color";
          };
        };

        bars = [];

        keycodebindings = {
          # rebind JP keys to planck equivalents
          # muhenkan
          "102" = "exec ydotool key tab";
          # henkan
          "100" = "exec ydotool key backspace";
          # katakana-hiragana
          "101" = "exec ydotool key enter";
        };

        keybindings = {
          # Start terminal
          "${modifier}+Return" = "exec ${terminal}";

          # Start browser
          "${modifier}+Shift+b" = "exec ${browser}";
          #"${modifier}+Shift+Backspace" = "exec ${editor}";

          # Kill focused window
          "${modifier}+Shift+q" = "kill";

          # Start your launcher
          "${modifier}+d" = "exec ${menu}";

          # Start password manager
          # "${modifier}+p" = "exec bwmenu";

          # Start network manager

          # Open a file manager
          # bindsym $mod+z exec alacritty -e nnn

          # "${modifier}+Shift+l" = "${swaylockcmd}"; # TODO:? loginctl log-session

          # "${modifier}+Escape" = "exec ${nwggrid}";
          # "${modifier}+F1" = "exec ${passShowCmd}";
          # "${modifier}+F2" = "exec ${passTotpCmd}";

          "Ctrl+q" = "exec echo"; # the most ridiculous firefox bug ever

          # Drag floating windows by holding down $mod and left mouse button.
          # Resize them with right mouse button + $mod.
          # Despite the name, also works for non-floating windows.
          # Change normal to inverse to use left mouse button for resizing and right
          # mouse button for dragging.
          # TODO: floating_modifier $mod normal

          # Reload the configuration file
          "${modifier}+Shift+c" = "reload";

          # Exit sway (logs you out of your Wayland session)
          "${modifier}+Shift+e" = "exec 'swaymsg exit'";
          # TODO: swaynag
          # bindsym $mod+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'

          # Moving around

          # Move your focus around
          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          # Move the focused window with the same, but add Shift
          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          # Workspaces

          # Switch to workspace
          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";
          "${modifier}+0" = "workspace number 10";

          # Move focused container to workspace
          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";
          "${modifier}+Shift+0" = "move container to workspace number 10";

          # Layout stuff

          # You can "split" the current object of your focus with
          # $mod+b or $mod+v, for horizontal and vertical splits
          # respectively.
          "${modifier}+b" = "splith";
          "${modifier}+v" = "splitv";

          # Switch the current container between different layout styles
          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          # "${modifier}+Prior" = "workspace prev";
          # "${modifier}+Next" = "workspace next";

          # Make the current focus fullscreen
          "${modifier}+f" = "fullscreen toggle";

          # Move focus to the parent container
          "${modifier}+a" = "focus parent";


          # Toggle the current focus between tiling and floating mode
          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+Shift+Alt+space" = "sticky toggle";
          # Swap focus between the tiling area and the floating area
          "${modifier}+space" = "focus mode_toggle";


          # Sway has a "scratchpad", which is a bag of holding for windows.
          # You can send windows there and get them back later.

          # Move the currently focused window to the scratchpad
          "${modifier}+Shift+minus" = "move scratchpad";

          # Show the next scratchpad window or hide the focused scratchpad window.
          # If there are multiple scratchpad windows, this command cycles through them.
          "${modifier}+minus"       = "scratchpad show";

          # ----

          # resize window to φ ratio of screen or ½
          # bindsym $mod+Shift+space exec swaymsg resize set width $φ
          # bindsym $mod+space exec swaymsg resize set width $Φ
          # bindsym $mod+Ctrl+space exec swaymsg resize set width 50

          #set $screenselect slurp
          #set $screenshot grim
          #set $screenshotout $HOME/Pictures/screenshots/$(date "+%Y-%m-%d-%H%M%S_shot.png")

          #bindsym Print exec $screenshot $screenshotout
          #bindsym $mod+Print exec $screenshot -g "$($screenselect)" $screenshotout

          ## Sleep key
          #bindsym XF86Sleep exec --no-startup-id systemctl suspend

          ## Screen brightness
          #bindsym XF86MonBrightnessUp exec light -T 1.3
          #bindsym XF86MonBrightnessDown exec light -T 0.72

          ## Toggle Redshift
          #bindsym $mod+Home exec --no-startup-id pkill -USR1 redshift

          ## Pulse Audio controls
          #bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5% #increase sound volume
          #bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5% #decrease sound volume
          #bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle # mute sound

          ## Media player controls
          #bindsym XF86AudioPlay exec playerctl play-pause
          #bindsym XF86AudioPause exec playerctl pause
          #bindsym XF86AudioNext exec playerctl next
          #bindsym XF86AudioPrev exec playerctl previous

          # "${modifier}+Ctrl+Alt+Home"  = "output * enable";
          # "${modifier}+Ctrl+Alt+End"   = "output -- disable";
          # "${modifier}+Ctrl+Alt+equal" = "exec ${outputScale} +.1";
          # "${modifier}+Ctrl+Alt+minus" = "exec ${outputScale} -.1";

          # "${modifier}+Print"       = ''exec ${pkgs.grim}/bin/grim \"''${HOME}/screenshot-$(date '+%s').png\"'';
          # "${modifier}+Shift+Print" = ''exec ${pkgs.grim}/bin/grim  -g \"$(slurp)\" \"''${HOME}/screenshot-$(date '+%s').png\"'';

          # "${modifier}+Ctrl+Alt+Up"    = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +10";
          # "${modifier}+Ctrl+Alt+Down"  = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 10-";
          # "${modifier}+Ctrl+Alt+Prior" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +100";
          # "${modifier}+Ctrl+Alt+Next"  = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 100-";
          # "${modifier}+Ctrl+Alt+Left"  = "exec ${pkgs.pulsemixer}/bin/pulsemixer --change-volume -2";
          # "${modifier}+Ctrl+Alt+Right" = "exec ${pkgs.pulsemixer}/bin/pulsemixer --change-volume +2";
        };

        modes = {
          resize = {
            "${left}" = "resize shrink width 10 px";
            "${down}" = "resize grow height 10 px";
            "${up}" = "resize shrink height 10 px";
            "${right}" = "resize grow width 10 px";
            "Left" = "resize shrink width 10 px";
            "Down" = "resize grow height 10 px";
            "Up" = "resize shrink height 10 px";
            "Right" = "resize grow width 10 px";
            "Escape" = "mode default";
            "Return" = "mode default";
          };
        };
      };
    };
  };

  environment.etc = {
    "sway/config".text =
      let volnoti = import ../misc/volnoti.nix { inherit pkgs; };
      in
      ''
        set $volume ${volnoti}
        set $mixer "${pkgs.alsaUtils}/bin/amixer -q set Master"

        # set background
        # output * bg tri-fadeno.jpg fill

        ${readFile ./config}
      '';

    "xdg/waybar".source = ./waybar;
  };

  programs.tmux.extraConfig = lib.mkBefore ''
    set -g @override_copy_command 'wl-copy'
  '';

  # services.gammastep = {
  #   enable = true;
  #   temperature.night = 3200;
  # };

  # location = {
  #   latitude = 38.833881;
  #   longitude = -104.821365;
  # };

  # systemd.user.services.volnoti = {
  #   enable = true;
  #   description = "volnoti volume notification";
  #   documentation = [ "volnoti --help" ];
  #   wantedBy = [ "sway-session.target" ];

  #   script = "${pkgs.volnoti}/bin/volnoti -n";

  #   serviceConfig = {
  #     Restart = "always";
  #     RestartSec = 3;
  #   };
  # };
}

{
  lib,
  pkgs,
  ...
}: let
  left = "h";
  down = "j";
  up = "k";
  right = "l";

  fonts = {
    names = ["Inter"];
    style = "Regular";
    size = 10.0;
  };
  # terminal = "${pkgs.alacritty}/bin/alacritty";
  terminal = "${pkgs.wezterm}/bin/wezterm";
  browser = "${pkgs.firefox-wayland}/bin/firefox";

  menu = "${pkgs.rofi-wayland}/bin/rofi -terminal ${terminal} -show drun -theme sidestyle -show-icons -icon-theme Paper";

    # inherit (config.hardware) pulseaudio;

  _touchpad = {
    left_handed = "enabled"; # This is a thing, thank you
    click_method = "clickfinger";
    # tap = "enabled";
    tap = "disabled";
    dwt = "enabled"; # disable while typing
    scroll_method = "two_finger";
    natural_scroll = "enabled";
    scroll_factor = "0.75";
    accel_profile = "adaptive";
    # pointer_accel = "0.3"; configured per touchpad
    # accel_profile = "flat";
    # pointer_accel = "1";
  };
  _keyboard = {
    xkb_layout = "us";
    xkb_variant = "norman";
    xkb_options = "compose:ralt";
  };

  in_touchpad = "1118:2479:Microsoft_Surface_045E:09AF_Touchpad";
  in_keyboard = "1118:2478:Microsoft_Surface_045E:09AE_Keyboard";
  in_ergodox = "12951:18804:ZSA_Technology_Labs_ErgoDox_EZ_Keyboard";
  in_mouse = "1133:16518:Logitech_G703_LS";
  out_laptop = "eDP-1";
  # out_monitor = "DP-1";
  # out_monitor = "Goldstar Company Ltd LG HDR 4K 0x0000EEB5";
  out_monitor = "Dell Inc. DELL P2721Q 2SLCVF3";
  # Theme colors
  # bg = "#281733";
  # fg = "#eff1f5";
  # br = "#a4a0e8";
  # ia = "#232425";
in {
  imports = [];

  environment.systemPackages = with pkgs; [
    capitaine-cursors
  ];

  # Apparently required for GTK3 settings on sway
  programs.dconf.enable = true;

  programs.tmux.extraConfig = lib.mkBefore ''
    set -g @override_copy_command 'wl-copy'
  '';

  home-manager.users.speed = {pkgs, ...}: {
    imports = [./waybar ./wlsunset];

    # rofi menu style
    xdg.configFile."rofi/sidestyle.rasi".source = ./sidestyle.rasi;

    # Starts automatically via dbus
    services.mako = {
      enable = true;
      font = "Inter UI, Font Awesome 10";
      padding = "15,20";
      # backgroundColor = "#3b224cF0";
      backgroundColor = "#281733F0";
      textColor = "#ebeafa";
      borderSize = 2;
      borderColor = "#a4a0e8";
      defaultTimeout = 5000;
      markup = true;
      format = "<b>%s</b>\\n\\n%b";

      # TODO:
      # [hidden]
      # format=(and %h more)
      # text-color=#999999

      # [urgency=high]
      # text-color=#F22C86
      # border-color=#F22C86
      # border-size=4
    };

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_USE_XINPUT2 = "1";

      SDL_VIDEODRIVER = "wayland";
      # needs qt5.qtwayland in systemPackages
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";

      # XDG_SESSION_TYPE = "wayland"; now set by wlroots https://github.com/nix-community/home-manager/commit/2464c21ab2b3607bed3c206a436855c487f35f55
      XDG_CURRENT_DESKTOP = "sway";
    };

    home.packages = with pkgs; [
      swaylock
      swayidle
      xwayland

      rofi-wayland
      #
      libinput-gestures
      qt5.qtwayland
      # alacritty
      libnotify
      mako
      # volnoti
      wl-clipboard
      waybar
      grim
      slurp
      # ydotool-git

      pulseaudio # just for pactl, wish there was pulseaudio-util
      playerctl
    ];

    wayland.windowManager.sway = {
      enable = true;
      systemd.enable = true;
      wrapperFeatures = {
        base = true; # this is the default, but be explicit for now
        gtk = true;
      };
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

        for_window [title="Firefox — Sharing Indicator"] floating enable
        for_window [title="Firefox — Sharing Indicator"] nofocus
      '';
      config = rec {
        modifier = "Mod4";
        inherit terminal menu;
        inherit left up right down fonts;

        focus.followMouse = "always";

        window = {
          titlebar = false; # pixel border
          border = 3;
          commands = [
            {
              criteria = {app_id = "mpv";};
              command = "sticky enable";
            }
            {
              criteria = {app_id = "mpv";};
              command = "floating enable";
            }

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
          smartGaps = true;
          smartBorders = "no_gaps";
        };

        startup = [
        ];

        input = {
          "type:touchpad" = _touchpad;
          "${in_touchpad}" = { pointer_accel = "0.3"; };
          "${in_keyboard}" = _keyboard;
          "1:1:AT_Translated_Set_2_keyboard" = _keyboard;
          "2362:628:PIXA3854:00_093A:0274_Touchpad" = { pointer_accel = "-0.2"; };
          "${in_mouse}" = {
            accel_profile = "adaptive";
            pointer_accel = "-0.2";
            # accel_profile = "flat";
            # pointer_accel = "0";
          };
          "${in_ergodox}" = {
            xkb_options = "compose:ralt";
          };
        };

        output = {
          "${out_laptop}" = {
            scale = "1.498";
          };
          "${out_monitor}" = {
            # mode = "3840x2160@60Hz";
            mode = "3840x2160@60.000Hz";
            # subpixel = "rgb";
            scale = "1.5";
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
          "${modifier}+${left}" = "focus left";
          "${modifier}+${down}" = "focus down";
          "${modifier}+${up}" = "focus up";
          "${modifier}+${right}" = "focus right";

          # Move the focused window with the same, but add Shift
          "${modifier}+Shift+${left}" = "move left";
          "${modifier}+Shift+${down}" = "move down";
          "${modifier}+Shift+${up}" = "move up";
          "${modifier}+Shift+${right}" = "move right";

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
          # "${modifier}+0" = "workspace number 10";

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
          # "${modifier}+Shift+0" = "move container to workspace number 10";

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
          "${modifier}+minus" = "scratchpad show";

          # ----
          #
          "${modifier}+r" = "mode resize";

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
          "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -T 1.3";
          "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -T 0.72";

          ## Toggle Redshift
          #bindsym $mod+Home exec --no-startup-id pkill -USR1 redshift

          ## Pulse Audio controls
          "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%"; #increase sound volume
          "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%"; #decrease sound volume
          "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle"; # mute sound

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
}

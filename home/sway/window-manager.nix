{
  config,
  lib,
  pkgs,
  ...
}:

let
  swayShared = import ./shared.nix {
    inherit
      config
      lib
      pkgs
      ;
  };

  inherit (swayShared)
    ghosttyCommand
    modifier
    pickColor
    screenshotFull
    screenshotRegion
    togglePowerProfile
    wallpaperScript
    ;
in
{
  wayland.windowManager.sway = {
    enable = true;
    package = null;
    systemd.variables = [ "--all" ];
    checkConfig = false;

    config = {
      inherit modifier;
      left = "h";
      down = "j";
      up = "k";
      right = "l";

      terminal = ghosttyCommand;
      menu = "${lib.getExe pkgs.walker}";

      focus.followMouse = "no";

      fonts = {
        names = [
          "CaskaydiaCove Nerd Font"
          "Noto Sans CJK SC"
        ];
        size = 10.0;
      };

      bars = [
        {
          command = "${lib.getExe pkgs.waybar}";
          statusCommand = null;
        }
      ];

      output = {
        "*" = {
          bg = "${../../assets/wallpapers/wallhaven-yq587d.png} fill";
        };

        "DP-2" = {
          resolution = "2560x1440@180.001Hz";
          position = "0 0";
          scale = "1.0";
        };

        "eDP-1" = {
          resolution = "2560x1600@60.002Hz";
          position = "2560 0";
          scale = "1.6";
          transform = "270";
        };
      };

      workspaceOutputAssign =
        (map (workspace: {
          workspace = toString workspace;
          output = "DP-2";
        }) (lib.range 1 9))
        ++ [
          {
            workspace = "10";
            output = "eDP-1";
          }
        ];

      input = {
        "type:touchpad".events = "disabled_on_external_mouse";
        "type:pointer".accel_profile = "flat";
      };

      floating.criteria = [
        { app_id = "org.gnome.Nautilus"; }
      ];

      gaps = {
        inner = 5;
        outer = 4;
      };

      window.border = 2;
      floating.border = 2;
      floating.modifier = "${modifier} normal";

      colors = {
        focused = {
          border = "#cba6f7";
          background = "#1e1e2e";
          text = "#cdd6f4";
          indicator = "#fab387";
          childBorder = "#cba6f7";
        };
        focusedInactive = {
          border = "#646789";
          background = "#1e1e2e";
          text = "#a3b4eb";
          indicator = "#646789";
          childBorder = "#646789";
        };
        unfocused = {
          border = "#646789";
          background = "#1e1e2e";
          text = "#a3b4eb";
          indicator = "#646789";
          childBorder = "#646789";
        };
        urgent = {
          border = "#f38ba8";
          background = "#1e1e2e";
          text = "#cdd6f4";
          indicator = "#f38ba8";
          childBorder = "#f38ba8";
        };
        placeholder = {
          border = "#1e1e2e";
          background = "#1e1e2e";
          text = "#a3b4eb";
          indicator = "#1e1e2e";
          childBorder = "#1e1e2e";
        };
        background = "#1e1e2e";
      };

      startup = [
        {
          command = "${wallpaperScript} random";
          always = true;
        }
        { command = "fcitx5 -d -r"; }
        { command = "${lib.getExe pkgs.walker} --gapplication-service"; }
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
      ];

      keybindings = lib.mkOptionDefault {
        "${modifier}+t" = "exec ${ghosttyCommand}";
        "${modifier}+d" = "exec ${lib.getExe pkgs.walker}";
        "${modifier}+Tab" = "workspace next";
        "${modifier}+Shift+Tab" = "workspace prev";
        "${modifier}+m" = "splith";
        "${modifier}+n" = "splitv";
        "${modifier}+Shift+v" = "floating toggle";
        "${modifier}+v" = "focus mode_toggle";

        "--locked XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "--locked XF86AudioLowerVolume" =
          "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "--locked XF86AudioRaiseVolume" =
          "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "--locked XF86AudioMicMute" =
          "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        "--locked XF86MonBrightnessDown" = "exec ${lib.getExe pkgs.brightnessctl} set 5%-";
        "--locked XF86MonBrightnessUp" = "exec ${lib.getExe pkgs.brightnessctl} set 5%+";

        "${modifier}+Home" = "exec ${screenshotFull}";
        "Home" = "exec ${screenshotRegion}";

        "${modifier}+p" = "exec ${lib.getExe pkgs.nautilus}";
        "${modifier}+b" = "exec ${lib.getExe pkgs.google-chrome}";
        "${modifier}+Mod1+space" =
          "exec sh -lc 'pkill -x fcitx5 && ${pkgs.libnotify}/bin/notify-send \"Fcitx5\" \"已关闭输入法\" || (fcitx5 -d -r && ${pkgs.libnotify}/bin/notify-send \"Fcitx5\" \"已启动输入法\")'";
        "${modifier}+o" = "exec ${togglePowerProfile}";
        "${modifier}+c" = "exec ${pickColor}";
      };
    };

    extraConfig = ''
      exec_always dbus-update-activation-environment --systemd QT_FONT_DPI WAYLAND_DISPLAY DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP=sway XDG_SESSION_DESKTOP=sway
      workspace 1

      for_window [app_id="^.*"] inhibit_idle fullscreen
      seat seat0 xcursor_theme Bibata-Modern-Classic 20
      include /etc/sway/config.d/*
    '';
  };
}

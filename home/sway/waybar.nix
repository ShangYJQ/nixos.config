{
  config,
  lib,
  pkgs,
  unstable,
  ...
}:

let
  swayShared = import ./shared.nix {
    inherit
      config
      lib
      pkgs
      unstable
      ;
  };

  inherit (swayShared) cavaScript wallpaperScript;

  nightlightService = "gammastep.service";
  nightlightStatus = pkgs.writeShellScript "waybar-nightlight-status" ''
    set -eu

    systemctl="${lib.getExe' pkgs.systemd "systemctl"}"

    if "$systemctl" --user is-active --quiet ${nightlightService}; then
      printf '%s\n' '{"class":"on","alt":"on","tooltip":"护眼模式：已开启"}'
    elif "$systemctl" --user is-failed --quiet ${nightlightService}; then
      printf '%s\n' '{"class":"failed","alt":"failed","tooltip":"护眼模式：启动失败，查看 journalctl --user -u gammastep.service"}'
    else
      printf '%s\n' '{"class":"off","alt":"off","tooltip":"护眼模式：已关闭"}'
    fi
  '';
  nightlightToggle = pkgs.writeShellScript "waybar-nightlight-toggle" ''
    set -eu

    systemctl="${lib.getExe' pkgs.systemd "systemctl"}"

    if "$systemctl" --user is-active --quiet ${nightlightService}; then
      exec "$systemctl" --user stop ${nightlightService}
    fi

    "$systemctl" --user reset-failed ${nightlightService} >/dev/null 2>&1 || true
    exec "$systemctl" --user start ${nightlightService}
  '';
in
{
  services.gammastep = {
    enable = true;
    dawnTime = "6:00-7:45";
    duskTime = "18:35-20:15";
    temperature = {
      day = 5500;
      night = 3700;
    };
    tray = false;
    enableVerboseLogging = true;
    settings = {
      general = {
        adjustment-method = "wayland";
      };
    };
  };

  programs.waybar = {
    enable = true;
    package = unstable.waybar;
    systemd = {
      enable = true;
      target = "sway-session.target";
    };
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      spacing = 1;
      margin = "0";
      modules-left = [
        "custom/arch"
        "clock"
        "cpu"
        "memory"
        "disk"
        "temperature"
        "battery"
        "custom/cava"
      ];
      modules-center = [
        "sway/workspaces"
        "sway/mode"
      ];
      modules-right = [
        "tray"
        "pulseaudio"
        "backlight"
        "network"
        "bluetooth"
        "custom/uptime"
        "custom/nightlight"
        "idle_inhibitor"
      ];

      "sway/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        format = "{name}";
        format-icons = {
          "1" = "󰖟";
          "2" = "";
          "3" = "";
          "4" = "󰭹";
          "5" = "󰕧";
          "6" = "";
          "7" = "";
          "8" = "󰣇";
          "9" = "";
          "10" = "";
        };
        persistent_workspaces = {
          "1" = [ ];
          "2" = [ ];
          "3" = [ ];
          "4" = [ ];
          "5" = [ ];
        };
      };

      "sway/mode".format = "<span style=\"italic\">{}</span>";

      "custom/cava" = {
        exec = "${cavaScript}";
        format = "{}";
        on-click-middle = "${lib.getExe pkgs.playerctl} play-pause";
        on-click-right = "${lib.getExe pkgs.playerctl} next";
        on-click-left = "${lib.getExe pkgs.playerctl} previous";
        tooltip = false;
      };

      "custom/arch" = {
        format = "";
        on-click = "${wallpaperScript} next";
        on-click-right = "${wallpaperScript} prev";
        on-click-middle = "${wallpaperScript} random";
        tooltip = false;
      };

      "custom/uptime" = {
        format = "󰔟 {}";
        exec = "${lib.getExe' pkgs.procps "uptime"} -p | ${lib.getExe pkgs.gnused} 's/up //; s/ days/d/; s/ hours/h/; s/ minutes/m/'";
        interval = 60;
      };

      "custom/nightlight" = {
        format = "{icon}";
        return-type = "json";
        interval = 1;
        exec = "${nightlightStatus}";
        format-icons = {
          on = "";
          off = "";
          failed = "";
        };
        on-click = "${nightlightToggle}";
      };

      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "󰈈";
          deactivated = "󰈉";
        };
        tooltip = true;
      };

      clock = {
        format = "󰥔 {:%H:%M}";
        format-alt = "󰃮 {:%Y-%m-%d}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        calendar = {
          mode = "month";
          mode-mon-col = 3;
          weeks-pos = "right";
          on-scroll = 1;
          on-click-right = "mode";
          format = {
            months = "<span color='#d3c6aa'><b>{}</b></span>";
            days = "<span color='#e67e80'>{}</span>";
            weeks = "<span color='#a7c080'><b>W{}</b></span>";
            weekdays = "<span color='#7fbbb3'><b>{}</b></span>";
            today = "<span color='#dbbc7f'><b><u>{}</u></b></span>";
          };
        };
      };

      cpu = {
        format = "󰘚 {usage}%";
        tooltip = true;
        interval = 1;
        on-click = "${lib.getExe pkgs.ghostty} -e btop";
      };

      memory = {
        format = "󰍛 {}%";
        interval = 1;
        tooltip-format = "Memory: {used} / {total} ({percentage}%)";
        on-click = "${lib.getExe pkgs.ghostty} -e htop";
      };

      temperature = {
        critical-threshold = 80;
        format = "{icon} {temperatureC}°C";
        format-icons = [
          "󱃃"
          "󰔏"
          "󱃂"
        ];
        on-click = "${lib.getExe pkgs.ghostty} -e s-tui";
      };

      battery = {
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-plugged = "󰚥 {capacity}%";
        format-alt = "{icon} {time}";
        format-icons = [
          "󰂎"
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰁿"
          "󰂀"
          "󰂁"
          "󰂂"
          "󰁹"
        ];
      };

      network = {
        format-wifi = "󰖩 {essid} ({signalStrength}%)";
        format-ethernet = "󰈀 {ifname}";
        format-linked = "󰈀 {ifname} (No IP)";
        format-disconnected = "󰖪 Disconnected";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
        tooltip-format = "{ifname}: {ipaddr}";
        max-length = 16;
      };

      bluetooth = {
        format = " {status}";
        format-connected = " {device_alias}";
        format-connected-battery = " {device_alias} ({device_battery_percentage}%)";
        tooltip-format = "{controller_alias}\n{num_connections} connected";
        on-click = "${lib.getExe pkgs.ghostty} -e ${lib.getExe unstable.bluetui}";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-bluetooth = "󰂰 {volume}%";
        format-bluetooth-muted = "󰂲 {icon}";
        format-muted = "󰝟";
        format-icons = {
          headphone = "󰋋";
          hands-free = "󰥰";
          headset = "󰋎";
          phone = "󰏲";
          portable = "󰄝";
          car = "󰄋";
          default = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
        };
        on-click = "${lib.getExe unstable.pavucontrol}";
        on-click-right = "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
        on-scroll-up = "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +2%";
        on-scroll-down = "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -2%";
      };

      backlight = {
        format = "{icon} {percent}%";
        format-icons = [
          "󰃞"
          "󰃟"
          "󰃠"
        ];
        on-scroll-up = "${lib.getExe pkgs.brightnessctl} set +5%";
        on-scroll-down = "${lib.getExe pkgs.brightnessctl} set 5%-";
      };

      disk = {
        interval = 30;
        format = "󰋊 {percentage_used}%";
        path = "/";
        on-click = "${lib.getExe pkgs.ghostty} -e ${lib.getExe unstable.gdu} /";
      };

      tray = {
        icon-size = 18;
        spacing = 5;
      };
    };

    style = ''
      @define-color background        #1e1e2e;
      @define-color background-light  #313244;
      @define-color foreground        #cdd6f4;
      @define-color black             #11111b;
      @define-color red               #f38ba8;
      @define-color green             #a6e3a1;
      @define-color yellow            #f9e2af;
      @define-color blue              #89b4fa;
      @define-color magenta           #cba6f7;
      @define-color cyan              #89dceb;
      @define-color white             #bac2de;
      @define-color orange            #fab387;
      @define-color outline           #646789;
      @define-color archblue          #1793D1;

      * {
        border: none;
        border-radius: 0;
        font-family: "CaskaydiaCove Nerd Font Propo", "CaskaydiaCove NFP", monospace;
        font-size: 14px;
        min-height: 0;
      }

      tooltip {
        background: @background-light;
        color: @foreground;
        border: 1px solid @background;
        border-radius: 3px;
        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.35);
        padding: 8px 10px;
      }

      tooltip label {
        padding: 0;
        margin: 0;
        color: @foreground;
        font-size: 13px;
      }

      window#waybar {
        background-color: @background;
        color: @foreground;
      }

      #custom-arch,
      #custom-nightlight,
      #custom-cava,
      #mode,
      #clock,
      #cpu,
      #memory,
      #temperature,
      #battery,
      #network,
      #bluetooth,
      #pulseaudio,
      #backlight,
      #disk,
      #custom-uptime,
      #idle_inhibitor,
      #tray {
        padding: 0 10px;
        margin: 0 2px;
        border-bottom: 2px solid transparent;
        background-color: transparent;
      }

      #workspaces button {
        padding: 0 10px;
        background-color: transparent;
        color: @foreground;
        margin: 0;
      }

      #workspaces button:hover {
        background: @background-light;
        box-shadow: inherit;
      }

      #workspaces button.focused {
        box-shadow: inset 0 -2px @cyan;
        color: @cyan;
        font-weight: 900;
      }

      #workspaces button.urgent {
        background-color: @red;
        color: @black;
      }

      #custom-arch { color: @archblue; }
      #custom-cava { color: @white; border-bottom-color: @white; }
      #mode { color: @orange; border-bottom-color: @orange; }
      #clock { color: @blue; border-bottom-color: @blue; }
      #cpu { color: @green; border-bottom-color: @green; }
      #memory { color: @magenta; border-bottom-color: @magenta; }
      #temperature { color: @yellow; border-bottom-color: @yellow; }
      #temperature.critical { color: @red; border-bottom-color: @red; }
      #battery { color: @cyan; border-bottom-color: @cyan; }
      #battery.charging, #battery.plugged { color: @green; border-bottom-color: @green; }
      #battery.warning:not(.charging) { color: @yellow; border-bottom-color: @yellow; }
      #battery.critical:not(.charging) { color: @red; border-bottom-color: @red; }
      #network { color: @blue; border-bottom-color: @blue; }
      #network.disconnected { color: @red; border-bottom-color: @red; }
      #bluetooth { color: @blue; border-bottom-color: @blue; }
      #pulseaudio { color: @orange; border-bottom-color: @orange; }
      #pulseaudio.muted { color: @red; border-bottom-color: @red; }
      #backlight { color: @yellow; border-bottom-color: @yellow; }
      #disk { color: @cyan; border-bottom-color: @cyan; }
      #custom-uptime { color: @green; border-bottom-color: @green; }
      #custom-nightlight { color: @white; border-bottom-color: @white; }
      #custom-nightlight.on { color: @yellow; border-bottom-color: @yellow; }
      #custom-nightlight.failed { color: @red; border-bottom-color: @red; }
      #idle_inhibitor { color: @foreground; border-bottom-color: transparent; }
      #idle_inhibitor.activated { color: @red; border-bottom-color: @red; }

      #tray {
        background-color: transparent;
        padding: 0 10px;
        margin: 0 2px;
      }

      #tray > .passive { -gtk-icon-effect: dim; }
      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        color: @red;
        border-bottom-color: @red;
      }
    '';
  };
}

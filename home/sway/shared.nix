{
  awwwPackage,
  config,
  lib,
  pkgs,
}:

let
  cfgHome = config.home.homeDirectory;
in
rec {
  inherit cfgHome;

  modifier = "Mod4";
  screenshots = "${cfgHome}/Pictures/Screenshots";

  ghosttyCommand = lib.getExe pkgs.ghostty;

  wallpaperScript = pkgs.writeShellScript "awww-wallpaper" ''
    set -eu

    dir="''${AWWW_WALLPAPER_DIR:-${cfgHome}/Pictures/Wallpapers}"
    state_dir="''${XDG_CACHE_HOME:-${cfgHome}/.cache}/awww"
    index_file="$state_dir/index"
    order_file="$state_dir/order"
    resize_type="''${AWWW_RESIZE_TYPE:-crop}"

    export AWWW_TRANSITION="''${AWWW_TRANSITION:-random}"
    export AWWW_TRANSITION_DURATION="''${AWWW_TRANSITION_DURATION:-3}"
    export AWWW_TRANSITION_FPS="''${AWWW_TRANSITION_FPS:-60}"

    mkdir -p "$state_dir"

    if [ ! -d "$dir" ]; then
      echo "Wallpaper dir not found: $dir" >&2
      exit 1
    fi

    build_order() {
      find "$dir" -type f | while read -r img; do
        echo "$(${pkgs.coreutils}/bin/head -c 32 /dev/urandom | ${pkgs.coreutils}/bin/base64 | ${pkgs.coreutils}/bin/head -c 8):$img"
      done | sort | cut -d':' -f2- > "$order_file"
    }

    [ -s "$order_file" ] || build_order

    index=0
    [ -f "$index_file" ] && index="$(cat "$index_file" 2>/dev/null || echo 0)"
    case "$index" in
      "" | *[!0-9]*) index=0 ;;
    esac

    count="$(wc -l < "$order_file" | tr -d ' ')"
    if [ "$count" -eq 0 ]; then
      build_order
      count="$(wc -l < "$order_file" | tr -d ' ')"
    fi

    action="''${1:-next}"
    case "$action" in
      next) index=$(((index + 1) % count)) ;;
      prev) index=$(((index - 1 + count) % count)) ;;
      random)
        random="$(${pkgs.coreutils}/bin/od -An -N2 -tu2 /dev/urandom 2>/dev/null | tr -d ' ')"
        index=$((random % count))
        ;;
      reshuffle)
        build_order
        index=0
        ;;
      *)
        echo "Usage: $0 {next|prev|random|reshuffle}" >&2
        exit 2
        ;;
    esac

    echo "$index" > "$index_file"
    target_line=$((index + 1))
    img="$(sed -n "''${target_line}p" "$order_file")"

    if [ -z "$img" ]; then
      build_order
      img="$(sed -n "1p" "$order_file")"
      echo 0 > "$index_file"
    fi

    ${lib.getExe awwwPackage} query | awk '{print $2}' | sed 's/://g' | while read -r output; do
      [ -n "$output" ] || continue
      ${lib.getExe awwwPackage} img --resize "$resize_type" --outputs "$output" \
        --transition-type "$AWWW_TRANSITION" \
        --transition-fps "$AWWW_TRANSITION_FPS" \
        --transition-duration "$AWWW_TRANSITION_DURATION" \
        "$img"
    done
  '';

  cavaScript = pkgs.writeShellScript "waybar-cava" ''
    bar="▁▂▃▄▅▆▇█"
    dict="s/;//g"
    bar_length=''${#bar}

    for ((i = 0; i < bar_length; i++)); do
      dict+=";s/$i/''${bar:$i:1}/g"
    done

    config_file="/tmp/bar_cava_config"
    cat > "$config_file" <<EOF
    [general]
    framerate = 30
    bars = 14

    [input]
    method = pulse
    source = auto

    [output]
    method = raw
    raw_target = /dev/stdout
    data_format = ascii
    ascii_max_range = 7
    EOF

    pkill -f "cava -p $config_file" || true
    ${lib.getExe pkgs.cava} -p "$config_file" | sed -u "$dict"
  '';

  togglePowerProfile = pkgs.writeShellScript "toggle-power-profile" ''
    set -eu

    order="performance balanced power-saver"
    current="$(${pkgs.power-profiles-daemon}/bin/powerprofilesctl get 2>/dev/null || true)"

    if [ -z "$current" ]; then
      ${pkgs.libnotify}/bin/notify-send -u critical "Power Profile" "powerprofilesctl get failed: check power-profiles-daemon"
      exit 1
    fi

    next=""
    found=0
    for profile in $order; do
      if [ "$profile" = "$current" ]; then
        found=1
        continue
      fi
      if [ "$found" = "1" ]; then
        next="$profile"
        break
      fi
    done
    [ -n "$next" ] || next="$(printf "%s" "$order" | awk '{print $1}')"

    if ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set "$next" 2>/dev/null; then
      case "$next" in
        performance) icon="performance" ;;
        balanced) icon="balanced" ;;
        power-saver) icon="power saver" ;;
        *) icon="$next" ;;
      esac
      ${pkgs.libnotify}/bin/notify-send -u normal "Power Profile" "Switched to: $icon"
    else
      ${pkgs.libnotify}/bin/notify-send -u critical "Power Profile" "Switch failed: $current -> $next"
      exit 1
    fi
  '';

  makoNotifySound = pkgs.writeShellScript "mako-notify-sound" ''
    case "''${1:-normal}" in
      low | normal) sound="${../../assets/mako/message.oga}" ;;
      critical) sound="${../../assets/mako/dialog-warn.oga}" ;;
      *) sound="${../../assets/mako/message.oga}" ;;
    esac

    ${pkgs.pipewire}/bin/pw-play "$sound"
  '';
}

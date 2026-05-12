{ pkgs, unstable, ... }:

let
  zjstatusWasm = pkgs.fetchurl {
    url = "https://github.com/dj95/zjstatus/releases/download/v0.23.0/zjstatus.wasm";
    hash = "sha256-4AaQEiNSQjnbYYAh5MxdF/gtxL+uVDKJW6QfA/E4Yf8=";
  };

  zellijGitStatus = pkgs.writeShellScript "zellij-git-status" ''
    set -eu

    git="${pkgs.git}/bin/git"
    awk="${pkgs.gawk}/bin/awk"
    basename="${pkgs.coreutils}/bin/basename"
    sed="${pkgs.gnused}/bin/sed"
    tr="${pkgs.coreutils}/bin/tr"
    wc="${pkgs.coreutils}/bin/wc"

    if ! "$git" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      exit 0
    fi

    diff_shortstat() {
      "$git" diff --shortstat HEAD 2>/dev/null || true
    }

    print_stat_number() {
      field="$1"
      diff_shortstat | "$awk" -F',' -v field="$field" '
        $0 == "" { exit }
        {
          for (i = 1; i <= NF; i++) {
            if ($i ~ field) {
              gsub(/[^0-9]/, "", $i)
              if ($i != "0") print $i
              exit
            }
          }
        }
      '
    }

    case "''${1:-}" in
      --name)
        remote_url=$("$git" remote get-url origin 2>/dev/null || true)
        if [ -n "$remote_url" ]; then
          "$basename" "$remote_url" | "$sed" 's/\.git$//'
        fi
        ;;
      --branch)
        "$git" symbolic-ref --short HEAD 2>/dev/null || "$git" rev-parse --short HEAD 2>/dev/null || true
        ;;
      --files)
        count=$("$git" status --porcelain 2>/dev/null | "$wc" -l | "$tr" -d ' ')
        [ "$count" = "0" ] || printf '%s\n' "$count"
        ;;
      --add)
        print_stat_number "insertion"
        ;;
      --sub)
        print_stat_number "deletion"
        ;;
      *)
        exit 1
        ;;
    esac
  '';
in
{
  programs.zellij = {
    enable = true;
    package = unstable.zellij;
    # enableFishIntegration = true;
    # exitShellOnExit = true;

    extraConfig = ''
      keybinds {
          normal {
              bind "Ctrl Shift Left"  { GoToPreviousTab; }
              bind "Ctrl Shift Right" { GoToNextTab; }
          }

          locked {
              bind "Ctrl Shift Left"  { GoToPreviousTab; }
              bind "Ctrl Shift Right" { GoToNextTab; }
          }
      }
    '';

    settings = {
      default_shell = "fish";
      pane_frames = false;
      show_startup_tips = false;

      session_serialization = false;

      default_layout = "default";
      theme = "catppuccin-macchiato";
    };

    layouts.default = ''
      layout {
          default_tab_template {
              pane size=1 borderless=true {
                  plugin location="file:${zjstatusWasm}" {
                      format_left   "{mode} #[fg=#89B4FA,bold]{session}"
                      format_center "{tabs}"
                      format_right  "{command_git_name}{command_git_branch}{command_git_files}{command_git_add}{command_git_sub}{datetime}"
                      format_space  ""

                      border_enabled  "false"
                      border_char     "─"
                      border_format   "#[fg=#6C7086]{char}"
                      border_position "top"

                      hide_frame_for_single_pane "false"

                      mode_normal  "#[bg=#cba6f7,fg=black,bold]Session:"
                      mode_locked  "#[bg=#cba6f7,fg=black,bold]Session Locked:"
                      mode_tmux    "#[bg=#ffc387,fg=black,bold]Session:"

                      tab_normal   "#[fg=#D2F7A6] {name} "
                      tab_active   "#[fg=#cba6f7,bold,italic] {name} "

                      command_git_name_command            "${zellijGitStatus} --name"
                      command_git_name_format             "#[fg=#cba6f7] {stdout} "
                      command_git_name_interval           "10"
                      command_git_name_rendermode         "static"
                      command_git_name_hideonemptystdout  "true"

                      command_git_branch_command            "${zellijGitStatus} --branch"
                      command_git_branch_format             "#[fg=#cba6f7] {stdout} "
                      command_git_branch_interval           "10"
                      command_git_branch_rendermode         "static"
                      command_git_branch_hideonemptystdout  "true"

                      command_git_files_command            "${zellijGitStatus} --files"
                      command_git_files_format             "#[fg=#ffc387] {stdout} "
                      command_git_files_interval           "10"
                      command_git_files_rendermode         "static"
                      command_git_files_hideonemptystdout  "true"

                      command_git_add_command            "${zellijGitStatus} --add"
                      command_git_add_format             "#[fg=green] {stdout} "
                      command_git_add_interval           "10"
                      command_git_add_rendermode         "static"
                      command_git_add_hideonemptystdout  "true"

                      command_git_sub_command            "${zellijGitStatus} --sub"
                      command_git_sub_format             "#[fg=red] {stdout} "
                      command_git_sub_interval           "10"
                      command_git_sub_rendermode         "static"
                      command_git_sub_hideonemptystdout  "true"

                      datetime        "#[fg=#df5b61,bold] {format} "
                      datetime_format "%A, %d %b %Y %H:%M"
                  }
              }
              children
          }
      }
    '';
  };
}

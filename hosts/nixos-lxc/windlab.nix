{ pkgs, ... }:

let
  repoDir = "/home/yjq/code/windlab";
  frontendDir = "${repoDir}/frontend";
  frontendFlake = "git+file://${repoDir}?dir=frontend";
in
{
  systemd.services.windlab-android-oss-push = {
    description = "Build WindLab Android APK and upload to OSS";

    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    path = [
      pkgs.bash
      pkgs.bun
      pkgs.git
      pkgs.nix
      pkgs.openssh
    ];

    serviceConfig = {
      Type = "oneshot";
      User = "yjq";
      WorkingDirectory = frontendDir;
      EnvironmentFile = "${frontendDir}/.env";
      TimeoutStartSec = "2h";
    };

    script = ''
      set -euo pipefail

      if ! git diff --quiet || ! git diff --cached --quiet; then
        echo "Working tree is dirty, abort."
        git status --short
        exit 1
      fi

      before="$(git rev-parse HEAD)"

      git pull --ff-only

      after="$(git rev-parse HEAD)"

      if [ "$before" = "$after" ]; then
        echo "No new commits, skip."
        exit 0
      fi

      echo "New commits detected: $before -> $after"

      nix develop "${frontendFlake}" -c bash -c '
        set -euo pipefail

        bun install --frozen-lockfile
        bun run sync
        bun run codegen
        bun run build:android-oss-push
      '
    '';

  };

  systemd.timers.windlab-android-oss-push = {
    wantedBy = [ "timers.target" ];

    timerConfig = {
      Unit = "windlab-android-oss-push.service";

      # 每天 10:00 到 22:00，每 2h 运行一次。
      OnCalendar = "*-*-* 10..22/2:00:00";

      # 机器关机错过任务后，不在开机时补跑。
      Persistent = false;
    };
  };
}

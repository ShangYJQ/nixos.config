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

      git pull

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

      # 每天 12:00 到 23:00，每小时运行一次。
      OnCalendar = "*-*-* 12..23:00:00 Asia/Shanghai";

      # 机器关机错过任务后，不在开机时补跑。
      Persistent = false;
    };
  };
}

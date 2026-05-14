{
  lib,
  pkgs,
  ...
}: let
  ghosttyNvidiaEgl = pkgs.runCommand "ghostty-nvidia-egl" {
    nativeBuildInputs = [pkgs.makeWrapper];
    meta.mainProgram = "ghostty";
  } ''
    mkdir -p "$out/bin"
    makeWrapper ${lib.getExe pkgs.ghostty} "$out/bin/ghostty" \
      --run ${lib.escapeShellArg ''
        if [ -r /run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json ] \
          && [ -r /run/opengl-driver/share/egl/egl_external_platform.d/10_nvidia_wayland.json ] \
          && [ -e /run/opengl-driver/lib/libnvidia-egl-wayland.so.1 ]; then
          export LD_LIBRARY_PATH="/run/opengl-driver/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
          export __EGL_VENDOR_LIBRARY_FILENAMES="/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json"
          export __EGL_EXTERNAL_PLATFORM_CONFIG_DIRS="/run/opengl-driver/share/egl/egl_external_platform.d"
        fi
      ''}

    ln -s ${pkgs.ghostty}/share "$out/share"
  '';
in {
  xdg.configFile."ghostty/shaders/cursor_sweep.glsl".source =
    ../../../assets/ghostty/cursor_sweep.glsl;

  programs.ghostty = {
    enable = true;
    package = ghosttyNvidiaEgl;
    settings = {
      font-family = "CaskaydiaCove Nerd Font";
      font-size = 14;
      theme = "Catppuccin Macchiato";
      custom-shader = "shaders/cursor_sweep.glsl";
      background-opacity = 0.98;
    };
  };
}

{ ... }:

{
  xdg.configFile = {
    "walker/config.toml".text = ''
      force_keyboard_focus = true
      theme = "omarchy"
    '';

    "walker/themes/omarchy/style.css".text = ''
      @define-color surface #1e1e2e;
      @define-color surfaceVariant #313244;
      @define-color onSurface #cdd6f4;
      @define-color onSurfaceVariant #a3b4eb;
      @define-color primary #cba6f7;
      @define-color secondary #fab387;
      @define-color error #f38ba8;
      @define-color outline #646789;

      * {
        all: unset;
        font-family: monospace;
        font-size: 18px;
        color: @onSurface;
      }

      scrollbar { opacity: 0; }
      .normal-icons { -gtk-icon-size: 16px; }
      .large-icons { -gtk-icon-size: 32px; }

      .box-wrapper {
        background: alpha(@surface, 0.95);
        padding: 20px;
        border: 2px solid @outline;
      }

      .search-container {
        background: @surface;
        padding: 10px;
      }

      .input {
        background: @surface;
        color: @onSurface;
        caret-color: @onSurface;
      }

      .input placeholder { opacity: 0.5; }
      .input:focus, .input:active {
        box-shadow: none;
        outline: none;
      }

      child:selected .item-box {
        background: alpha(@primary, 0.35);
      }

      child:selected .item-box * {
        color: @onSurface;
      }

      .item-box {
        padding-left: 14px;
        border-radius: 10px;
      }

      child:hover .item-box {
        background: alpha(@primary, 0.2);
      }

      .item-text-box {
        all: unset;
        padding: 14px 0;
      }

      .item-subtext {
        font-size: 0px;
        min-height: 0px;
        margin: 0px;
        padding: 0px;
        opacity: 0;
      }

      .item-image {
        margin-right: 14px;
        -gtk-icon-transform: scale(0.9);
      }

      .current {
        font-style: italic;
        color: @onSurfaceVariant;
      }

      .keybind-hints {
        background: @surfaceVariant;
        padding: 10px;
        margin-top: 10px;
        color: @primary;
      }

      .preview {
        border-top: 1px solid @primary;
        padding-top: 10px;
      }
    '';
  };
}

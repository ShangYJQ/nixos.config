{ lib, pkgs, ... }:

let
  omarchyStyle = ''
    @define-color surface #1e1e2e;
    @define-color surfaceVariant #313244;
    @define-color onSurface #cdd6f4;
    @define-color onSurfaceVariant #a3b4eb;
    @define-color primary #cba6f7;
    @define-color secondary #fab387;
    @define-color error #f38ba8;
    @define-color outline #646789;

    #window,
    #box,
    #aiScroll,
    #aiList,
    #search,
    #password,
    #input,
    #prompt,
    #clear,
    #typeahead,
    #list,
    child,
    scrollbar,
    slider,
    #item,
    #text,
    #label,
    #bar,
    #sub,
    #activationlabel,
    .box-wrapper,
    .box,
    .search-container,
    .input,
    .content-container,
    .list,
    .item-box,
    .item-text-box,
    .item-text,
    .item-subtext,
    .item-image,
    .keybinds,
    .keybinds-wrapper,
    .preview {
      all: unset;
      font-family: monospace;
      font-size: 18px;
      color: @onSurface;
    }

    scrollbar { opacity: 0; }
    .normal-icons { -gtk-icon-size: 16px; }
    .large-icons { -gtk-icon-size: 32px; }

    #window {
      background: transparent;
    }

    #box,
    .box-wrapper {
      background: @surface;
      padding: 20px;
      border: 2px solid @outline;
    }

    #search,
    .search-container {
      background: @surface;
      padding: 10px;
    }

    #input,
    .input {
      background: @surface;
      color: @onSurface;
      caret-color: @onSurface;
    }

    #input placeholder,
    .input placeholder { opacity: 0.5; }

    #input:focus,
    #input:active,
    .input:focus, .input:active {
      box-shadow: none;
      outline: none;
    }

    child:selected,
    child:hover,
    child:selected .item-box {
      background: alpha(@primary, 0.35);
    }

    child:selected #item *,
    child:selected .item-box * {
      color: @onSurface;
    }

    #item,
    .item-box {
      padding: 10px 0 10px 14px;
      border-radius: 10px;
    }

    child:hover .item-box {
      background: alpha(@primary, 0.2);
    }

    #text,
    .item-text-box {
      all: unset;
      padding: 14px 0;
    }

    #sub,
    .item-subtext {
      font-size: 0px;
      min-height: 0px;
      margin: 0px;
      padding: 0px;
      opacity: 0;
    }

    #icon,
    .item-image {
      margin-right: 14px;
      -gtk-icon-transform: scale(0.9);
    }

    .current {
      font-style: italic;
      color: @onSurfaceVariant;
    }

    .keybinds,
    .keybinds-wrapper,
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
in
{
  programs = {
    elephant = {
      settings = {
        terminal_cmd = lib.getExe pkgs.ghostty;
      };
    };

    walker = {
      enable = true;
      runAsService = true;

      config = {
        force_keyboard_focus = true;
        theme = "omarchy";
      };

      themes.omarchy.style = omarchyStyle;
    };
  };
}

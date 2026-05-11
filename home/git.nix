{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "ShangYJQ";
        email = "421207553@qq.com";
      };
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };
}

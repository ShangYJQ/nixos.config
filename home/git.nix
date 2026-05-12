{ unstable, ... }:

{
  programs.git = {
    enable = true;
    package = unstable.git;
    settings = {
      user = {
        name = "ShangYJQ";
        email = "421207553@qq.com";
      };
      init.defaultBranch = "main";
      core.editor = "nvim";

      credential.helper = "store";
    };
  };
}

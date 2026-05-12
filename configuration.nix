{
  config,
  pkgs,
  unstable,
  userName,
  hostName,
  flakePath,
  ...
}:

{

  nixpkgs.config = {
    allowUnfree = true;
  };

  imports = [
    ./home.nix
  ];

  system.stateVersion = "25.11";

  nix = {
    settings = {
      auto-optimise-store = true;

      extra-substituters = [
        "https://cache.garnix.io"
      ];

      extra-trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  networking = {
    # for nuxt dev server
    firewall.allowedTCPPorts = [
      3000
      4000
    ];
    inherit hostName;
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      PubkeyAuthentication = true;
      PermitRootLogin = "yes";
      AllowUsers = [
        "root"
        userName
      ];
    };
  };

  programs = {
    fish = {
      enable = true;
      package = unstable.fish;
    };

    nh = {
      enable = true;
      flake = flakePath;

      clean = {
        enable = true;
        extraArgs = "--keep 5 --keep-since 3d";
      };

    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
      ];
    };
  };

  security.sudo.enable = true;

  users.users.root = {
    shell = unstable.fish;
    initialPassword = "985211";
    openssh.authorizedKeys.keyFiles = [ ./keys/yjq.pub ];
  };

  users.users.${userName} = {
    shell = unstable.fish;
    isNormalUser = true;
    initialPassword = "985211";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [ ./keys/yjq.pub ];
  };

  environment.systemPackages = with pkgs; [
    unstable.git
    vim
    curl
    wget
    unstable.htop
    ncurses
    pciutils
  ];
}

{
  config,
  pkgs,
  unstable,
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

  systemd.suppressedSystemUnits = [
    "sys-kernel-debug.mount"
  ];

  boot.isContainer = true;

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  networking = {
    # for nuxt dev server
    firewall.allowedTCPPorts = [ 3000 ];
    hostName = "nixos";
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
        "yjq"
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
      flake = "/etc/nixos";

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
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDg7siDZ3Jh6hARmkF/EvbqIW2xDMrLLVU8PZsH5/zYYrTrlWrqWOqM+55A5CTGfE+hIiVokhaRaFusoHuWGTXGoH6+P7va8BqvV/Un/xwfVgphcmtpx4CRYvGoZy7tLh27bwMFa4LAbG4Ba9D/PJy+ddb9qnWiyiQjBAktTTY6VWCisFOZnFvCZRXaqqadszPHyjY3rrRHVbxJBhLhoTb6hv8so51vUjCmUfC64OkC8bLRKYXP1WA4FEZ4tRK1ot03Om0RsPfTgIVPS7dtxwuDawerf3m8tmusMI4PtxCPqDq7m9+cTelx5sTHryuNobNjNB7JNmmrNZouJ9mV+SHGw+lJMWnrOTGOsR1jn/L/NnifZpGiVuhRum9swYZVk99xjJ3cxm5ierYB9e8Yqgf/+1mf0QWfYYmZAeU1aT1HFdR7ttQr9BjFdturf5QlYsQ77wKG3IoB1uME7BSdTIDzOM1LQFl5RQZnn8HVA2ZmujR12BE7rlCFghHFOgxmn2s= 421207553@qq.com"
    ];
  };

  users.users.yjq = {
    shell = unstable.fish;
    isNormalUser = true;
    initialPassword = "985211";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDg7siDZ3Jh6hARmkF/EvbqIW2xDMrLLVU8PZsH5/zYYrTrlWrqWOqM+55A5CTGfE+hIiVokhaRaFusoHuWGTXGoH6+P7va8BqvV/Un/xwfVgphcmtpx4CRYvGoZy7tLh27bwMFa4LAbG4Ba9D/PJy+ddb9qnWiyiQjBAktTTY6VWCisFOZnFvCZRXaqqadszPHyjY3rrRHVbxJBhLhoTb6hv8so51vUjCmUfC64OkC8bLRKYXP1WA4FEZ4tRK1ot03Om0RsPfTgIVPS7dtxwuDawerf3m8tmusMI4PtxCPqDq7m9+cTelx5sTHryuNobNjNB7JNmmrNZouJ9mV+SHGw+lJMWnrOTGOsR1jn/L/NnifZpGiVuhRum9swYZVk99xjJ3cxm5ierYB9e8Yqgf/+1mf0QWfYYmZAeU1aT1HFdR7ttQr9BjFdturf5QlYsQ77wKG3IoB1uME7BSdTIDzOM1LQFl5RQZnn8HVA2ZmujR12BE7rlCFghHFOgxmn2s= 421207553@qq.com"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    htop
    ncurses
  ];
}

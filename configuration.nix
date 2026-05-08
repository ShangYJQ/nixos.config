{ config, pkgs, ... }:

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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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
      AllowUsers = [ "root" ];
    };
  };

  programs = {
    fish.enable = true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
      ];
    };
  };

  users.users.root = {
    shell = pkgs.fish;
    initialPassword = "985211";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDg7siDZ3Jh6hARmkF/EvbqIW2xDMrLLVU8PZsH5/zYYrTrlWrqWOqM+55A5CTGfE+hIiVokhaRaFusoHuWGTXGoH6+P7va8BqvV/Un/xwfVgphcmtpx4CRYvGoZy7tLh27bwMFa4LAbG4Ba9D/PJy+ddb9qnWiyiQjBAktTTY6VWCisFOZnFvCZRXaqqadszPHyjY3rrRHVbxJBhLhoTb6hv8so51vUjCmUfC64OkC8bLRKYXP1WA4FEZ4tRK1ot03Om0RsPfTgIVPS7dtxwuDawerf3m8tmusMI4PtxCPqDq7m9+cTelx5sTHryuNobNjNB7JNmmrNZouJ9mV+SHGw+lJMWnrOTGOsR1jn/L/NnifZpGiVuhRum9swYZVk99xjJ3cxm5ierYB9e8Yqgf/+1mf0QWfYYmZAeU1aT1HFdR7ttQr9BjFdturf5QlYsQ77wKG3IoB1uME7BSdTIDzOM1LQFl5RQZnn8HVA2ZmujR12BE7rlCFghHFOgxmn2s= 421207553@qq.com"
    ];
  };
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    htop
    fish
    ncurses
  ];
}

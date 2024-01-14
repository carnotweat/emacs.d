{ pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixos-shell.mounts = {
    mountHome = false;
    mountNixProfile = false;	
    cache = "none"; # default is "loose"
    extraMounts = {
      "/mnt" = ./.;
    };
    extraMounts = {
    # simple USB stick sharing
    "/media" = /media;

    # override options for each mount
    "/var/www" = {
      target = ./src;
      cache = "none";
    };
  };
  };
  nix.nixPath = [
    "nixpkgs=${pkgs.path}"
  ];
  networking.firewall.enable = true;
  virtualisation = {
  libvirtd.enable = true;
  cores = 2;
  memorySize = 1024;
  diskSize = 100 * 1024;
  writableStoreUseTmpfs = false;
  };
  forwardPorts = [
      { from = "host"; host.port = 2222; guest.port = 22; }
    ];
  qemu = {
  qemu.options = [
  #disable kvm?
  QEMU_OPTS="-cpu max"
  "-hdc" "/dev/sda"
  "-bios" "${pkgs.OVMF.fd}/FV/OVMF.fd"
  	       ];	
  networkingOptions = [ "-nic bridge,br=br0,model=virtio-net-pci,mac=11:11:11:11:11:11,helper=/run/wrappers/bin/qemu-bridge-helper" ];
  }; 
  users.users.dev.isNormalUser = true;
  users.users.root.openssh.authorizedKeys.keyFiles = [ ~/.ssh/id_rsa.pub];
  nix = {
    package = pkgs.nixUnstable;
    settings.trusted-users = [ "root" "user" ];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  services.openssh.enable = true;
  services.xserver.enable = true;
  virtualisation.graphics = true;
  programs.git.enable = true;
  environment.systemPackages = with pkgs; [
    moreutils tree jq htop emacs fish oath-toolkit gnupg openssl
  ];
}

{pkgs, ...}: {
  imports = [./udev.nix];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.enable = true;
  hardware.pulseaudio.support32Bit = true;

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    protontricks
    # proton-caller
    # python3
    # retroarchBare
    # pcsx2
    # qjoypad
    vulkan-tools
    vulkan-loader
  ];

  # services.wii-u-gc-adapter.enable = true;

  # fps games on laptop need this
  # services.xserver.libinput.disableWhileTyping = false;

  # better for steam proton games
  systemd.extraConfig = "DefaultLimitNOFILE=1048576";

  # improve wine performance
  # environment.sessionVariables = { WINEDEBUG = "-all,fixme-all"; };
}

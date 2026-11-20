{
  config,
  pkgs,
  ...
}: {
  imports = [./pipewire.nix ./sway ../develop ../network ./im];

  hardware.graphics.enable = true;

  boot = {
    tmp.useTmpfs = true;

    kernel.sysctl."kernel.sysrq" = 1;
  };

  users.users.${config.my.user.name}.packages = with pkgs; [
    v4l-utils
  ];

  home-manager.sharedModules = [./home.nix];

  # Wayland support
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    evince
    imv
    paper-icon-theme
    firefox
    chromium

    wf-recorder
    ffmpeg

    anki
  ];

  fonts = {
    packages = with pkgs; [
      font-awesome # waybar icons: TODO: move to there
      noto-fonts
      noto-fonts-cjk-sans
      twitter-color-emoji
      inter
      fira-code
      fira-mono
      fira
      libertine
      roboto
      proggy
      cozette
    ];
    fontconfig.defaultFonts = {
      serif = ["Linux Libertine O"];
      sansSerif = ["Inter"];
      monospace = ["Fira Code"];
      emoji = ["Twitter Color Emoji"];
    };
    # Bind Inter to Helvetica
    fontconfig.localConf = ''
      <fontconfig>
        <match>
          <test name="family"><string>Helvetica</string></test>
          <edit name="family" mode="assign" binding="strong">
            <string>Inter</string>
          </edit>
        </match>
      </fontconfig>
    '';
  };
}

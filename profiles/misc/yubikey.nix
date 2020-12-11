{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # yubico-piv-tool
    yubikey-personalization
    yubikey-manager
    pinentry-curses # TODO move to general gpg
  ];

  # smart card mode (CCID) for gpg keys
  services.pcscd.enable = true;

  security.pam.u2f = {
    enable = true;

    # create key: `pamu2fcfg`
    authFile = pkgs.writeText "u2f_keys" ''
    speed:BrgFsoVXT5i6cn9gU/qy9wS7uhFnR/5KceLJQFP3+SmQ+0g1chxXYzpWwzeDhyBBYMBpsyEmtRKgdOQrhGXhLA==,3OktBosHbWOwbJXWkG0g0k/Yymh6eSgVwHH8/jECWnnTNG5me26sU8hkCxdfS2BpPGJLasQxT2OHg8ql6MoeuA==,es256,+presence
    speed:1BaBxWeS2ClIpyWlrEpTJylYeXNl9qNAvIeHaD28t5HFK5iRWOsy2VY+KW9WkMnr2yrM8dXp3U9cVJiG6XjqaQ==,VR6wUpt67GGZD6r7cQKcF3DqM/MLR5lXguMy3jaQkcB/YtLqaEIrzEThXZFco4TAIlodjlTDk98Sy3DiaeeD1w==,es256,+presence
    '';
  };
}

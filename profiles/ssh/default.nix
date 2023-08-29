_: {
  services.openssh = {
    enable = true;
    ports = [777];
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };
}

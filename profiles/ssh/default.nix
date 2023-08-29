_: {
  services.openssh = {
    enable = true;
    ports = [777];
    KbdInteractiveAuthentication = false;
    PasswordAuthentication = false;
  };
}

{...}: {
  services.openssh = {
    enable = true;
    ports = [777];
    challengeResponseAuthentication = false;
    passwordAuthentication = false;
  };
}

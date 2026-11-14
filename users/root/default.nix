{lib, ...}: {
  # locked, use sudo
  users.users.root.hashedPassword = "!";
}

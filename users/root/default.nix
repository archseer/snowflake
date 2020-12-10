{ lib, ... }:
{
  # users.users.root.password = "";
  users.users.root.hashedPassword = lib.mkForce "$6$F5AAi9NA8wWXXW$eY/MXfj2bkPDdxJRaNvCdadmol0zW5E2VrWdnatgnHEakDqPfJ/Mt61iOznD.rsO8hGde01zU2113xgVfk3F2/";
}

{ pkgs, lib, ... }:
{
  services.wlsunset = {
    enable = true;
    longitude = "35.7";
    latitude = "139.7";
    temperature.day = 6500;
    # temperature.night = 2700;
    temperature.night = 1900;
  };

  # [redshift]
  # temp-day=5700
  # temp-night=1900

  # dawn-time=6:00-7:45
  # dusk-time=16:00-22:00
}

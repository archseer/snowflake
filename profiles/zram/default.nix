{
  # Use zram for swap
  swapDevices = [];
  zramSwap.enable = true;
  # zram is relatively cheap, prefer swap
  boot.kernel.sysctl."vm.swappiness" = 180;
  boot.kernel.sysctl."vm.watermark_boost_factor" = 0;
  boot.kernel.sysctl."vm.watermark_scale_factor" = 125;
  # zram is in memory, no need to readahead
  boot.kernel.sysctl."vm.page-cluster" = 0;
}
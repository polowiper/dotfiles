# KVM/QEMU virtualisation: libvirtd, virt-manager, spice redirection.
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    phodav
    gnome-boxes
    dnsmasq
    qemu
    virt-viewer
  ];

  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;
  users.groups = {
    libvirtd.members = ["polo"];
    kvm.members = ["polo"];
  };
}

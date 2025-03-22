{
  config,
  pkgs,
  host,
  username,
  options,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    hyprpicker
    hyprpaper
    grimblast
    slurp
    greetd.tuigreet
  ];

  ## Portals
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
  };

  ## Login Manager
  services = {
    greetd = {
      enable = true;
      vt = 3;
      settings = {
        default_session = {
          # Wayland Desktop Manager is installed only for user ryan via home-manager!
          user = username;
          # .wayland-session is a script generated by home-manager, which links to the current wayland compositor(sway/hyprland or others).
          # with such a vendor-no-locking script, we can switch to another wayland compositor without modifying greetd's config here.
          # command = "$HOME/.wayland-session"; # start a wayland session directly without a login manager
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland"; # start Hyprland with a TUI login manager
        };
        initial_session = {
          command = "${pkgs.hyprland}/bin/hyprland";
          user = username;
        };
      };
    };
  };

  ## Keyring
  gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true; # unlocks keyring
  environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID"; # set the runtime directory fixes keyring unlock


  ## Hyprland Cachix
  nix = {
    settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
  };
}

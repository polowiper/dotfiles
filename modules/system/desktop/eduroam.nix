# eduroam CA certificate used by NetworkManager.
{...}: {
  environment.etc."NetworkManager/grenoble-inp-eduroam-ca.pem".source = ./grenoble-inp-eduroam-ca.pem;
}

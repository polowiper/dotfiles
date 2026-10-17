# eduroam CA certificate used by NetworkManager.
{...}: {
  environment.etc."NetworkManager/eduroam-ca.pem".source = ./eduroam-ca.pem;
}

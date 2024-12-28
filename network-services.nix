{ config, pkgs, ... }: 

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 
      # SSH
      22

      # AdGuard Home UI
      3003

      # Unifi
      8080 # Port for UAP to inform controller.
      8880 # Port used for HTTP portal redirection.
      8843 # Port used for HTTPS portal redirection.
      8443 # Port used for application GUI/API as seen in a web browser.
      6789 # Port for UniFi mobile speed test.
    ];
    allowedUDPPorts = [ 
      # AdGuard Home DNS
      53

      # Unifi
      3478 # UDP port used for STUN.
      1900 # Port used for "Make application discoverable on L2 network" in the UniFi Network settings.
      10001 # Port used for device discovery.
    ];
  };

  services.adguardhome = {
    enable = true;
    settings = {
      http = {
        # You can select any ip and port, just make sure to open firewalls where needed
        address = "192.168.1.201:3003";
      };
      dns = {
        upstream_dns = [
          "tls://family.cloudflare-dns.com"
          
          # Uncomment the following to use a local DNS service (e.g. Unbound)
          # Additionally replace the address & port as needed
          # "127.0.0.1:5335"
        ];
      };
      filtering = {
        protection_enabled = true;
        filtering_enabled = true;

        parental_enabled = false;  # Parental control-based DNS requests filtering.
        safe_search = {
          enabled = true;  # Enforcing "Safe search" option for search engines, when possible.
        };
      };
    };
  };

  # https://help.ui.com/hc/en-us/articles/218506997-UniFi-Ports-Used
  services.unifi = {
    enable = true;
    openFirewall = true;
    unifiPackage = pkgs.unifi8;
    mongodbPackage = pkgs.mongodb-7_0;
  };
}

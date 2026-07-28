{ config, pkgs, ... }:

{
  # --- PHP-FPM ---
  services.phpfpm.pools.www = {
    user = "mellowcat";
    group = "mellowcat";
    settings = {
      "listen.owner" = config.services.httpd.user;
      "listen.group" = config.services.httpd.group;
      "pm" = "dynamic";
      "pm.max_children" = 10;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 5;
    };
    phpPackage = pkgs.php.withExtensions ({ enabled, all }: enabled ++ [
      all.pdo_mysql
      all.mbstring
      all.tokenizer
      all.xml
      all.ctype
      all.json
      all.bcmath
      all.curl
      all.zip
      all.fileinfo
      all.openssl
      all.gd
    ]);
  };

  # --- Apache, serve /var/www/html sebagai document root umum ---
  services.httpd = {
    enable = true;
    adminAddr = "you@example.com";
    virtualHosts."localhost" = {
      documentRoot = "/var/www/html";
      extraConfig = ''
        <Directory "/var/www/html">
          AllowOverride All
          Require all granted
          DirectoryIndex index.php index.html
        </Directory>
      '';
      locations."/".extraConfig = ''
        <FilesMatch \.php$>
          SetHandler "proxy:unix:${config.services.phpfpm.pools.www.socket}|fcgi://localhost"
        </FilesMatch>
      '';
    };
  };

  # --- MariaDB ---
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  # --- phpMyAdmin di localhost/phpmyadmin ---
  services.phpMyAdmin = {
    enable = true;
    hostName = "localhost";
    httpd.virtualHost = "localhost";
    # Izinkan login root tanpa password (khusus dev lokal, JANGAN dipakai di server publik)
    settings.Servers.AllowNoPassword = true;
  };

  # --- Composer ---
  environment.systemPackages = with pkgs; [
    phpPackages.composer
  ];
}
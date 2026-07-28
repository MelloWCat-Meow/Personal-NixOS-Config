{ config, pkgs, ... }:

let
  phpWithExts = pkgs.php.withExtensions (
    { enabled, all }:
    enabled
    ++ [
      all.pdo_mysql
      all.mbstring
      all.tokenizer
      all.xml
      all.ctype
      all.bcmath
      all.curl
      all.zip
      all.fileinfo
      all.openssl
      all.gd
    ]
  );
in
{
  # --- PHP-FPM ---
  services.phpfpm.pools.www = {
    user = "mellowcat";
    group = "users";
    settings = {
      "listen.owner" = config.services.httpd.user;
      "listen.group" = config.services.httpd.group;
      "pm" = "dynamic";
      "pm.max_children" = 10;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 5;
    };
    phpPackage = phpWithExts;
  };

  # --- Apache, serve /var/www/html sebagai document root umum ---
  services.httpd = {
    enable = true;
    adminAddr = "alansuranjana2103@gmail.com";
    extraModules = [
      "proxy"
      "proxy_fcgi"
    ];
    virtualHosts."localhost" = {
      documentRoot = "/var/www/html";
      extraConfig = ''
        <Directory "/var/www/html">
          AllowOverride All
          Require all granted
          DirectoryIndex index.php index.html
        </Directory>

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

  # --- CLI tools: PHP CLI (sama persis dengan yang dipakai PHP-FPM), Composer, dll ---
  environment.systemPackages = with pkgs; [
    phpWithExts
    phpPackages.composer
    nodejs_26
  ];
}
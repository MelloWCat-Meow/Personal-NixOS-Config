{ ... }:

let
  wallpaper = ../../wallpapers/gdm.png;
in
{
  nixpkgs.overlays = [
    (final: prev: {
      gnome-shell = prev.gnome-shell.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          theme=$out/share/gnome-shell/gnome-shell-theme.gresource
          work=$(mktemp -d)
          prefix=/org/gnome/shell/theme/

          # bongkar gresource
          for r in $(gresource list "$theme"); do
            rel="''${r#$prefix}"
            mkdir -p "$work/$(dirname "$rel")"
            gresource extract "$theme" "$r" > "$work/$rel"
          done

          # tambahkan override latar di CSS khusus GDM
          test -f "$work/gdm.css" || { echo "gdm.css tidak ditemukan"; exit 1; }
          cat >> "$work/gdm.css" <<EOF

          #lockDialogGroup {
            background: #000000 url(file://${wallpaper});
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
          }
          EOF

          # kemas ulang
          {
            echo '<?xml version="1.0" encoding="UTF-8"?>'
            echo '<gresources><gresource prefix="/org/gnome/shell/theme">'
            (cd "$work" && find . -type f -printf '<file>%P</file>\n')
            echo '</gresource></gresources>'
          } > "$work.xml"

          glib-compile-resources --sourcedir="$work" --target="$theme" "$work.xml"
        '';
      });
    })
  ];
}
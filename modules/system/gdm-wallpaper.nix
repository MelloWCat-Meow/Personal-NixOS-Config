
{ ... }:

let
  wallpaper = ../../wallpapers/gdm.png;
in
{
  nixpkgs.overlays = [
    (final: prev: {
      gnome-shell = prev.gnome-shell.overrideAttrs (old: {
        preFixup = (old.preFixup or "") + ''
          theme=$out/share/gnome-shell/gnome-shell-theme.gresource
          work=$(mktemp -d)
          prefix=/org/gnome/shell/theme/

          # Extract seluruh resource GNOME Shell
          for r in $(gresource list "$theme"); do
            rel="''${r#$prefix}"
            mkdir -p "$work/$(dirname "$rel")"
            gresource extract "$theme" "$r" > "$work/$rel"
          done

          # Modifikasi stylesheet GNOME Shell
          found=0

          for css in "$work"/gnome-shell*.css; do
            [ -f "$css" ] || continue
            found=1

            cat >> "$css" <<EOF

          /* Custom GDM Wallpaper */
          #lockDialogGroup {
            background: #000000 url("file://${wallpaper}");
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
          }
          EOF
          done

          if [ "$found" -eq 0 ]; then
            echo "GNOME Shell CSS tidak ditemukan!"
            find "$work" -type f
            exit 1
          fi

          # Rebuild GResource
          {
            echo '<?xml version="1.0" encoding="UTF-8"?>'
            echo '<gresources><gresource prefix="/org/gnome/shell/theme">'
            (cd "$work" && find . -type f -printf '<file>%P</file>\n')
            echo '</gresource></gresources>'
          } > "$work.xml"

          glib-compile-resources \
            --sourcedir="$work" \
            --target="$theme" \
            "$work.xml"

          rm -rf "$work" "$work.xml"
        '';
      });
    })
  ];
}

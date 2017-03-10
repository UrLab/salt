apt-get-update:
  cmd.wait:
    - name: apt-get update

{{ grains.lsb_distrib_codename }}-backports-repo:
  pkgrepo.managed:
    - humanname: Debian {{ grains.lsb_distrib_codename }} Backports repository
    - name: deb http://ftp.uk.debian.org/debian {{ grains.lsb_distrib_codename }}-backports main
    - file: /etc/apt/sources.list.d/backports.list
    - refresh_db: False
    - watch_in:
       - cmd: apt-get-update

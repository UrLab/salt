{% from "acme/map.jinja" import acme with context %}

acme-client-git:
  git.latest:
    - name: https://github.com/letsencrypt/letsencrypt
    - target: {{ acme.bin_dir }}
    - force_reset: True

acme-config:
  file.managed:
    - name: /etc/letsencrypt/cli.ini
    - makedirs: true
    - source: salt://acme/cli.ini
    - template: jinja
    - context:
      email: {{ acme.email }}
      webroot: {{ acme.webroot }}

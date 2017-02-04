tinc_bridgeutils:
  pkg.installed:
    - name: bridge-utils
    - require_in:
      - file: /etc/tinc/urlab/tinc-up
      - file: /etc/tinc/urlab/tinc-down

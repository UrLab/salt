oidentd:
  pkg:
    - installed
  service.running:
    - watch:
      - pkg: oidentd
      - file: /etc/oidentd.conf

oidentd-config:
  file.managed:
    - name: /etc/oidentd.conf
    - source: salt://oidentd/config/oidentd.conf
    - user: root
    - group: root
    - mode: 644


base_nscd_pkg:
  pkg.installed:
    - name: nscd

base_nscd_service:
  service.running:
    - name: nscd
    - enable: True
    - require:
      - pkg: base_nscd_pkg
      - file: base_nscd_conf
    - watch:
      - file: base_nscd_conf

base_nscd_conf:
  file.managed:
    - name: /etc/nscd.conf
    - source: salt://base/file/nscd.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: base_nscd_pkg



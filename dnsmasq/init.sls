dnsmasq_pkg:
  pkg.installed:
    - name: dnsmasq

dnsmasq_service:
  service.running:
    - name: dnsmasq
    - enable: true
    - require:
      - pkg: dnsmasq_pkg

dnsmasq_file:
  file.managed:
    - name: /etc/dnsmasq.conf
    - source: salt://dnsmasq/files/dnsmasq.conf.jinja
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: dnsmasq_service



dnsmasq_pkg:
  pkg.installed:
    - name: dnsmasq

dnsmasq_service:
  service.running:
    - name: dnsmasq
    - enable: true
    - require:
      - pkg: dnsmasq_pkg

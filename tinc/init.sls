tinc:
  pkg:
    - installed
  service.running:
    - enable: True
    - watch:
      - pkg: tinc

/etc/tinc/urlab/hosts:
  file.directory:
    - user: root
    - group: root
    - mode: 700
    - makedirs: True

/etc/tinc/urlab/tinc.conf:
  file.managed:
    - source: salt://tinc/files/tinc.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - watch-in:
      - service: tinc

/etc/tinc/nets.boot:
  file.managed:
    - source: salt://tinc/files/nets.boot
    - user: root
    - group: root
    - mode: 600

/etc/tinc/urlab/tinc-up:
  file.managed:
    - source: salt://tinc/files/tinc-up
    - template: jinja
    - user: root
    - group: root
    - mode: 700

/etc/tinc/urlab/tinc-down:
  file.managed:
    - source: salt://tinc/files/tinc-down
    - template: jinja
    - user: root
    - group: root
    - mode: 700

{% for hostname, config in pillar['tinc'].items() %}
/etc/tinc/urlab/hosts/{{hostname}}:
  file.managed:
    - source: salt://tinc/files/hosts
    - template: jinja
    - include_empty: True
    - user: root
    - group: root
    - mode: 600
    - config: {{ config }}
{% endfor %}

net.ipv4.ip_forward:
  sysctl.present:
    - value: 1

{% for hostname, config in pillar['tinc'].items() %}
tinc-hosts-{{hostname}}:
  host.present:
    - ip: {{config['private_ip']}
    - names:
      - {{ hostname }}.tinc
{% endfor %}

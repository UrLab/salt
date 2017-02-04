{% set id = grains['id'] %}
{% set tinc = pillar['tinc'] %}

tinc:
  pkg:
    - installed
  service.running:
    - enable: True
    - reload: False
    - require:
      - pkg: tinc

/etc/tinc/urlab/hosts:
  file.directory:
    - user: root
    - group: root
    - mode: 700
    - makedirs: True
    - require:
      - pkg: tinc

/etc/tinc/urlab/tinc.conf:
  file.managed:
    - source: salt://tinc/files/tinc.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - require:
      - file: /etc/tinc/urlab/hosts


/etc/tinc/nets.boot:
  file.managed:
    - source: salt://tinc/files/nets.boot
    - user: root
    - group: root
    - mode: 600

{%- if tinc[id]['bridge'] is defined %}
include:
  - .bridge
{% endif %}

/etc/tinc/urlab/tinc-up:
  file.managed:
    - source: salt://tinc/files/tinc-up
    - template: jinja
    - user: root
    - group: root
    - mode: 700
    - require:
      - file: /etc/tinc/urlab/hosts


/etc/tinc/urlab/tinc-down:
  file.managed:
    - source: salt://tinc/files/tinc-down
    - template: jinja
    - user: root
    - group: root
    - mode: 700
    - require:
      - file: /etc/tinc/urlab/hosts


{% for hostname, config in tinc.items() %}

/etc/tinc/urlab/hosts/{{hostname}}:
  file.managed:
    - source: salt://tinc/files/hosts
    - template: jinja
    - include_empty: True
    - user: root
    - group: root
    - mode: 600
    - config: {{ config }}
    - require:
      - file: /etc/tinc/urlab/hosts

tinc-hosts-{{ hostname }}:
  host.present:
    - ip: {{ config['private_ip'] }}
    - names:
      - {{ hostname }}.tinc

{% endfor %}

net.ipv4.ip_forward:
  sysctl.present:
    - value: 1



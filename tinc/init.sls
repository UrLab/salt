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

{%- if tinc[id] is defined and tinc[id]['bridge'] is defined %}
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

{% if config['private_ip'] is defined %}
tinc-hosts-{{ hostname }}:
  host.present:
    - ip: {{ config['private_ip'] }}
    - names:
      - {{ hostname }}.tinc
{% endif %}

{% endfor %}


{% if tinc[id] is defined and tinc[id]["custom"] is defined %}
{% for host, config in tinc[id]['custom']['hosts'].items() %}

{% if config["up"] is defined %}
/etc/tinc/urlab/hosts/{{host}}-up:
  file.managed:
    - source: salt://tinc/files/host-up
    - template: jinja
    - include_empty: True
    - user: root
    - group: root
    - mode: 700
    - config:
       id: {{ id }}
       host: {{ host }}
    - require:
      - file: /etc/tinc/urlab/hosts
{% endif %}

{% if config["down"] is defined %}
/etc/tinc/urlab/hosts/{{host}}-down:
  file.managed:
    - source: salt://tinc/files/host-down
    - template: jinja
    - include_empty: True
    - user: root
    - group: root
    - mode: 700
    - config:
       id: {{ id }}
       host: {{ host }}
    - require:
      - file: /etc/tinc/urlab/hosts
{% endif %}



{% endfor %}
{% endif %}


net.ipv4.ip_forward:
  sysctl.present:
    - value: 1



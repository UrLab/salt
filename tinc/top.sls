tinc:
  pkg:
    - installed
  service.running:
    - enable: True
    - watch:
      - pkg: tinc

/etc/tinc/urlab:
  file.directory:
    - user: root
    - group: root
    - mode: 700
    - mkdirs: True

/etc/tinc/urlab/tinc.conf:
  file.managed:
    - source: salt://tinc/files/tinc.conf
    - user: root
    - group: root
    - mode: 600

/etc/tinc/nets.boot:
  file.managed:
    - source: salt://tinc/files/nets.boot
    - user: root
    - group: root
    - mode: 600

/etc/tinc/urlab/tinc-up:
  file.managed:
    - source: salt://tinc/files/tinc-up
    - user: root
    - group: root
    - mode: 700

/etc/tinc/urlab/tinc-down:
  file.managed:
    - source: salt://tinc/files/tinc-down
    - user: root
    - group: root
    - mode: 700

{% for hostname, config in pillar['tinc'].items() %}
/etc/tinc/urlab/{{hostname}}:
  file.managed:
    - source: salt://tinc/files/hosts
    - template: jinja
    - include_empty: True
    - user: root
    - group: root
    - mode: 600
{% endfor %}


/etc/network/interfaces.d/vibr1:
  file.managed:
    - source: salt://tinc.files/vibr1.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 600


tinc:
  pkg:
    - installed
  service.running:
    - enable: True
    - watch:
      - pkg: tinc

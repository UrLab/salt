exim4:
  service:
    - running
    - enable: True
    - watch:
      - cmd: update-exim4.conf
      - file: /etc/mailname

exim4-pkgs:
  pkg:
    - latest
    - names:
      - exim4-daemon-light

/etc/exim4/update-exim4.conf.conf:
  file.managed:
    - source: salt://mail/update-exim4.conf.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: exim4-pkgs

update-exim4.conf:
  cmd:
    - wait
    - watch:
      - file: /etc/exim4/update-exim4.conf.conf

/etc/mailname:
  file:
    - managed
    - source: salt://mail/mailname.j2
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - domainname: {{ pillar['hostname'] }}

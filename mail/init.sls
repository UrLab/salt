exim4-pkg:
  pkg:
    - latest
    - name: exim4-daemon-light

exim4-service:
  service:
    - running
    - enable: True
    - watch:
      - file: exim4-config 
      - file: exim4-mailname
    - require:
      - pkg: exim4-pkg

exim4-config:
  file.managed:
    - name: /etc/exim4/update-exim4.conf.conf
    - source: salt://mail/templates/update-exim4.conf.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: pkg-exim4

exim4-mailname:
  file.managed:
    - name: /etc/mailname
    - user: root
    - group: root
    - mode: 644
    - contents_grains: id
    - require:
      - pkg: pkg-exim4


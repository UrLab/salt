/usr/share/nginx/default_irc/index.html:
  file.managed:
    - source: salt://glowingbear/index.html
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - require:
      - pkg: nginx


/etc/nginx/sites-available/irc.urlab.be
  file.managed:
    - source: salt://glowingbear/vhost.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - makedirs: True
    - require:
      - pkg: nginx
      - file: /usr/share/nginx/default_irc/index.html
    - watch_in:
      - service: nginx


/etc/nginx/sites-enabled/irc.urlab.be:
  file.symlink:
    - makedirs: True
    - target: /etc/nginx/sites-available/irc.urlab.be
    - require:
        - file: /etc/nginx/sites-available/irc.urlab.be
    - watch_in:
      - service: nginx



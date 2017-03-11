{% set users = pillar.get('users', {}) %}
{% import_yaml "acme/config.yaml" as acme %}

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

/usr/share/nginx/default_irc/screenshot.png:
  file.managed:
    - source: salt://glowingbear/screenshot.png
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - require:
      - pkg: nginx


/etc/nginx/sites-available/irc.urlab.be:
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

/usr/share/nginx/glowingbear/:
  file.directory:
    - user: www-data
    - group: www-data
    - dir_mode: 700

/usr/share/nginx/glowingbear/-git:
  git.latest:
    - name: https://github.com/glowing-bear/glowing-bear.git
    - target: /usr/share/nginx/glowingbear/
    - user: www-data
    - rev: 0.5.0
    - force_reset: True


/usr/share/nginx/acme_webroot/:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755

irc.urlab.be:
  acme.cert:
    - aliases:
{% for username, user in users.items() %}
      - {{ username }}.irc.urlab.be
{% endfor %}
    - email: {{ acme.email }}
    - webroot: {{ acme.webroot }}
    - renew: True

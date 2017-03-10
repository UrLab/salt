{% set users = pillar.get('users', {}) %}


{% for username, user in users.items() %}
{%- if user.get('irc', False) %}

/etc/nginx/sites-available/relay-{{username}}:
  file.managed:
    - source: salt://weechat-relay/vhost.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - makedirs: True
    - context:
      port: {{60000 + user.uid}}
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx


/etc/nginx/sites-enabled/relay-{{username}}:
  file.symlink:
    - makedirs: True
    - target: /etc/nginx/sites-available/relay-{{username}}
    - require:
        - file: /etc/nginx/sites-available/relay-{{username}}
    - watch_in:
      - service: nginx


{%- endif %}
{% endfor %}




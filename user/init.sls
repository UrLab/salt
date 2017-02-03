{% set users = pillar.get('users', {}) %}

sudo:
  pkg.installed

{% for username, user in users.items() %}
user_{{ username }}:
  user.
{%- if user.get('absent', False) -%}
absent
{% else %}
present
{%- endif %}
    - name: {{ username }}
    - shell: {{ user.get('shell', '/bin/bash') }}
    - home: /home/{{ username }}
    - uid: {{ user['uid'] }}
    - gid_from_name: True
    - password: {{ user['password'] }}
    - enforce_password: False
{%- if user.get('sudo', False) %}
    - groups:
      - sudo
    - require:
      - pkg: sudo
{%- endif %}

{% if not user.get('absent', False) %}
sshkey_{{ username }}:
  file.managed:
    - name: /home/{{ username }}/.ssh/authorized_keys
    - source: salt://user/files/authorized_keys.jinja
    - replace: False
    - user: {{ username }}
    - group: {{ username }}
    - mode: 600
    - makedirs: True
    - dir_mode: 700
    - template: jinja
    - context:
      keys: {{ user.get('keys', []) }}
    - require:
      - user: {{ username }}
{%- endif %}

{% endfor %}


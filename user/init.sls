{% set users = pillar.get('users', {}) %}

user_sudo:
  pkg.installed:
    - name: sudo

{% for username, user in users.items() %}

{%- if user.get('absent', False) %}
user_{{ username }}:
  user.absent:
    - name: {{ username }}

{%- else %}
user_{{ username }}:
  user.present:
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
      - pkg: user_sudo
{%- endif %}

user_sshkey_{{ username }}:
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

user_aliases:
  file.managed:
    - name: /etc/aliases
    - source: salt://user/files/aliases.j2
    - user: root
    - group: root
    - mode: 644
    - template: jinja



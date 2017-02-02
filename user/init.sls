{% set users = pillar.get('users', {}) %}

sudo:
  pkg.installed

{% for username, user in users.items() %}
user_{{ username }}:
  user.present:
    - name: {{ username }}
    - shell: {{ user.get('shell', '/bin/bash') }}
    - home: /home/{{ username }}
    - uid: {{ user['uid'] }}
    - gid_from_name: True
    - password: {{ user['password'] }}
{% if user.get('sudo', False) %}
    - groups:
      - sudo
{% endif %}
    - enforce_password: False

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
{% endfor %}







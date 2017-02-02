{% set users = pillar.get('users', []) %}

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
    - replace: False
    - user: {{ username }}
    - group: {{ username }}
    - mode: 700
    - makedirs: True
    - dir_mode: 700
{% endfor %}








{% set users = pillar.get('users', []) %}
{% set userPresent = grains.get('users', '') %}


{% for user in users.items() %}
{% if user['username'] in userPresent %}
user_{{ user['username'] }}:
  user.present:
    - name: {{ user['username'] }}
    - shell: /bin/bash
    - home: /home/{{ user['username'] }}
    - uid: {{ user['uid'] }}
    - gid_from_name: True
    - password: {{ user['password'] }} 

sshkey_{{ user['username'] }}:
  file.managed:
    - name: /home/{{ user['username'] }}/.ssh/authorized_keys
    - user: {{ user['username'] }}
    - group: {{ user['username'] }}
    - mode: 700
    - makedirs: True
    - dir_mode: 700

{% endif %}
{% endfor %}







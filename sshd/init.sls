{% set users = pillar['users'] %}

sshd_pkg:
  pkg.installed:
    - name: openssh-server
  service.running:
     - name: ssh
     - watch:
       - file: sshd_conf
     - require:
       - pkg: sshd_pkg

sshd_fail2ban:
  pkg.installed:
    - name: fail2ban
  service.running:
     - name: fail2ban
     - require:
       - pkg: sshd_fail2ban

sshd_conf:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://sshd/
    - template: jinja
    - mode: 644
    - owner: root
    - group: root
    - context:
       AllowUsers:
{%- for username, user in users.iteritems() if not user.get('absent', False) and not user.get('local', False) %}
         - {{ username }}
{%- endfor %}
    - require:
      - pkg: sshd_pkg
{%- for username, user in users.iteritems() if not user.get('absent', False) and not user.get('local', False) %}
      - user: {{ username }}
{%- endfor %}





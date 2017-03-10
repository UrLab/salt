{% set users = pillar.get('users', {}) %}

irc_weechat_pkg:
  pkg.installed:
    - name: weechat

{% for username, user in users.items() %}
{%- if user.get('irc', False) %}

/home/{{ username }}/irc_startup.sh:
  file.managed:
    - source: salt://irc-client/templates/irc_startup.sh
    - user: {{ username }}
    - group: {{ username }}
    - mode: 700
    - replace: False

/home/{{ username }}/irc_startup.sh:
  cron.present:
    - user: {{ username }}
    - special: '@reboot'

/home/{{ username }}/.weechat:
  file.directory:
    - user: {{ username }}
    - group: {{ username }}
    - dir_mode: 700

# Weechat config

/home/{{ username }}/.weechat/alias.conf:
  file.managed:
    - source: salt://irc-client/templates/alias.conf.j2
    - user: {{ username }}
    - group: {{ username }}
    - template: jinja
    - mode: 500
    - replace: False
    - context:
      username: {{ username }}
      nickname: {{ user.get('nickname', username) }}

/home/{{ username }}/.weechat/irc.conf:
  file.managed:
    - source: salt://irc-client/templates/irc.conf.j2
    - user: {{ username }}
    - group: {{ username }}
    - template: jinja
    - mode: 500
    - replace: False
    - context:
      username: {{ username }}
      nickname: {{ user.get('nickname', username) }}

/home/{{ username }}/.weechat/relay.conf:
  file.managed:
    - source: salt://irc-client/templates/relay.conf.j2
    - user: {{ username }}
    - group: {{ username }}
    - template: jinja
    - mode: 500
    - replace: False
    - context:
      username: {{ username }}
      nickname: {{ user.get('nickname', username) }}
      relay_password: {{ salt['mod_random.random'](16) }}
      relay_port: {{ 60000 + user.uid }} # the range is thus 61k -> ~62k

/home/{{ username }}/.weechat/weechat.conf:
  file.managed:
    - source: salt://irc-client/templates/weechat.conf.j2
    - user: {{ username }}
    - group: {{ username }}
    - template: jinja
    - mode: 500
    - replace: False
    - context:
      username: {{ username }}
      nickname: {{ user.get('nickname', username) }}

{%- endif %}
{% endfor %}

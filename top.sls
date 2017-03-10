base:
  '*':
    - base
    - user
    - tinc
    - backports
  'shelob':
    - mail
  'applejack':
    - user.root
    - irc-client
    - nginx
    - weechat-relay

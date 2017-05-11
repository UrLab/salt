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
    - acme
    - weechat-relay
    - glowingbear
  'delight':
    - delight

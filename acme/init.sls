{% import_yaml "acme/config.yaml" as acme %}

/tmp/foo:
  file.managed:
    - contents: {{acme}}

base:
  '*':
    - users
    - docker
  'G@role:houston':
    - saltmaster
  'G@role:iss':
    - docker.pm_container
    - nginx
  'G@role:progress68':
    - graphite
    - grafana
    - postgres

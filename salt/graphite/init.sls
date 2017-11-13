# https://hub.docker.com/r/hopsoft/graphite-statsd/
graphite-image:
  docker_image.present:
    - tag: latest
    - name: hopsoft/graphite-statsd
    - require:
      - pip-docker-py

run-graphite:
  docker_container.running:
    - name: graphite
    - detach: true
    - image: hopsoft/graphite-statsd
    - port_bindings:
      - 8080:80
      - 2003:2003
      - 2004:2004
      - 2023:2023
      - 2024:2024
      - 8125:8125
      - 8126:8126
    - require:
      - graphite-image

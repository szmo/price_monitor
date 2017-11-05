graphite-image:
  docker_image.present:
    - tag: latest
    - name: hopsoft/graphite-statsd
    - require:
      - pip-docker-py

run-graphite:
  docker_containter.running:
    - name: graphite
    - detach: true
    - image: hopsoft/graphite-statsd
    - port_bindings:
      - 80:8080
      - 2003:2003
      - 2004:2004
      - 2023:2023
      - 2024:2024
      - 8125:8125
      - 8126:8126
    - require:
      - graphite-image

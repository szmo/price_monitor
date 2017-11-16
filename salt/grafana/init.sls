grafana-image:
  docker_image.present:
    - tag: latest
    - name: grafana/grafana
    - require:
      - pip-docker-py

run-grafana:
  docker_container.running:
    - name: grafana
    - detach: true
    - image: grafana/grafana
    - port_bindings:
      - 7777:3000
    - require:
      - grafana-image


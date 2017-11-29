ollert-image:
  docker_image.present:
    - tag: latest
    - name: rzarouali/docker-ollert
    - require: 
      - pip-docker-py

/etc/ollert/.env:
  file.managed:
    - source: salt://docker/ollert/env
    - makedirs: true

run-ollert:
  docker_container.stopped:
    - detach: true
    - image: rzarouali/docker-ollert
    - binds:
      - "/etc/ollert/.env:/srv/ollert/.env"
    - port_bindings:
      - 8080:4000
    - require:
      - /etc/ollert/.env
      - ollert-image

postgres-image:
  docker_image.present:
    - tag: 10
    - name: postgres
    - require:
      - pip-docker-py

run-postgres:
  docker_container.running:
    - name: postgres
    - detach: true
    - image: postgres:10
    - port_bindings:
      - 5432:5432
    - environment:
      - POSTGRES_USER: {{ grains.get('rails_pg_user') }}
      - POSTGRES_PASSWORD: {{ grains.get('rails_pg_password') }}
    - require:
      - postgres-image

install-psql:
  pkg.installed:
    pkgs: 
      - postgresql-client-common
      - postgresql-client

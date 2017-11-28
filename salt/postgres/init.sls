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
    - onchanges:
      - postgres
      - create-ext

install-psql:
  pkg.installed:
    - pkgs: 
      - postgresql-client-common
      - postgresql-client

postgres:
  user: {{ grains.get('rails_pg_user') }}
  pass: {{ grains.get('rails_pg_password') }}
  db: {{ grains.get('rails_pg_user') }}
  fromdb:
    query: 'create or replace function int2interval (x integer) returns interval as $$ select $1*'1 sec'::interval $$ language sql; create cast (integer as interval) with function int2interval (integer) as implicit;'

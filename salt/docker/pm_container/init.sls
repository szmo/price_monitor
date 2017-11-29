{% set current_version = "0.2.0" %}
{% set running_versions = salt.cmd.shell("docker ps | grep price_monitor | awk '{print $2}' | cut -d':' -f2") %}

{% if current_version not in running_versions %}

build_new_container:
  docker_image.present:
    - name: price_monitor:{{ current_version }}
    - build: /root/price_monitor/salt/docker/pm_container
    - force: true

stop_old_instance:
  docker_container.stopped:
    - names:
      - run-price-monitor
    - require:
      - build_new_container

remove_old_image:
  docker_container.absent:
    - names:
      - run-price-monitor
    - require:
      - stop_old_instance

run-price-monitor:
  docker_container.running:
    - detach: true
    - image: price_monitor:{{ current_version }}
    - extra_hosts:
      - graphite.price:{{ grains['storage_host'] }}
      - postgres.price:{{ grains['storage_host'] }}
    - environment:
      - rails_pg_password: {{ grains['rails_pg_password'] }}
      - rails_pg_user: {{ grains['rails_pg_user'] }}
      - SECRET_KEY_BASE: {{ grains['SECRET_KEY_BASE'] }}
      - RAILS_ENV: production
    - port_bindings:
      - 9999:3000
    - require:
      - build_new_container
      {% if running_versions %}
      - stop_old_instance
      - remove_old_instance
      {% endif %}

{% endif %}

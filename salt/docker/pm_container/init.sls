{% current_version = "0.0.1" -%}
{% running_versions = salt.cmd.run("docker ps | grep price_monitor | awk '{print $2}' | cut -d':' -f2") %}

{% if current_version not in running_versions %}

build_new_container:
  dockerio.built:
    - name: price_monitor
    - tag: {% current_version %-}
    - path: /root/price_monitor/salt/docker/pm_container

run_new_version:
  docker_container.running:
    - detach: true
    - image: price_monitor:{% current_version -%}
    - port_bindings:
      - 9999:3000
    - require:
      - build_new_container

{% endif %}

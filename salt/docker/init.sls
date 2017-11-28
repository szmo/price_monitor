pip-docker-py:
  pip.installed:
    - name: docker-py
    - reload_modules: True
    - require:
      - docker-dependencies

docker-dependencies:
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - ca-certificates
      - curl
      - software-properties-common
      - docker-ce
      - python-pip
    - require: 
      - update
      - docker-repo

docker-repo:
  pkgrepo.managed:
    - humanname: Docker-repo
    - name: deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable
    - file: /etc/apt/sources.list.d/docker.list
    - key_url: https://download.docker.com/linux/ubuntu/gpg
    - refresh_db: true

update:
  cmd.run:
    - name: apt-get update
    - require:
      - docker-repo

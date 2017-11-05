install-saltmaster:
  pkg.installed:
    - pkgs:
      - salt-master
      - salt-minion
    - require:
      - saltmaster-repo
      - update

saltmaster-repo:
  pkgrepo.managed:
    - humanname: Saltmaster-repo
    - name: deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main
    - file: /etc/apt/sources.list.d/saltstack.list
    - key_url: https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub
    - refresh_db: true

update-for-saltmaster:
  cmd.run:
    - name: apt-get update
    - require:
      - saltmaster-repo

copy-grains:
  file.managed:
    - source: salt://saltmaster/grains.j2
    - name: /etc/salt/grains

copy-master:
  file.managed:
    - source: salt://saltmaster/master.j2
    - name: /etc/salt/master

salt-master:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/salt/master
    - require:
      - install-saltmaster
      - create-symlink-to-repo

clone-repo:
  git.latest:
    - name: https://github.com/szmo/price_monitor.git
    - target: /root/price_monitor
    - branch: master

create-symlink-to-repo:
  cmd.run:
    - name: ln -s /root/price_monitor/salt /srv/
    - require:
      - clone-repo

su -s /bin/sh root -c 'cd /root/price_monitor/ && /usr/bin/git pull:
  cron.present:
    - user: root
    - minute: "*/1"

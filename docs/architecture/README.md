# `price_monitor` architecture

Price monitor is desined to be elastic time-series price monitoring tool.
It is avaliable at [price-monitor.tk](price-monitor.tk).

For its foundations, price-monitor uses:
1. Ruby on rails as main app framework
2. [Graphite](https://graphiteapp.org) for time-series metric storage
3. [AWS](https://aws.amazon.com) as infrastructure for vms, loadbalancing etc.
4. [SaltStack](https://saltstack.com) for vms managment and orchestration
5. [Docker](http://docker.io) for production deployment, we are running our apps in `docker containers`
6. [Grafana](https://grafana.com) for awesome time-series charts
7. [Trello](https://trello.com/b/TZanAiel/pricemonitoringasaservice) for kanban project managment


For more details see pictures below:

### Infrastructure:
[infra png](infra.png)

### Backend + Frontend
[backend + frontend png](backend.png)


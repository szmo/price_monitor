evemorgen:
  user.present:
    - fullname: Patryk Galczynski
    - home: /home/evemorgen
    - shell: /bin/bash
    - password: $6$G4czl17H$04BUjGrG9tinl1j6I7ZO2kr9WZ7y7R3HioLDNzJblkabeEru5aikiIaYnkzV6nYGHnQlqs.4PaEu4OfYjOLit/
    - groups:
      - sudo

evemorgen-ssh-key:
  ssh_auth.present:
    - user: evemorgen
    - config: '%h/.ssh/authorized_keys'
    - source: salt://users/ssh_keys/evemorgen.pub
    - require:
      - evemorgen

szmo:
  user.present:
    - fullname: Szymon Duda
    - home: /home/szmo
    - shell: /bin/bash
    - password: $6$KszngxCG$JsO2UbOeILPQqeOeMYi.csyXZGqEBJmMzcDL0.YI3owO/IJvixy.fQ.pNfBcHYMndw3qFQM2XzQjLlU9wovyg0
    - groups:
      - sudo

szmo-ssh-key:
  ssh_auth.present:
    - user: evemorgen
    - config: '%h/.ssh/authorized_keys'
    - source: salt://users/ssh_keys/szmo.pub
    - require:
      - szmo

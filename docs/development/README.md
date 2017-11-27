# How to start PriceMonitor development:

There are two ways to start `price_monitor` development, you can either clone repo and work localy, or pull `docker image` and develop inside container.

#### Main components:
1. Ruby on rails app
2. Saltstack vm configuration

Firstly clone `price_monitor`
```
pgalczynski@railsstuff:~$ git clone https://github.com/szmo/price_monitor ~/price_monitor
Cloning into '/home/pgalczynski/price_monitor'...
remote: Counting objects: 740, done.
remote: Compressing objects: 100% (13/13), done.
remote: Total 740 (delta 3), reused 4 (delta 1), pack-reused 726
Receiving objects: 100% (740/740), 75.95 MiB | 27.45 MiB/s, done.
Resolving deltas: 100% (367/367), done.
Checking connectivity... done.
```

#### Start developing rails part localy:
1. Installing `rbenv`
 It is highly recommended to install some ruby version manager. Feel free to use your own, we are using `rbenv` to develop PriceMonitor and all instructions assume that you're using it.
```
# credits to https://makandracards.com/makandra/28149-installing-rbenv-on-ubuntu
pgalczynski@railsstuff:~$ git clone https://github.com/rbenv/rbenv.git ~/.rbenv
Cloning into '/home/pgalczynski/.rbenv'...
remote: Counting objects: 2629, done.
remote: Total 2629 (delta 0), reused 0 (delta 0), pack-reused 2629
Receiving objects: 100% (2629/2629), 497.18 KiB | 0 bytes/s, done.
Resolving deltas: 100% (1644/1644), done.
Checking connectivity... done.

pgalczynski@railsstuff:~$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc

pgalczynski@railsstuff:~$ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
# remember to source new config
pgalczynski@railsstuff:~$ source ~/.bashrc
# check if rbenv is working fine
pgalczynski@railsstuff:~$ rbenv
rbenv 1.1.1-6-g2d7cefe
Usage: rbenv <command> [<args>]
...

# get rbenv install
pgalczynski@railsstuff:~$ git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# install deps
pgalczynski@railsstuff:~$ sudo apt-get install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev
Reading package lists... Done
Building dependency tree
```
2. Download `ruby 2.4.2`
```
# it might take longer than you think :P
pgalczynski@railsstuff:~$ rbenv install 2.4.2
Downloading ruby-2.4.2.tar.bz2...
-> https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.2.tar.bz2
Installing ruby-2.4.2...
```

4. Check for `ruby-version` inside `rails_app`
```
pgalczynski@railsstuff:~$ cd ~/price_monitor/rails_app/
pgalczynski@railsstuff:~/price_monitor/rails_app$ ruby -v
ruby 2.4.2p198 (2017-09-14 revision 59899) [x86_64-linux]
```

5. Install dependencies with bundler
```
# install cmake, it is necessary for rugged 0.26.0 native extension
pgalczynski@railsstuff:~/price_monitor/rails_app$ sudo apt-get install cmake
Reading package lists... Done
Building dependency tree
Reading state information... Done
...

# it also might take some time
pgalczynski@railsstuff:~/price_monitor/rails_app$ bin/bundle install
Fetching gem metadata from https://rubygems.org/.........
Using rake 12.2.1
Using concurrent-ruby 1.0.5
Using i18n 0.9.1
```

6. Run db migration
```
pgalczynski@railsstuff:~/price_monitor/rails_app$ bin/rails db:migrate
== 20171111205747 DeviseCreateUsers: migrating ================================
-- create_table(:users)
   -> 0.0012s
```

7. Start rails app
```
pgalczynski@railsstuff:~/price_monitor/rails_app$ bin/rails server
=> Booting Puma
=> Rails 5.1.4 application starting in development
=> Run `rails server -h` for more startup options
Puma starting in single mode...
* Version 3.10.0 (ruby 2.4.2-p198), codename: Russell's Teapot
* Min threads: 5, max threads: 5
* Environment: development
* Listening on tcp://0.0.0.0:3000
Use Ctrl-C to stop
```
8. Profit?

#### Start developing rails part inside docker container:

1. Build container localy or pull it from `dockehub`
```
14:37:51 evemorgen@Patryks-MacBook-Pro.local price_monitor master cd salt/docker/pm_container
14:38:11 evemorgen@Patryks-MacBook-Pro.local pm_container master docker build -t price_monitor .     
Sending build context to Docker daemon  3.584kB
Step 1/10 : FROM ruby:2.4.2-stretch
 ---> a81549825e75
Step 2/10 : EXPOSE 3000
 ---> Running in f8d411377851
 ---> 65d33efcd614
```

2. Run built image
```
docker run -p 3000:3000 -d price_monitor
```

3. Start development

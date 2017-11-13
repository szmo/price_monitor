FROM ruby:2.4.2-stretch
EXPOSE 3000

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs git cmake vim
RUN  git clone https://github.com/szmo/price_monitor.git 
WORKDIR /price_monitor/rails_app
RUN gem install rugged -v '0.26.0'
RUN bundle install

CMD rails server

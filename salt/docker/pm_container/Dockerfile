FROM ruby:2.4.2-stretch
EXPOSE 3000

ENV RAILS_ENV=production
ARG rails_pg_user=local
ARG rails_pg_password=local
ENV rails_pg_user=${rails_pg_user}
ENV rails_pg_password=${rails_pg_password}
RUN apt-get update -qq && apt-get install -y apt-transport-https
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs git cmake vim less yarn
RUN  git clone -b feature/postgres_db_engine https://github.com/szmo/price_monitor.git 
WORKDIR /price_monitor/rails_app
RUN bundle install
RUN rake assets:precompile
RUN rails_pg_user=${rails_pg_user} rails_pg_password=${rails_pg_password} rails db:migrate

CMD rails server

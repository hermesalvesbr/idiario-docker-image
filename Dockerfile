FROM ruby:2.4.10-slim-buster

RUN apt-get update -qq
RUN apt-get install -y build-essential libpq-dev nodejs npm iputils-ping
RUN apt-get install -y redis-server neovim cron tzdata wget git
RUN npm i -g yarn
EXPOSE 6379 

# horário do Brasil
ENV TZ="America/Recife"
RUN date

# i-diario v0.0.1
ENV IDIARIO_ROOT=/app
ARG IDIARIO_VERSION=1.4.1
RUN wget https://github.com/portabilis/i-diario/archive/refs/tags/${IDIARIO_VERSION}.tar.gz -O /tmp/idiario.tar.gz
# COPY softagon.php uploads.ini reports.sh ieducar-patch.tar.gz /tmp/


RUN mkdir $IDIARIO_ROOT
WORKDIR $IDIARIO_ROOT


## Copiando arquivos obrigatórios para a instalação
ADD . $IDIARIO_ROOT
ENV BUNDLE_PATH /box


# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
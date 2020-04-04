FROM ruby:2.7

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends nano mariadb-client-10.3



FROM amazonlinux:latest AS build

RUN yum install -y wget tar gzip

RUN wget https://dlcdn.apache.org/druid/24.0.0/apache-druid-24.0.0-bin.tar.gz \
    && tar -xzf apache-druid-24.0.0-bin.tar.gz

COPY /conf/. /apache-druid-24.0.0/conf/druid/single-server/nano-quickstart/

FROM amazoncorretto:11
RUN yum install -y perl

COPY --from=build /apache-druid-24.0.0 /apache-druid-24.0.0

EXPOSE 8888

ENTRYPOINT apache-druid-24.0.0/bin/start-nano-quickstart


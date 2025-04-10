FROM alpine:latest AS build

ARG VERSION

RUN apk add wget tar gzip

RUN wget https://dlcdn.apache.org/druid/${VERSION}/apache-druid-${VERSION}-bin.tar.gz \
    && tar -xzf apache-druid-${VERSION}-bin.tar.gz

RUN mv /apache-druid-${VERSION}/extensions /tmp/extensions

COPY /conf/. /apache-druid-${VERSION}/conf/druid/single-server/nano-quickstart/

FROM amazoncorretto:17.0.12-al2023-headless

ARG VERSION

RUN yum install -y perl

# Copy druid from build stage
COPY --from=build /apache-druid-${VERSION} /apache-druid

# Only use the extensions we need to reduce the image size
# See common.runtime.properties for the required extensions
COPY --from=build /tmp/extensions/druid-kafka-indexing-service /apache-druid/extensions/druid-kafka-indexing-service
COPY --from=build /tmp/extensions/druid-datasketches /apache-druid/extensions/druid-datasketches
COPY --from=build /tmp/extensions/druid-multi-stage-query /apache-druid/extensions/druid-multi-stage-query

EXPOSE 8888

ENTRYPOINT ["/apache-druid/bin/start-nano-quickstart"]

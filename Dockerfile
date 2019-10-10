# @reference:
#   https://hub.docker.com/r/prom/prometheus
FROM golang:1.13.1-alpine3.10 as builder
RUN    apk update && apk add \
           git \
           make \
           curl \
    && mkdir -p $GOPATH/src/github.com/prometheus \
    && cd $GOPATH/src/github.com/prometheus \
    && git clone https://github.com/prometheus/prometheus.git \
    && cd prometheus \
    && make build 

FROM alpine:3.10
COPY --from=builder /go/src/github.com/prometheus/prometheus/prometheus                            /app/prometheus
COPY --from=builder /go/src/github.com/prometheus/prometheus/promtool                              /app/promtool
COPY --from=builder /go/src/github.com/prometheus/prometheus/documentation/examples/prometheus.yml /app/prometheus.yml
COPY --from=builder /go/src/github.com/prometheus/prometheus/config/testdata/first.rules           /app/rules/first.rules
WORKDIR /app/
CMD [ "/app/prometheus", "--config.file=/app/prometheus.yml" ]

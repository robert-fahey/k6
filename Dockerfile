FROM golang:1.19-alpine as builder
ADD . .
RUN apk --no-cache add git
RUN go install go.k6.io/xk6/cmd/xk6@latest
RUN xk6 build --with github.com/grafana/xk6-output-prometheus-remote
RUN ln -s /go/k6 /usr/bin/k6

FROM alpine:3.16
RUN apk add --no-cache ca-certificates && \
    adduser -D -u 12345 -g 12345 k6
COPY --from=builder /go/k6 /usr/bin/k6

USER 12345
WORKDIR /home/k6
ENTRYPOINT ["k6"]
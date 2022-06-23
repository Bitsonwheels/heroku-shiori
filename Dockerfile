# build stage
FROM ghcr.io/ghcri/golang:1.17-alpine3.15 AS builder
WORKDIR /src
COPY . .
RUN go build -ldflags '-s -w'

# server image

FROM ghcr.io/ghcri/alpine:3.15
LABEL org.opencontainers.image.source https://github.com/Bitsonwheels/heroku-shiori/
COPY --from=builder /src/shiori /usr/bin/
RUN addgroup -g 1000 shiori \
 && adduser -D -h /shiori -g '' -G shiori -u 1000 shiori
USER shiori
WORKDIR /shiori
EXPOSE 8080
ENV SHIORI_DIR /shiori/
ARG ENV_SHIORI_DB=/shiori/
ENTRYPOINT ["/usr/bin/shiori"]
CMD ["serve --portable"]

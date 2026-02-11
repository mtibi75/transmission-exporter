# 1. fázis: Fordítás
FROM golang:1.21-alpine AS builder
WORKDIR /app
# Másoljuk a forráskódot
COPY . .
# Letöltjük a függőségeket és lefordítjuk a programot
RUN go mod download || true
RUN go build -o transmission-exporter ./cmd/transmission-exporter

# 2. fázis: Futtató környezet
FROM alpine:latest
RUN apk add --update ca-certificates
# Átmásoljuk a lefordított fájlt az első fázisból
COPY --from=builder /app/transmission-exporter /usr/bin/transmission-exporter

EXPOSE 19091
ENTRYPOINT ["/usr/bin/transmission-exporter"]

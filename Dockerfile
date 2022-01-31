# syntax=docker/dockerfile:1.2
#########################################################
# BUILD IMAGE
#########################################################

FROM golang:1.17 AS build
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . ./
RUN go build ./cmd/echo-server

#########################################################
# RELEASE IMAGE
#########################################################

FROM gcr.io/distroless/base:latest AS release
USER nobody
COPY --from=build --chown=root:root /app/echo-server /app/echo-server
ENTRYPOINT ["/app/echo-server"]

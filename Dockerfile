FROM alpine:latest AS build

COPY . /usr/src
WORKDIR /usr/src
RUN apk add gcc make pkgconfig musl-dev
RUN make static

FROM scratch AS final
COPY --from=build /usr/src/udptunnel /
ENTRYPOINT [ "/udptunnel" ]

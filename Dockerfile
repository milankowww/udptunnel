FROM gcc:latest AS build

COPY . /usr/src
WORKDIR /usr/src
RUN make static

FROM scratch AS final
COPY --from=build /usr/src/udptunnel /
ENTRYPOINT [ "/udptunnel" ]

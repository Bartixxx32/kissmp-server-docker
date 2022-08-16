FROM rust:alpine

ARG COMMIT=07ac644d3b89ecce61718180c36d4db896d0be39

ENV PATH=/root/.cargo/bin:$PATH

WORKDIR /build
RUN apk update
RUN apk add git curl alpine-sdk binutils
RUN git clone https://github.com/TheHellBox/KISS-multiplayer.git
WORKDIR KISS-multiplayer
RUN git checkout $COMMIT
WORKDIR /build/KISS-multiplayer/kissmp-server/
RUN cargo build -j $(( $(nproc) + 1 )) --release

FROM alpine:3.11
COPY --from=0 /build/KISS-multiplayer/target/release/kissmp-server /server/kissmp-server
WORKDIR /server
RUN mkdir mods
RUN mkdir addons
RUN chmod +x kissmp-server

FROM scratch
COPY --from=1 /server /server
WORKDIR /server
ENTRYPOINT ["./kissmp-server"]

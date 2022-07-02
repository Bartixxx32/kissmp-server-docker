FROM rust:alpine

ARG COMMIT=aab6eda6310c671a6f1001a8b4092530cc129e39

ENV PATH=/root/.cargo/bin:$PATH

WORKDIR /build
RUN apk update
RUN apk add git curl alpine-sdk binutils
RUN git clone https://github.com/TheHellBox/KISS-multiplayer.git
WORKDIR KISS-multiplayer
RUN git checkout $COMMIT
WORKDIR /build/KISS-multiplayer/kissmp-server/
RUN cargo build -j $(( $(nproc) + 1 )) --release
RUN strip /build/KISS-multiplayer/target/release/kissmp-server

FROM alpine:3.11
RUN apk add upx
COPY --from=0 /build/KISS-multiplayer/target/release/kissmp-server /server/kissmp-server
RUN upx --best --lzma /server/kissmp-server
WORKDIR /server
RUN mkdir mods
RUN mkdir addons
RUN chmod +x kissmp-server

FROM scratch
COPY --from=1 /server /server
WORKDIR /server
ENTRYPOINT ["./kissmp-server"]

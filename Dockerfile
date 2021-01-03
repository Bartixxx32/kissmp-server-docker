FROM alpine:3.11

ARG COMMIT=ec2371755c6bb866d968dee7d57ac612a6243a20

ENV PATH=/root/.cargo/bin:$PATH

WORKDIR /build
RUN apk update
RUN apk add git curl alpine-sdk binutils upx
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN git clone https://github.com/TheHellBox/KISS-multiplayer.git
WORKDIR KISS-multiplayer
RUN git checkout $COMMIT
WORKDIR /build/KISS-multiplayer/kissmp-server/
RUN cargo build -j $(( $(nproc) + 1 )) --release
RUN strip /build/KISS-multiplayer/target/release/kissmp-server
RUN upx --best --lzma /build/KISS-multiplayer/target/release/kissmp-server

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

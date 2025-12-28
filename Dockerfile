FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    tor \
    git \
    build-essential \
    libsodium-dev \
    autoconf \
    && rm -rf /var/lib/apt/lists/*

# Build mkp224o from source
RUN git clone https://github.com/cathugger/mkp224o.git /tmp/mkp224o && \
    cd /tmp/mkp224o && \
    ./autogen.sh && \
    ./configure && \
    make && \
    cp mkp224o /usr/local/bin/ && \
    rm -rf /tmp/mkp224o

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

FROM debian:bullseye

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y build-essential git libtool-bin autotools-dev \
                       pkg-config texinfo zlib1g-dev libcurl4-openssl-dev \
                       libsubunit-dev check libmicrohttpd-dev

WORKDIR /app

RUN git clone --recursive https://github.com/ozars/pcg-c \
 && cd pcg-c \
 && make \
 && make test \
 && make install \
 && ldconfig \
 && cd .. \
 && rm -rf pcg-c

RUN git clone --recursive https://github.com/ozars/libstreamlike \
 && cd libstreamlike \
 && sed -i 's/^inline/static inline/' -i 'tests/util/util.h' \
 && autoreconf -vfi \
 && ./configure --enable-tests --enable-http \
 && make \
 && make check \
 && make install \
 && ldconfig \
 && cd .. \
 && rm -rf libstreamlike

RUN git clone --recursive https://github.com/ozars/libzidx \
 && cd libzidx \
 && autoreconf -vfi \
 && ./configure --enable-tests --enable-http --disable-debug \
 && make \
 && make check \
 && make install \
 && ldconfig

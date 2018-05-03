FROM alpine
LABEL maintainer="24371969+WUUUGI@users.noreply.github.com"

# Versions
ENV LIBCONV_VERSION 1.15

# Working directory
WORKDIR /install

RUN apk add make tar git && \
    
    # CMake
    apk add cmake cmake-doc extra-cmake-modules extra-cmake-modules-doc && \
    
    # wget
    apk add wget && \
    
    # Doxygen Dependencies
    apk add flex bison strip && \
    
    # libiconv: https://www.gnu.org/software/libiconv/
    wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.15.tar.gz && tar -xvzf libiconv-1.15.tar.gz && cd libiconv-1.15 && \
    ./configure --prefix=/usr/local && \
    make && make install && \
    
    # Doxygen
    git clone https://github.com/doxygen/doxygen.git && \
    cd doxygen && \
    mkdir build && cd build && \
    cmake -G "Unix Makefiles" .. && \
    make && make install && \

    
    # TODO: Remove folder and tar.gz
    rm -rf /var/cache/apk/* && \
    rm -rf /install  \
    
    WORKDIR /

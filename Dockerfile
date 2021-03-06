FROM alpine
LABEL maintainer="24371969+WUUUGI@users.noreply.github.com"

# Versions
ENV LIBCONV_VERSION 1.15
ENV GHOSTSCRIPT_VERSION 9.23
ENV PKG_CONFIG_VERSION 0.29.2

# Working directory
WORKDIR /install

# enable edge repos
RUN sed -i -e 's/v3\.4/edge/g' /etc/apk/repositories
# enable testing
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories

RUN apk update

# https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management troubleshooting: apk tools is old
RUN apk add --upgrade apk-tools

# make, tar, git
RUN apk add make tar git wget
    
# CMake
RUN apk add cmake cmake-doc extra-cmake-modules extra-cmake-modules-doc

# GCC
RUN apk add build-base gcc abuild binutils binutils-doc gcc-doc
    
# Doxygen Dependencies
RUN apk add flex bison	
    
# libiconv: https://www.gnu.org/software/libiconv/
RUN wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-$LIBCONV_VERSION.tar.gz && tar -zxvf  libiconv-$LIBCONV_VERSION.tar.gz && cd libiconv-$LIBCONV_VERSION && \
    ./configure --prefix=/usr/local && \
    make && make install
    
# GhostScript (https://ghostscript.com)
RUN apk add ghostscript ghostscript-fonts
    
# PKG-Config (https://www.freedesktop.org/wiki/Software/pkg-config/)
RUN wget https://pkg-config.freedesktop.org/releases/pkg-config-0.29.2.tar.gz && tar -zxvf  pkg-config-0.29.2.tar.gz && cd pkg-config-0.29.2 && \
    	./configure --prefix=/usr/local --with-internal-glib --enable-iconv=no --with-libiconv=gnu && \
    	make && make install
    
# GraphViz dependencies (https://graphviz.gitlab.io/_pages/Download/Download_source.html)
RUN apk add cairo expat freetype fontconfig glib zlib libpng
    
# GraphViz tools 
RUN apk add libtool swig autoconf
    
# GraphViz (https://graphviz.gitlab.io/)
RUN git clone https://gitlab.com/graphviz/graphviz.git && \
    cd graphviz && \
    ./autogen.sh && \
    ./configure && \
    make && make install
    
# TeXlive
RUN apk add texlive-full
    
# Doxygen
RUN git clone https://github.com/doxygen/doxygen.git && \
    cd doxygen && \
    mkdir build && cd build && \
    cmake -G "Unix Makefiles" .. && \
    make && make install

# TODO: Remove folder and tar.gz
RUN rm -rf /var/cache/apk/* && \
    rm -rf /install
    
WORKDIR /doxy
VOLUME ["/doxy"]

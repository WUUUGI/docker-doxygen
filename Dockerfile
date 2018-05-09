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
RUN wget https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs923/ghostscript-$GHOSTSCRIPT_VERSION.tar.gz && tar -zxvf  ghostscript-$GHOSTSCRIPT_VERSION.tar.gz && cd ghostscript-$GHOSTSCRIPT_VERSION && \
    ./configure && \
    make && make install
    # TODO Validate checksums (SHA1) https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs923/SHA1SUMS
    # (MD5) https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs923/SHA1SUMS
    
# PKG-Config (https://www.freedesktop.org/wiki/Software/pkg-config/)
RUN wget https://pkg-config.freedesktop.org/releases/pkg-config-0.29.2.tar.gz && tar -zxvf  pkg-config-0.29.2.tar.gz && cd pkg-config-0.29.2 && \
    ./configure --prefix=/usr && \
    make && make install
    
# GraphViz dependencies (https://graphviz.gitlab.io/_pages/Download/Download_source.html)
RUN apk add cairo expat freetype fontconfig glib zlib libpng lib
    
# GraphViz tools 
RUN apk add libtool swig
    
# GraphViz (https://graphviz.gitlab.io/)
RUN git clone https://gitlab.com/graphviz/graphviz/ && \
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

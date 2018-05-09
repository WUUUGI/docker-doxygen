FROM alpine
LABEL maintainer="24371969+WUUUGI@users.noreply.github.com"

# Versions
ENV LIBCONV_VERSION 1.15
ENV GHOSTSCRIPT_VERSION 9.23
ENV PKG_CONFIG_VERSION 0.29.2

# Working directory
WORKDIR /install

RUN apk update

RUN apk add make tar git
    
# CMake
RUN apk add cmake cmake-doc extra-cmake-modules extra-cmake-modules-doc
    
# wget
RUN apk add wget
    
# Doxygen Dependencies
RUN apk add flex bison strip
    
# libiconv: https://www.gnu.org/software/libiconv/
RUN wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-$LIBCONV_VERSION.tar.gz && tar -xvzf libiconv-$LIBCONV_VERSION.tar.gz && cd libiconv-$LIBCONV_VERSION && \
    ./configure --prefix=/usr/local && \
    make && make install
    
# GhostScript (https://ghostscript.com)
RUN wget https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs923/ghostscript-9.23-linux-x86_64.tgz && tar -xvfz ghostscript-9.23-linux-x86_64.tgz && cd ghostscript-9.23-linux-x86_64 && \
    ./configure && \
    make && make install && \
    # TODO Validate checksums (SHA1) https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs923/SHA1SUMS
    # (MD5) https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs923/SHA1SUMS
    
# PKG-Config (https://www.freedesktop.org/wiki/Software/pkg-config/)
RUN wget https://pkg-config.freedesktop.org/releases/pkg-config-0.29.2.tar.gz && tar -xvfz pkg-config-0.29.2.tar.gz && cd pkg-config-0.29.2 && \
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
    rm -rf /install  && \
    
WORKDIR /doxy
VOLUME ["/doxy"]

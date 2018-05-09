FROM alpine
LABEL maintainer="24371969+WUUUGI@users.noreply.github.com"

# Versions
ENV LIBCONV_VERSION 1.15
ENV GHOSTSCRIPT_VERSION 9.23
ENV PKG_CONFIG_VERSION 0.29.2

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
    
    # GhostScript (https://ghostscript.com)
    wget https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs923/ghostscript-9.23-linux-x86_64.tgz && tar -xvfz ghostscript-9.23-linux-x86_64.tgz && cd ghostscript-9.23-linux-x86_64 && \
    ./configure && \
    make && make install && \
    # TODO Validate checksums (SHA1) https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs923/SHA1SUMS
    # (MD5) https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs923/SHA1SUMS
    
    # PKG-Config (https://www.freedesktop.org/wiki/Software/pkg-config/)
    wget https://pkg-config.freedesktop.org/releases/pkg-config-0.29.2.tar.gz && tar -xvfz pkg-config-0.29.2.tar.gz && cd pkg-config-0.29.2 && \
    ./configure --prefix=/usr && \
    make && make install && \
    
    # GraphViz dependencies (https://graphviz.gitlab.io/_pages/Download/Download_source.html)
    apk add cairo expat freetype fontconfig glib zlib libpng lib && \
    
    # GraphViz tools 
    apk add libtool swig && \
    
    # GraphViz (https://graphviz.gitlab.io/)
    git clone https://gitlab.com/graphviz/graphviz/ && \
    cd graphviz && \
    ./autogen.sh && \
	./configure && \
	make && make install && \
    
    # TeXlive
    apk add texlive-full && \
    
    # Doxygen
    git clone https://github.com/doxygen/doxygen.git && \
    cd doxygen && \
    mkdir build && cd build && \
    cmake -G "Unix Makefiles" .. && \
    make && make install && \

    # TODO: Remove folder and tar.gz
    rm -rf /var/cache/apk/* && \
    rm -rf /install  && \
    
    WORKDIR /doxy
    VOLUME ["/doxy"]

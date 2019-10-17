project(sffmpeg)

cmake_minimum_required(VERSION 2.8)
include(ExternalProject)
include_directories(BEFORE ${CMAKE_BINARY_DIR}/include)
link_directories(${CMAKE_BINARY_DIR}/lib)
set(ENV{PATH} ${CMAKE_BINARY_DIR}/bin:$ENV{PATH})
set(ENV{PKG_CONFIG_PATH} ${CMAKE_BINARY_DIR}/lib/pkgconfig)

set(GLOBAL_CMAKE_FLAGS
  "-DCMAKE_PREFIX_PATH:PATH=${CMAKE_BINARY_DIR}"
  "-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_BINARY_DIR}"
  "-DENABLE_SHARED:BOOL=OFF"
)

externalproject_add(
  nasm
  URL https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.gz
  PATCH_COMMAND ${PROJECT_SOURCE_DIR}/patches/patch-manager.sh nasm
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR}
  BUILD_IN_SOURCE TRUE
  DOWNLOAD_NO_PROGRESS TRUE
)

externalproject_add(
  zlib
  URL https://github.com/madler/zlib/archive/v1.2.11.tar.gz
  PATCH_COMMAND ${PROJECT_SOURCE_DIR}/patches/patch-manager.sh zlib
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR} --static
  BUILD_IN_SOURCE TRUE
  DOWNLOAD_NO_PROGRESS TRUE
)

externalproject_add(
  opencore-amr
  URL http://downloads.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.5.tar.gz
  PATCH_COMMAND ${PROJECT_SOURCE_DIR}/patches/patch-manager.sh opencore-amr
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared
  BUILD_IN_SOURCE TRUE
  DOWNLOAD_NO_PROGRESS TRUE
)

externalproject_add(
  fdkaac
  URL http://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-2.0.1.tar.gz
  PATCH_COMMAND ${PROJECT_SOURCE_DIR}/patches/patch-manager.sh fdkaac
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared --enable-static
  BUILD_IN_SOURCE TRUE
  DOWNLOAD_NO_PROGRESS TRUE
)

externalproject_add(
  lame
  URL http://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
  PATCH_COMMAND ${PROJECT_SOURCE_DIR}/patches/patch-manager.sh lame
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared
  BUILD_IN_SOURCE TRUE
  DOWNLOAD_NO_PROGRESS TRUE
)

externalproject_add(
  libogg
  URL https://github.com/xiph/ogg/archive/c8fca6b.tar.gz
  PATCH_COMMAND ${PROJECT_SOURCE_DIR}/patches/patch-manager.sh libogg
  CMAKE_CACHE_ARGS
      ${GLOBAL_CMAKE_FLAGS}
  BUILD_IN_SOURCE TRUE
  DOWNLOAD_NO_PROGRESS TRUE
)

externalproject_add(
  speex
  DEPENDS libogg
  URL http://downloads.xiph.org/releases/speex/speex-1.2.0.tar.gz
  URL_HASH SHA256=eaae8af0ac742dc7d542c9439ac72f1f385ce838392dc849cae4536af9210094
  PATCH_COMMAND ${PROJECT_SOURCE_DIR}/patches/patch-manager.sh speex
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared --enable-sse  --disable-oggtest --with-ogg=${CMAKE_BINARY_DIR}
  BUILD_IN_SOURCE TRUE
  DOWNLOAD_NO_PROGRESS TRUE
)

externalproject_add(
  libvorbis
  DEPENDS libogg
  URL http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.6.tar.gz
  URL_HASH SHA256=6ed40e0241089a42c48604dc00e362beee00036af2d8b3f46338031c9e0351cb
  PATCH_COMMAND ${PROJECT_SOURCE_DIR}/patches/patch-manager.sh libvorbis
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared --disable-oggtest
  BUILD_IN_SOURCE TRUE
  DOWNLOAD_NO_PROGRESS TRUE
)

externalproject_add(
  libtheora
  DEPENDS libogg libvorbis
  URL http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz
  PATCH_COMMAND ${PROJECT_SOURCE_DIR}/patches/patch-manager.sh libtheora
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared --disable-oggtest --disable-vorbistest --disable-examples --with-ogg=${CMAKE_BINARY_DIR}
  BUILD_IN_SOURCE TRUE
  DOWNLOAD_NO_PROGRESS TRUE
)

externalproject_add(
  opus
  URL https://archive.mozilla.org/pub/opus/opus-1.3.1.tar.gz
  PATCH_COMMAND ${PROJECT_SOURCE_DIR}/patches/patch-manager.sh opus
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared --disable-doc
  BUILD_IN_SOURCE TRUE
  DOWNLOAD_NO_PROGRESS TRUE
)

externalproject_add(
  xvidcore
  DEPENDS nasm
  URL https://downloads.xvid.com/downloads/xvidcore-1.3.5.tar.gz
  PATCH_COMMAND ${PROJECT_SOURCE_DIR}/patches/patch-manager.sh xvidcore
  CONFIGURE_COMMAND cd build/generic && PATH=$ENV{PATH} ./configure --prefix=${CMAKE_BINARY_DIR}
  BUILD_COMMAND cd build/generic && PATH=$ENV{PATH} make
  INSTALL_COMMAND cd build/generic && make install
  BUILD_IN_SOURCE TRUE
  DOWNLOAD_NO_PROGRESS TRUE
)

externalproject_add(
  x264
  DEPENDS nasm
  URL https://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20191015-2245-stable.tar.bz2
  PATCH_COMMAND ${PROJECT_SOURCE_DIR}/patches/patch-manager.sh x264
  CONFIGURE_COMMAND PATH=$ENV{PATH} ./configure --prefix=${CMAKE_BINARY_DIR} --enable-static
  BUILD_COMMAND PATH=$ENV{PATH} make
  BUILD_IN_SOURCE TRUE
  DOWNLOAD_NO_PROGRESS TRUE
)

externalproject_add(
  x265
  DEPENDS nasm
  URL https://bitbucket.org/multicoreware/x265/downloads/x265_3.2.tar.gz
  PATCH_COMMAND ${PROJECT_SOURCE_DIR}/patches/patch-manager.sh x265
  SOURCE_SUBDIR source
  CMAKE_CACHE_ARGS
      ${GLOBAL_CMAKE_FLAGS}
      -DENABLE_CLI:BOOL=OFF
)

externalproject_add(
  libvpx
  DEPENDS nasm
  URL https://github.com/webmproject/libvpx/archive/v1.8.1.tar.gz
  PATCH_COMMAND ${PROJECT_SOURCE_DIR}/patches/patch-manager.sh libvpx
  CONFIGURE_COMMAND PATH=$ENV{PATH} ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared
  BUILD_COMMAND PATH=$ENV{PATH} make
  BUILD_IN_SOURCE TRUE
  DOWNLOAD_NO_PROGRESS TRUE
)

externalproject_add(
  freetype
  URL https://download.savannah.gnu.org/releases/freetype/freetype-2.10.1.tar.gz
  PATCH_COMMAND ${PROJECT_SOURCE_DIR}/patches/patch-manager.sh freetype
  CONFIGURE_COMMAND ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared --enable-static --without-png
  INSTALL_COMMAND make install && ln -s ${CMAKE_BINARY_DIR}/include/freetype2 ${CMAKE_BINARY_DIR}/include/freetype2/freetype
  BUILD_IN_SOURCE TRUE
  DOWNLOAD_NO_PROGRESS TRUE
)

externalproject_add(
  fribidi
  URL https://github.com/fribidi/fribidi/archive/v1.0.7.tar.gz
  PATCH_COMMAND ${PROJECT_SOURCE_DIR}/patches/patch-manager.sh fribidi
  CONFIGURE_COMMAND ./autogen.sh && ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared --enable-static
  BUILD_IN_SOURCE TRUE
  DOWNLOAD_NO_PROGRESS TRUE
)

externalproject_add(
  expat
  URL https://github.com/libexpat/libexpat/releases/download/R_2_2_9/expat-2.2.9.tar.gz
  PATCH_COMMAND ${PROJECT_SOURCE_DIR}/patches/patch-manager.sh expat
  CMAKE_CACHE_ARGS
      ${GLOBAL_CMAKE_FLAGS}
  DOWNLOAD_NO_PROGRESS TRUE
)

externalproject_add(
  fontconfig
  DEPENDS freetype expat
  URL https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.92.tar.gz
  PATCH_COMMAND ${PROJECT_SOURCE_DIR}/patches/patch-manager.sh fontconfig
  CONFIGURE_COMMAND PKG_CONFIG_PATH=$ENV{PKG_CONFIG_PATH} ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared --enable-static
  BUILD_IN_SOURCE TRUE
  DOWNLOAD_NO_PROGRESS TRUE
)

externalproject_add(
  libass
  DEPENDS nasm freetype fribidi fontconfig
  URL https://github.com/libass/libass/releases/download/0.14.0/libass-0.14.0.tar.gz
  PATCH_COMMAND ${PROJECT_SOURCE_DIR}/patches/patch-manager.sh libass
  CONFIGURE_COMMAND PATH=$ENV{PATH} PKG_CONFIG_PATH=$ENV{PKG_CONFIG_PATH} ./configure --prefix=${CMAKE_BINARY_DIR} --disable-shared --enable-static
  BUILD_COMMAND PATH=$ENV{PATH} make
  BUILD_IN_SOURCE TRUE
  DOWNLOAD_NO_PROGRESS TRUE
)

set(FFMPEG_EXTRA_CFLAGS -I${CMAKE_BINARY_DIR}/include -fno-stack-check)
externalproject_add(
  ffmpeg
  DEPENDS nasm opencore-amr fdkaac lame libogg speex libvorbis libtheora opus xvidcore x264 x265 libvpx freetype libass
  URL https://github.com/FFmpeg/FFmpeg/archive/n4.2.1.tar.gz
  PATCH_COMMAND ${PROJECT_SOURCE_DIR}/patches/patch-manager.sh ffmpeg
  LIST_SEPARATOR ' '
  CONFIGURE_COMMAND
      PATH=$ENV{PATH}
      PKG_CONFIG_PATH=$ENV{PKG_CONFIG_PATH}
      ./configure --prefix=${CMAKE_BINARY_DIR} --datadir=${CMAKE_BINARY_DIR}/etc --disable-shared --enable-static --enable-gpl --enable-version3 --enable-nonfree --disable-doc --disable-debug --disable-ffplay --disable-outdevs --enable-runtime-cpudetect --pkg-config-flags=--static --extra-cflags=-I${CMAKE_BINARY_DIR}/include\ -fno-stack-check --extra-ldflags=-L${CMAKE_BINARY_DIR}/lib --extra-libs=-lstdc++\ -lexpat\ -ldl --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libfdk-aac --enable-libmp3lame --enable-libspeex --enable-libtheora --enable-libvorbis --enable-libx264 --enable-libx265 --enable-libxvid --enable-libvpx --enable-libopus --enable-libfreetype --enable-libass --enable-pthreads --enable-postproc
  BUILD_COMMAND PATH=$ENV{PATH} make
  BUILD_IN_SOURCE TRUE
  DOWNLOAD_NO_PROGRESS TRUE
)

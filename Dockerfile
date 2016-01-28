# Debian base because .debs
FROM debian:8 

# Packages needed for build environment
RUN apt-get update && apt-get -y install \
	build-essential \
	libsdl2-dev \
	libsdl2-image-dev \
	libsdl2-ttf-dev \
	ruby \
	ruby-dev \
	&& apt-get clean \
        && rm -rf /var/lib/apt/lists/*

# fpm, because I've been too lazy to work out how to make real debs thus far
RUN gem install fpm

# let's set up a working DIR for the software
RUN mkdir /cata
WORKDIR /cata

# and now let's get the software

# build and package the software
WORKDIR Cataclysm-DDA
cmd ["/bin/bash","-l","-c","make install TILES=1 RELEASE=1 PREFIX=/opt/Cataclysm-DDA && fpm -s dir -t deb -n cataclysm-dda -v $(date +%d%m%Y) -C / -p cataclysmdda-$(date +%d%m%Y).deb -d libsdl2-2.0-0 -d libsdl2-ttf-2.0-0 -d libsdl2-image-2.0-0 opt/Cataclysm-DDA"]

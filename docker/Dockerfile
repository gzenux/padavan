FROM ubuntu:16.04
LABEL maintainer="YiJun Chen <gzenux@gmail.com>"


# Update repository and install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	automake \
	autopoint \
	bison \
	build-essential \
	flex \
	gawk \
	gettext \
	libgmp3-dev \
	libltdl-dev \
	libmpc-dev \
	libmpfr-dev \
	libncurses5-dev \
	libtool \
	locales \
	module-init-tools \
	pkg-config \
	sudo \
	texinfo \
	zlib1g-dev


#
# Configure the system
#
# Generate locale
ARG LANG=en_US.UTF-8
ARG LANGUAGES=zh_TW.UTF-8
RUN locale-gen ${LANGUAGES} ${LANG}
ENV LANG=${LANG} LANGUAGE=${LANG} LC_ALL=${LANG}

# Use bash as default shell
RUN echo "dash dash/sh boolean false" | debconf-set-selections && dpkg-reconfigure -f noninteractive dash

# Clean up the resources
RUN rm -rf /var/lib/apt/lists/*


COPY src/docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bash"]

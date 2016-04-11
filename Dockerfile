#
# Redis Dockerfile
# Based on debian:wheezy: Image size at 185MB instead of 473MB on ubuntu:14.04
#
# https://github.com/dockerfile/redis
#

# Pull base image.
FROM google/debian:wheezy

# Install Redis.
RUN apt-get update && apt-get -y install less curl net-tools build-essential && \
  cd /tmp && \
  curl -O http://download.redis.io/redis-stable.tar.gz && \
  tar xvzf redis-stable.tar.gz && \
  cd redis-stable && \
  make && \
  make install && \
  cp -f src/redis-sentinel /usr/local/bin && \
  mkdir -p /etc/redis && \
  cp -f *.conf /etc/redis && \
  rm -rf /tmp/redis-stable* && \
  sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/redis/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis/redis.conf && \
  apt-get remove -y --purge binutils build-essential bzip2 cpp cpp-4.7 dpkg-dev\
  fakeroot g++ g++-4.7 gcc gcc-4.7 ifupdown less\
  libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl\
  libc-dev-bin libc6-dev libclass-isa-perl libdpkg-perl\
  libfile-fcntllock-perl libgdbm3 libgmp10 libgomp1\
  libitm1 libmpc2 libmpfr4 libquadmath0\
  libstdc++6-4.7-dev libswitch-perl libtimedate-perl linux-libc-dev\
  make manpages manpages-dev netbase patch perl perl-modules &&\
  apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["redis-server", "/etc/redis/redis.conf"]

# Expose ports.
EXPOSE 6379

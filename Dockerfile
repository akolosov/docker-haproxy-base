FROM akolosov/ubuntu

# Install dependencies
RUN apt-get update
RUN apt-get upgrade -yqq
RUN apt-get -yqq install make gcc tar
RUN apt-get -yqq clean
RUN rm -rf /var/lib/apt/lists/*

ENV HAPROXY_MAJOR 1.6
ENV HAPROXY_VERSION 1.6.0

# Install HAProxy
RUN \
  cd /tmp && \
  curl -SL "http://www.haproxy.org/download/${HAPROXY_MAJOR}/src/haproxy-${HAPROXY_VERSION}.tar.gz" -o haproxy.tar.gz && \
  tar xvzf haproxy.tar.gz && \
  cd haproxy-${HAPROXY_VERSION} && \
  make TARGET=generic && \
  make install-bin && \
  mkdir -p /etc/haproxy && \
  mkdir -p /etc/haproxy/configs && \
  rm -rf /tmp/haproxy*

ADD haproxy_default.cfg /etc/haproxy/haproxy.cfg

# Define entrypoint
CMD ["haproxy", "-f", "/etc/haproxy/haproxy.cfg"]


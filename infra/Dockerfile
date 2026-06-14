FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    python3 \
    python3-pip \
    vim \
    iputils-ping \
    net-tools && \
    rm -rf /var/lib/apt/lists/*
RUN useradd -m -s /bin/bash redis
RUN echo "redis ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN mkdir /var/run/sshd
RUN mkdir -p /home/redis/.ssh
COPY redis_cluster_key.pub /home/redis/.ssh/authorized_keys
RUN chmod 700 /home/redis/.ssh && \
    chmod 600 /home/redis/.ssh/authorized_keys && \
    chown -R redis:redis /home/redis/.ssh
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

FROM ubuntu:24.04 AS builder

# Install necessary packages for building Ruby
RUN apt update && \
    apt install -y  \
    curl \
    git \
    autoconf \
    patch \
    build-essential \
    rustc \
    libssl-dev \
    libyaml-dev \
    libreadline6-dev \
    zlib1g-dev \
    libgmp-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm6 \
    libgdbm-dev \
    libdb-dev \
    uuid-dev && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables for rbenv and Ruby version    
ENV RBENV_ROOT=/opt/rbenv
ENV RUBY_VERSION=3.1.6

# Install rbenv and ruby-build, and build the specified Ruby version
RUN git clone https://github.com/rbenv/rbenv.git ${RBENV_ROOT} && \
    git clone https://github.com/rbenv/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build && \
    ${RBENV_ROOT}/bin/rbenv install ${RUBY_VERSION} && \
    ${RBENV_ROOT}/bin/rbenv global ${RUBY_VERSION}

FROM ubuntu:24.04 AS final

# Install packages for gems and install Ansible
RUN apt update && \
    apt install -y \
    make \
    gcc \
    vim \
    curl \
    git \
    software-properties-common && \
    apt-add-repository --yes --update ppa:ansible/ansible && \
    apt install -y ansible && \
    rm -rf /var/lib/apt/lists/*

# Copy rbenv and the built Ruby version from the builder stage
COPY --from=builder /opt/rbenv /opt/rbenv

ENV RBENV_ROOT=/opt/rbenv
ENV PATH=${RBENV_ROOT}/bin:${RBENV_ROOT}/shims:$PATH

COPY ./ansible /etc/ansible

WORKDIR /etc/ansible

# Install necessary Ruby gems
RUN bundle install

# Script for deploying ssh key to the target host
COPY deploy_ssh_keys.sh /root/deploy_ssh_keys.sh
RUN chmod +x /root/deploy_ssh_keys.sh

CMD ["/root/deploy_ssh_keys.sh"]
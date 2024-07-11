FROM ubuntu:24.04

# Install Ansible
RUN apt update && \
    apt install -y software-properties-common && \
    apt-add-repository --yes --update ppa:ansible/ansible && \
    apt install -y ansible

# Install necessary packages for building ruby
RUN apt install -y \
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
    uuid-dev

ENV RBENV_ROOT=/opt/rbenv
ENV PATH=${RBENV_ROOT}/bin:${RBENV_ROOT}/shims:$PATH
ENV RUBY_VERSION=3.1.6

# Install utilities
RUN apt install -y \
    curl \
    vim \
    git

# Install rbenv and ruby-build
RUN git clone https://github.com/rbenv/rbenv.git ${RBENV_ROOT} && \
    git clone https://github.com/rbenv/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build && \
    ${RBENV_ROOT}/plugins/ruby-build/install.sh && \
    echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh

# Install ruby
RUN rbenv install ${RUBY_VERSION} && \
    rbenv global ${RUBY_VERSION}
    
WORKDIR /etc/ansible

COPY ./ansible /etc/ansible

RUN bundle install

FROM ubuntu:trusty

# Inject bash for a nicer shell integration
RUN rm /bin/sh && cp /bin/bash /bin/sh

# Install apt-getable dependancies
RUN apt-get update
RUN apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    git

# Install ruby version manager and stable ruby version
RUN gpg --keyserver hkp://keys.gnupg.net \
    --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable --ruby
RUN echo "source /etc/profile.d/rvm.sh" >> /root/.bashrc

# Install Open-Publisher dependancies
# Jekyll
RUN gem install --no-document jekyll

# Remove build dependancies
RUN apk del \
    build-base \
    libffi-dev \
    ruby-dev

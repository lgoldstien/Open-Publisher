FROM ubuntu:trusty

# Install dependancies
RUN apt-get update
RUN apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    git \
    libffi-dev

# Install jekyll
RUN gem install --no-document jekyll

# Remove build dependancies
RUN apk del \
    build-base \
    libffi-dev \
    ruby-dev

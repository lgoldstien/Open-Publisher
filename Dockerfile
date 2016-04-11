FROM alpine:3.3

# Install jekyll dependancies
RUN apk --update add \
    build-base \
    ca-certificates \
    git \
    libffi-dev \
    ruby \
    ruby-bundler \
    ruby-dev

# Install jekyll
RUN gem install --no-document jekyll

# Remove build dependancies
RUN apk del \
    build-base \
    libffi-dev \
    ruby-dev

FROM phusion/passenger-ruby25

EXPOSE 80

ENV BUNDLER_VERSION=1.13.7
ENV RAILS_ENV=production
ENV BUNDLE_PATH=/app/stockor/bundle
ENV BUNDLE_WITHOUT=development:test

RUN apt-get update && \
        apt-get install -y curl git libpq-dev gcc make vim && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists

RUN gem install bundler -v ${BUNDLER_VERSION}
RUN mkdir -p /app/stockor
WORKDIR /app/stockor

RUN bundle config --global silence_root_warning 1
COPY Gemfile Gemfile.lock stockor.gemspec ./
RUN bundle install

COPY . .

RUN cp ./config/passenger.conf /etc/nginx/sites-enabled/default && rm -f /etc/service/nginx/down

CMD ["/sbin/my_init"]

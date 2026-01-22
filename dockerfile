FROM ruby:3.1.3-bullseye

# 必要パッケージ（mysql2 / node / yarn / build）
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential \
  git curl ca-certificates \
  default-libmysqlclient-dev \
  default-mysql-client \
  && rm -rf /var/lib/apt/lists/*

# Node.js 16 + Yarn（webpack4/webpacker世代と相性が良い）
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
  && apt-get update -qq && apt-get install -y --no-install-recommends nodejs \
  && npm i -g yarn \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# JS deps
COPY package.json yarn.lock ./
RUN yarn install

# App
COPY . .

# ★本番アセットをビルドしてイメージに含める
ENV RAILS_ENV=production NODE_ENV=production
# assets:precompile に SECRET_KEY_BASE が要るのでダミーでOK（本番起動時はSSMの本物が使われる）
ARG SECRET_KEY_BASE=dummy
ENV SECRET_KEY_BASE=$SECRET_KEY_BASE

RUN bundle exec rails assets:precompile
# 念のため（環境によっては assets:precompile が webpacker compile を呼ばないことがある）
RUN bundle exec rails webpacker:compile
# entrypoint
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

EXPOSE 3000
ENTRYPOINT ["entrypoint.sh"]
CMD ["bin/rails", "server", "-b", "0.0.0.0"]

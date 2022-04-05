source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'bcrypt', '3.1.11'
gem 'bootsnap', '1.4.5', require: false
gem 'bootstrap-sass', '3.3.7'
gem 'bootstrap-will_paginate', '1.0.0'
gem 'jbuilder',   '2.9.1'
gem 'puma', '4.3.6'
gem 'rails', '6.0.3'
gem 'sass-rails', '5.1.0'
gem 'turbolinks', '5.2.0'
gem 'webpacker',  '4.0.7'
gem 'will_paginate', '3.3.1'

group :development, :test do
  gem 'byebug', '11.0.1', platforms: %i[mri mingw x64_mingw]
  gem 'faker'
  gem 'sqlite3', '1.4.1'
  # チュートリアルに無し
  gem 'pry-byebug'
  gem 'rubocop', '~> 0.83', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false # Rails プロジェクトのみ
  gem 'rubocop-rspec', require: false # テストに RSpec を利用するプロジェクトのみ
  gem 'solargraph', require: false
  gem 'spring-commands-rspec'
end

group :development do
  gem 'listen',                '3.1.5'
  gem 'spring',                '2.1.0'
  gem 'spring-watcher-listen', '2.0.1'
  gem 'web-console',           '4.0.1'
end

group :test do
  gem 'capybara',                 '3.28.0'
  gem 'guard',                    '2.16.2'
  gem 'minitest',                 '5.11.3'
  gem 'minitest-reporters',       '1.3.8'
  gem 'rails-controller-testing', '1.0.4'
  gem 'selenium-webdriver',       '3.142.4'
  gem 'webdrivers',               '4.1.2'
  # チュートリアルに無し
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'guard-rspec', require: false
  gem 'launchy'
  gem 'rspec-rails'
end

group :production do
  gem 'pg', '1.1.4'
end

# Windows ではタイムゾーン情報用の tzinfo-data gem を含める必要があります
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

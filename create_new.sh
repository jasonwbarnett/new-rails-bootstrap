#!/bin/bash

app_name="$1"

rails new ${app_name}
cd ${app_name}

cat >> Gemfile <<EOF
gem "therubyracer"
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem "twitter-bootstrap-rails", git: "https://github.com/seyhunak/twitter-bootstrap-rails.git", branch: "bootstrap3"

gem 'simple_form'
EOF

bundle
rails generate bootstrap:install less
rails g bootstrap:layout application fixed --force
rails generate simple_form:install --bootstrap

## Add a static pages controller and set as root
rails g controller StaticPage home
sed -i "2i root 'static_page#home'" config/routes.rb

## Remove non-existen favicon from app layout:
favicon_line_no=$(egrep -n 'favicon.ico' app/views/layouts/application.html.erb | awk -F: '{print $1}')
sed -i "${favicon_line_no}d" app/views/layouts/application.html.erb

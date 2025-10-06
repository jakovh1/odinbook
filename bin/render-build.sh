#!/usr/bin/env bash

# Exit on error
set -o errexit

bundle install
corepack enable
corepack prepare yarn@4.10.3 --activate
yarn install --immutable

bin/rails assets:precompile
bin/rails assets:clean

# If you have a paid instance type, we recommend moving
# database migrations like this one from the build command
# to the pre-deploy command:
bin/rails db:prepare
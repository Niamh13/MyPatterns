#!/bin/bash
set -e

# Run database migrations and seeds
bundle exec rails db:migrate
bundle exec rails db:seed

# Execute the container CMD
exec "$@"

#!/bin/bash
set -e

# Run migrations
bundle exec rails db:migrate

# Run the command passed to the container
exec "$@"

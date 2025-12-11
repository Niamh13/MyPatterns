#!/bin/bash
set -e

# Run database migrations and seeds
bundle exec rails db:migrate

# Execute the container CMD
echo "start server"
exec "$@"

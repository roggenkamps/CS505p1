#!/bin/bash

export DISABLE_DATABASE_ENVIRONMENT_CHECK=1
export RAILS_ENV=production

rake db:reset

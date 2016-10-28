# Actuary Canary

[![CircleCI](https://circleci.com/gh/MaxWofford/actuary-canary.svg?style=svg)](https://circleci.com/gh/MaxWofford/actuary-canary)

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-generate-toc again -->
**Table of Contents**

- [Actuary Canary](#actuary-canary)
    - [First-time Setup](#first-time-setup)
    - [Run](#run)

<!-- markdown-toc end -->

## Architecture

The server is made to run on Heroku's free hobby tier. To do this, it runs as multiple instances in new heroku projects. Here's the default configuration:

### Database

The database instance scrapes data from NASDAQ and Google Finances' API once per day. It keeps track of the following:

- All stocks
  - Symbol (the ticker symbol)
  - HasOptions (true if Google Finance API lists puts)
  - Id (cid on Google Finance API for quick updating)
- The top 1000 most profitable (annual return) puts

### User interface

The UI instance scrapes data from Google Finance and the database instance every 10 minutes. It handles the following:

- Views
  - '/' view of the 1000 most profitable puts
  - '/favorites' view of all puts from favored symbols
  - '/signin' '/signout' user auth pages
- Users
  - Favorite stock symbols
- All puts (of stock symbols that have been favored by a user)

## First-time Setup

```bash
# Clone the repo
$ git clone https://github.com/MaxWofford/actuary-canary && cd actuary-canary

# Build with docker-compose
$ docker-compose build

# Generate a secret key for development
$ touch .env && docker-compose run web echo "SECRET_KEY_BASE=$(rails secret)" >> .env

# Create the db
$ docker-compose run web rails db:create db:migrate
```

## Run

```bash
# Launch the server
$ docker-compose up
```

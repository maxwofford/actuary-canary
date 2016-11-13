# Actuary Canary

[![CircleCI](https://circleci.com/gh/MaxWofford/actuary-canary.svg?style=svg)](https://circleci.com/gh/MaxWofford/actuary-canary)

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-generate-toc again -->
**Table of Contents**

- [Actuary Canary](#actuary-canary)
    - [First-time Setup](#first-time-setup)
    - [Run](#run)

<!-- markdown-toc end -->

## First-time Setup

```bash
# Clone the repo
$ git clone https://github.com/MaxWofford/actuary-canary && cd actuary-canary

# Build with docker-compose
$ docker-compose build

# Generate a secret key for development
$ touch .env && echo "SECRET_KEY_BASE=$(docker-compose run web rails secret)" >> .env

# Create the db
$ docker-compose run web rails db:create db:migrate
```

## Run

```bash
# Launch the server
$ docker-compose up
```

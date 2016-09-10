# Actuary Canary

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
$ touch .env && docker-compose run web echo "SECRET_KEY_BASE=$(rails secret)" >> .env

# Create the db
$ docker-compose run web rails db:create db:migrate
```

## Run

```bash
# Launch the server
$ docker-compose up
```

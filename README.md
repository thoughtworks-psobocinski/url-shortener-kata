# URL Shortener Kata

## Purpose

Demonstrate benefits of dependency injection

## Setup

### 1. Prerequisites

1. Install rbenv (Ruby version manager) using [rbenv-installer](https://github.com/rbenv/rbenv-installer) (follow link for instructions).
    - Run `rbenv init` and follow the instructions to configure your shell
1. Install Ruby: `rbenv install 3.1.0`.
1. Install bundler: `gem install bundler`.
1. Install dependencies for auto-running tests: `brew install ag entr`

### 2. Environment setup

1. Clone repo
```
git clone git@github.com:connected-psobocinski/url-shortener-kata.git
```

2. Install dependencies
```
bundle install
```

3. Open working directory in your IDE of choice
```
code . # vs code
```

## Usage

### Run tests

```
# Auto-run rspec tests
./rspec_autorun.sh
```

### Run a script

Execute via `ruby` command, e.g:
```
ruby app/script.rb
```

## Tools

### Interactive Ruby

Run ruby code in terminal:
```
irb
```

## Kata Description

You have inherited a `URLShortener`. Two public methods exist on the class:

1. `URLShortener.shorten(long_url)`
    - Given a new full-length URL, it generates a shortened version of the URL and stores it in the DB
    - Given an existing full-length URL, it retrieves the shortened version of the URL from the DB
2. `URLShortener.retrieve(short_url)`
    - Given an existing shortened URL, retrieves the full-length URL from the DB
    - Given a non-existent shortened URL, raises a "not found" error

The service needs to be extended in the following way:

1. Use a better URL shortening algorithm
2. Use a more scalable DB technology

The team has not yet decided on either of the above implementations. However, in preparation for the above, we wish to:

1. Verify the behaviour works as documented above
2. Refactor the internals of URLShortener so that it can be extended

Apply TDD to achieve the above two goals.

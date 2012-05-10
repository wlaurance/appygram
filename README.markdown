# Appygram <http://www.appygram.com>

Appygram is a messaging service for web and mobile apps. Among other
things, it can accept and route exception reports.

This Gem/Plugin is for Ruby and Rails applications. It is based on
the library for the dedicated exception handling service Exceptional
<http://exceptional.io>. Data about the request, session, environment
and a backtrace of the exception is sent.

    
## Rails 3 Installation

1.  Add  gem entry to Gemfile
    
    ```ruby
    gem 'appygram'
    ```
    
2.  Run <code>bundle install</code>

3.  Configue your API Key in an initializer
    
    ```
    TBD
    ```
    
    using the API key provided by Appygram

## Reporting exceptions in development

Appygram will not report your exceptions in *development* environment by default. 

To enable reporting of exceptions in development, please add the following lines to your `appygram.yml`

```ruby
development:

  enabled: true
```

## Multiple Rails environments
To use Appygram within multiple Rails environments, edit your
config/appygram.yml to look like the following

```
development:
  enabled: true
  api-key: your-dev-api-key

production:
  enabled: true
  api-key: your-prod-api-key
```

Copyright © 2012 Anything Labs.
Copyright © 2008 - 2012 Exceptional Cloud Services.

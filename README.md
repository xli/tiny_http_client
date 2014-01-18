# Tiny HTTP Client

A really simple http client, get content by url:

```ruby

html_content = TinyHttpClient.get("http://www.google.com")

```

or, add basic auth

```ruby

html_content = TinyHttpClient.get("http://www.google.com") do |req|
  req.basic_auth 'user', 'pass'
end

```

You'll get error when the response is not Net::HTTPSuccess.

# Api

This is a liveview with auth demo useful for a starter application

[![Build Status](https://travis-ci.com/mithereal/phoenix_liveview_skeleton.svg?branch=master)](https://travis-ci.com/mithereal/phoenix_liveview_skeleton)

[![Inline docs](http://inch-ci.org/github/mithereal/phoenix_liveview_skeleton.svg)](http://inch-ci.org/github/mithereal/phoenix_liveview_skeleton)

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)


To setup your server:

  * Create a user called platform
  * Install nginx
  * Install certbot (lets encrypt)
  * a basic nginx configuration with websockets and environment vars is located in the server directory.
  
  
To start your Phoenix server:

  * Setup the application `mix setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Login
 visit [`localhost:4000`](http://localhost:4000/login) in separate private  browser windows.
 - admin:  email: "admin@company.com", password: "123456789abc"
 - user 1:  email: "user1@company.com", password: "123456789abc"
 - user 2:  email: "user2@company.com", password: "123456789abc"

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * liveview-authorisation: https://github.com/leanpanda-com/liveview-authorisation 
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

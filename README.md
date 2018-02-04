# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Project tree
- Home
- Maps
  - Index --> list of public maps (show only)
  - New map --> if authenticated
  - Your maps --> if authenticated

## Authentication code
```
  <% if signed_in? %>
    Signed in as: <%= current_user.email %>
    <%= button_to 'Sign out', sign_out_path, method: :delete %>
  <% else %>
    <%= link_to 'Sign in', sign_in_path %>
  <% end %>

  <div id="flash">
    <% flash.each do |key, value| %>
      <div class="flash <%= key %>"><%= value %></div>
    <% end %>
  </div>
```

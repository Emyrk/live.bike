# Bike

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


## My notes

DB Schema

```
// Updated_at is included
mix phx.gen.schema Entry entries rider_name:string \
  state:string \
  lat:float \
  lng:float \
  bearing:float \
  elevation_gain:float \
  time_elapsed:float \
  total_distance:float \
  battery_percent:float \
  avg_speed:float
mix ecto.migrate
```
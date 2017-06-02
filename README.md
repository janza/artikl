# Artikl

### Usage

    docker run -d \
      --name artikl \
      -p 4000:4000 \
      -e DB_NAME=artikl_prod \
      -e DB_USER=postgres \
      -e DB_PASSWORD=postgres \
      -e DB_HOST=database_host \
      jjanzic/artikl

### Development

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

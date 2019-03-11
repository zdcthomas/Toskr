# Bifrost
The ancient rainbow bridge of Norse Mythology, the Bifröst connected Asgard(the land of the Aesir gods) with Midgard(the world of the humans). Heimdall guards the Asgardian side of the bridge until the day of Ragnarok, when the giants will seige his gate and lay waist to Asgard.

# What?
The Bifrost is the connection point between multiple realms in norse mythology. In our system, Bifrost a bridge as well. Bifrost allows communication between the various services in our system, all through a centralized Pub Sub(Nats) server.

Nats' most fundamental functionality is the publishing of and subscription to `messages` on various channels known as `topics`.
For example: Say a user in our system just created a post. The topic might be `user.created.post` and the message associated with this event might be a json string containing information about the user, the post, and the event in general.
With this library, you can easily [publish](#publishing) these messages, specifying both the topic and the message.
You can also easily [subscribe](#subscribing) to all topics which your service is interested in. 

# Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bifrost` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bifrost, "~> 0.1.0"}
  ]
end
```

# Publishing

# Subscribing
Subscribing is done through the `TopicRouter`, a module in which the messages from a given `topic` can be routed into any specified function.
The topics given in the router must be unique as each one acts as the global name of the listener process which will actually receive the message from our Nats server

# Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bifrost` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bifrost, "~> 0.1.0"},
  ]
end
```

If you want your app to not connect to an actually nats server, there is a mock of the `gnat` hex which will make no external api calls. This mock module is called `Mat` (mock-Gnat) To do this, in your `test.exs`:

```elixir
config :bifrost,
  nats_client: Mat,
```

## Configuration 
Bifrost is configurable 

### Pub sub mocking
  Bifrost 

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/bifrost](https://hexdocs.pm/bifrost).


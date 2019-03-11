# (Rata)Toskr

In Norse Mythology, Ratatoskr is the squirrel whos runs up and down Yggdrasil, the tree of life, and carries angry messages between Níðhöggr(the worm who lives in the roots of Yggrasil), and the eagle which lives on the top most branches of the tree. 
From the [Prose Edda](http://www.gutenberg.org/files/18947/18947-h/18947-h.htm)
```
An eagle sits at the top of the ash, and it has knowledge of many things. Between its eyes sits the hawk called Vedrfolnir [...]. The squirrel called Ratatosk [...] runs up and down the ash. He tells slanderous gossip, provoking the eagle and Nidhogg.
```

# What?
(Rata)Toskr, the crap-talking squirrel, is obviously a fantastic messanger god and in our system it's no different. Toskr allows communication between the various services in our system, all through a centralized Pub Sub(Nats) server.

Nats' most fundamental functionality is the publishing of and subscription to `messages` on various channels known as `topics`.
For example: Say a user in our system just created a post. The topic might be `user.created.post` and the message associated with this event might be a json string containing information about the user, the post, and the event in general.
With this library, you can easily [publish](#publishing) these messages, specifying both the topic and the message.
You can also easily [subscribe](#subscribing) to all topics which your service is interested in. 

# Publishing

# Subscribing
Subscribing is done through the `TopicRouter`, a module in which the messages from a given `topic` can be routed into any specified function.
The topics given in the router must be unique as each one acts as the global name of the listener process which will actually receive the message from our Nats server

# Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `toskr` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:toskr, "~> 0.1.0"},
  ]
end
```

If you want your app to not connect to an actually nats server, there is a mock of the `gnat` hex which will make no external api calls. This mock module is called `Mat` (mock-Gnat) To do this, in your `test.exs`:

```elixir
config :toskr,
  nats_client: Mat,
```

## Configuration 
Toskr is configurable 

### Pub sub mocking
  Toskr 

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/toskr](https://hexdocs.pm/toskr).


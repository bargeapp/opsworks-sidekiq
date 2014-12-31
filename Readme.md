# Sidekiq Opsworks Cookbook using Monit
For amazon linux. Inspiration from https://github.com/drakerlabs/opsworks_sidekiq

## Configuration
In stack settings set custom json like so:

```
"sidekiq": {
  "instances": "1",
  "concurrency": "25",
  "queues": [
    "low",
    ["high", 7]
  ],
  "rack_env": "production"
}
```

## Usage

1. `sidekiq::setup` for setup
2. `sidekiq::restart` for restart
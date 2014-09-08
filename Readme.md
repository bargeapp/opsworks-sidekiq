# Sidekiq Opsworks Cookbook using Monit
For amazon linux. Inspiration from https://github.com/drakerlabs/opsworks_sidekiq

## Configuration
In stack settings set custom json like so:

```
"logentries": {
  "userkey": "[YOUR USER KEY]",
  "hostname": "[SOME NAME FOR SERVER]",
  "files": [
    "[/PATH/TO/FILE1]",
    "[/PATH/TO/FILE2]",
    "[/PATH/TO/FILE3]",
    ....
  ]
}
```

## Usage
This cookbook's broken into two recipes:

1. `logentries::default` installs the logentries agent using the `userkey` and `hostname` specified in the custom json
2. `logentries::follow` follows the files specified in the custom json `files` array

Under your Layer settings you'll want to add `logentries::default` to the *Setup* or *Configure* lifecycle event and `logentries::follow` to the *Deploy* event.
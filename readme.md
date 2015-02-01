# Hubot Voting Script

Vote using [Hubot](http://github.com/github/hubot)

## Installation

Run the npm install command...

    npm install hubot-voting

Add the script to the `external-scripts.json` file

    ["hubot-voting"]

## Usage

### Start a vote

    hubot start vote first item, second item, third item

### Vote

    hubot vote for first item

or...

    hubot vote for 1

or...

    hubot vote first item

or...

    hubot vote 1

### Show choices

    hubot show choices

### Show votes

    hubot show votes

### End a vote

    hubot end vote

### Start or end vote from script

```coffeescript
CronJob = require('cron').CronJob

module.exports = (robot) ->
  new CronJob(
    '0 0 11 * * 1-5',
    () -> { robot.startVote '#room', ['item1', 'item2', 'item3'] },
    null,
    true,
    'Asia/Tokyo'
  )
  new CronJob(
    '0 30 11 * * 1-5',
    () -> { robot.endVote '#room' },
    null,
    true,
    'Asia/Tokyo'
  )
```

## License

MIT licensed. Copyight 2014 Joshua Antonishen.

yulreftweet
===========

This Ruby script posts York University Libraries reference desk activity to the [@yulrefdesk](https://twitter.com/yulrefdesk) account on Twitter.

## Requirements

We use [Libstats](https://code.google.com/p/libstats/) to keep track of our reference desk activity, and this script gets its information from the CSV dump it makes available.  If you want to run this on your own system, you'll need to use Libstats, and you'll need to copy the value of a `login` cookie so the script can get at the data.

Talking to Twitter is done with the [twitter](http://sferik.github.io/twitter/) Ruby gem.  Install it the usual way:

    # gem install twitter

## Configuration

Create an account at Twitter.  Log in to it and then to go [https://dev.twitter.com/apps/new](https://dev.twitter.com/apps/new) and create a new app, following the instructions in the twitter gem documentation.

Copy `config.json.example` to `config.json` and put all the right Twitter keys into it, and also the Libstats cookie.

The URL to Libstats is hardcoded in the script, but it can go in the config file if anyone else is actually interested in running this.

## Usage

It's probably best to run this from cron, with something like (assuming you've cloned this repository into `~/src/yulreftweet`)

    */5 * * * * cd ~/src/yulreftweet/; ./yulreftweet --verbose >> /tmp/yulreftweet.log

The script runs every five minutes and requests the last six minutes of activity.  If it's safe to reduce this to an even five, I will.  The script depends on Twitter to prevent posting duplicate tweets: Twitter rejects a tweet that is identical to a previous one.

## Future plans

* Include charts!




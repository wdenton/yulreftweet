yulreftweet
===========

This Ruby script posts [York University Libraries](http://www.library.yorku.ca/) reference activity to the [@yulreference](https://twitter.com/yulreference) account on Twitter.

The tweets have four fields, like this:

    Bronfman ■ ■ ■ □ □ 1-5 minutes (158362)

The fields are:

* library name
* question type
* duration
* ID number (to make the tweets nonidentical, so Twitter won't reject them)

The question types come from the modified Warner scale we use:

1. Non-Resource (e.g. directional)
2. Skill-Based: Tech Support (e.g. printer jam)
3. Skill-Based: Non-Technical (e.g. basic catalogue search)
4. Strategy-Based (research question)
5. Specialized (requires specialized librarian knowledge)

To make it easier to see at a glance the complexity of the questions being asked, instead of showing a number 1..5 the tweets show question type with one to five ■s (that's the Unicode character BLACK SQUARE).

## Requirements

We use [Libstats](https://code.google.com/p/libstats/) to keep track of our reference desk activity, and this script gets its information from the CSV dump it makes available.  If you want to run this on your own system, you'll need to use Libstats, and you'll need to copy the value of a `login` cookie so the script can get at the data.

Talking to Twitter is done with the [twitter](http://sferik.github.io/twitter/) Ruby gem.  Install it the usual way:

    # gem install twitter

Twitter updates could be made instantly by hacking Libstats or adding a trigger to the database, but I don't think it's that important.

## Configuration

Create an account at Twitter.  Log in to it and then to go [https://dev.twitter.com/apps/new](https://dev.twitter.com/apps/new) and create a new app, following the instructions in the twitter gem documentation.

Copy `config.json.example` to `config.json` and put all the right Twitter keys into it, and also the Libstats cookie.

The URL to Libstats is hardcoded in the script, but it can go in the config file if anyone else is actually interested in running this.

## Usage

It's probably best to run this from cron, with something like (assuming you've cloned this repository into `~/src/yulreftweet`)

    */5 * * * * cd ~/src/yulreftweet/; ./yulreftweet >> /tmp/yulreftweet.log

The script runs every five minutes and requests the last five minutes of activity. The script depends on Twitter to prevent posting duplicate tweets: Twitter rejects a tweet that is identical to a previous one.

Warning: if you use [RVM](http://rvm.io/) then calling the script from cron won't work (see [Using RVM with Cron](https://rvm.io/integration/cron)). The `rvm_wrapper.sh` script is meant to fix this, but it doesn't work right now.

To test it, run it with --verbose and --notweet:

    ./yulreftweet --verbose --notweet




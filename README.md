# Picture Bot v 1.2

Updated for twitter_ebooks version 3+

A deployable twitter bot that solely exists to post pictures of things to the internet. Uses Mispy's [Twitter_Ebooks](https://github.com/mispy/twitter_ebooks) gem to run the bot, the script itself is based on Mispy's [Ebooks_example](https://github.com/mispy/ebooks_example) and modified to update with pictures only and none of the talky stuff.

## Usage:
To install and run the bot, simply insert the commands below.

- git clone https://github.com/FluffyPira/picture-bot.git
- cd picture-bot
- bundle install
- add images to /pictures
- modify bots.rb to include oauth, account names, and author's twitter handle
- run with ./run.rb

Remember that to get the oauth information, you will need to create a [twitter app](https://apps.twitter.com/app/new) associated with the account or use [twurl](https://github.com/marcel/twurl) to associate your bot with an app. 

If you would prefer using different pictures, clear the "pictures" folder and move whatever pictures you want to post to twitter in there. They're posted automagically every 30 minutes unless otherwise specified.

## Heroku:
If you want to run the bot via heroku, there is a simple guide to deploying your [first git to heroku](https://devcenter.heroku.com/articles/git). If you already have heroku, the basic deployment prodecure is as follows:

- git clone https://github.com/FluffyPira/picture-bot.git
- cd picture-bot
- bundle install
- add images to /pictures
- modify bots.rb to include oauth, account names, and author's twitter handle
- git init
- git add .
- git commit -m "_Your commit name_"
- heroku create
- heroku apps:rename "_Your app name_" 
- git push heroku master
- heroku ps:scale worker=1

#### Thanks:
Special thinks to [lyons](https://github.com/lyons) who added the follow/unfollow code before I had to trash the old [Cutie's bot](https://github.com/FluffyPira/cuties-bot) repo because I made an amateur mistake. Thanks as well to @vex0rian and @parvitude on Twitter for the pseudo-random image selection code. <3

I'm sorry that I messed up and your contributions will no longer be shown on GitHub.
require 'twitter_ebooks'
require 'set'
require 'json'

# This is an example bot definition with event handlers commented out
# You can define and instantiate as many bots as you like

CONSUMER_KEY = ""
CONSUMER_SECRET = ""
OAUTH_TOKEN = "" # oauth token for ebooks account
OAUTH_TOKEN_SECRET = "" # oauth secret for ebooks account

TWITTER_USERNAME = "" # Ebooks account username
AUTHOR_NAME = "" # Put your twitter handle in here
HASH = "" # Hashtag if you post to one
SOURCES_FILE = "" # JSON object of filename:source_url pairs if you want to post sources

SPECIAL_WORDS = [''] # Words associated with your bot!
TRIGGER_WORDS = [''] # will trigger auto block

BLACKLIST = ['tnietzschequote'] # Users who don't want interaction; not currently in use

class MyBot < Ebooks::Bot
  # Configuration here applies to all MyBots
  def configure
    # Consumer details come from registering an app at https://dev.twitter.com/
    # Once you have consumer details, use "ebooks auth" for new access tokens
    self.consumer_key = CONSUMER_KEY # Your app consumer key
    self.consumer_secret = CONSUMER_SECRET # Your app consumer secret

    # Users to block instead of interacting with
    self.blacklist = BLACKLIST

    # Range in seconds to randomize delay when bot.delay is called
    self.delay_range = 1..6
  end

  def on_startup
    @pics = (Dir.entries("pictures/") - %w[.. . .DS_Store]).sort()
    log @pics.take(5) # poll for consistency and tracking purposes.
    @status_count = twitter.user.statuses_count
    
    load_sources
    
    post_picture
    
    prune_following
    
    scheduler.every '3600' do
      post_picture
    end
    
  end

  def on_message(dm)
    # Reply to a DM
    poop = Random.new.bytes(5)
    delay do
      bot.reply dm, "Talk to @#{AUTHOR_NAME} #{poop}" 
    end
    
  end

  def on_follow(user)
    follow(user.screen_name)
  end

  def on_mention(tweet)
    tokens = Ebooks::NLP.tokenize(tweet.text)

    special = tokens.find { |t| SPECIAL_WORDS.include?(t.downcase) }
    trigger = tokens.find { |t| TRIGGER_WORDS.include?(t.downcase) }
    
    if trigger
      block(tweet)
    end
    
    if special
      favorite(tweet)
    end 
    
  end

  def on_timeline(tweet)
    tokens = Ebooks::NLP.tokenize(tweet.text)

    special = tokens.find { |t| SPECIAL_WORDS.include?(t.downcase) }
    
    if special
      favorite(tweet) if rand < 0.20
    end 
    
  end
  
  def favorite(tweet)
    delay do
      super(tweet)
    end
    
  end 
  
  def next_index()
    seq = (0..(@pics.size - 1)).to_a
    seed = @status_count / @pics.size
    r = Random.new(seed)
    seq.shuffle!(random: r)
    res = seq[@status_count % @pics.size]
    @status_count = @status_count + 1
    return res
  end
  
  def prune_following
    following = Set.new(twitter.friend_ids.to_a)
    followers = Set.new(twitter.follower_ids.to_a)
    to_unfollow = (following - followers).to_a
    log("Unfollowing user ids: #{to_unfollow}")
    twitter.unfollow(to_unfollow)
  end
  
  def load_sources()
    @source_links = begin
      x = File.open(SOURCES_FILE, "r") {|file| JSON.load(file.read())}
      x.is_a?(Hash) ? x : {}
    rescue
      {}
    end
  end
  
  # Returns empty string if no source exists
  def get_source(pic)
    @source_links[pic] or ""
  end
  
  def post_picture
    pic = @pics[next_index]
    pictweet(HASH + " " + get_source(pic), "pictures/#{pic}")
  end
  
end

# Make a MyBot and attach it to an account
MyBot.new(TWITTER_USERNAME) do |bot|
  bot.access_token = OAUTH_TOKEN # Token connecting the app to this account
  bot.access_token_secret = OAUTH_TOKEN_SECRET # Secret connecting the app to this account
end

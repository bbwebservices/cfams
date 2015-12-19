class Dash < ActiveRecord::Base
	has_many :posts	




	def giph(terms)
		url = "http://api.giphy.com/v1/gifs/search?q="+terms+"&api_key=dc6zaTOxFJmzC&limit=50"
		resp = Net::HTTP.get_response(URI.parse(url))
		buffer = resp.body
		result = JSON.parse(buffer)
		temp = []
			result['data'].each do |x|
				temp.push(x["images"]["fixed_height"]["url"], x["url"], x["images"]["downsized_still"]["url"])
			end
		return temp 
	end

	def twit(search)
		twitCli = Twitter::REST::Client.new do |config|
		  config.consumer_key        = "KxGET2RtfQlVM6oDOAZFXirkJ"
		  config.consumer_secret     = "R2mwQWpMz3SXqBUQsoTnlMhwP2JPhxTbJRaGjJ1rfAHlXd8P0D"
		  config.access_token        = "28226407-kH0D7UDHDobk93OaHXMcuLlAwpNogkjROlNB20DGo"
		  config.access_token_secret = "ID3kizlxpu3JU3yGKSNaxUZtWAhUivLA6haguOfHq1mqO"
		end

		temp = []
		twitCli.search(search.to_s + " -rt").take(15).collect do |tweet|
			temp.push(["@"+tweet.user.screen_name, tweet.text])
		end



		return temp
	end

	def redd(search)


		redd_url = "https://www.reddit.com/subreddits/search.json?q=" + search
		resp = Net::HTTP.get_response(URI.parse(redd_url))
		data = resp.body
		search_res = JSON.parse(data)		
		temp = []
		search_res["data"]["children"].each do |subredd|
			temp.push(subredd)
		end

		return temp


		# reddit_api_url = "https://www.reddit.com/r/"+subreddit+"/.json"



		# resp = Net::HTTP.get_response(URI.parse(reddit_api_url))
		# data = resp.body
		# result = JSON.parse(data)
		# temp = []
		# result["data"]["children"].each do |post|
		# 	temp.push(post["data"]["preview"]["images"].first["source"])
		# end
		# return temp.collect{|x|x["url"]}
	end


	def randomize
		temp = []
		temp = self.twit + self.giph("cat+asshole") + self.redd("catsareassholes")
		return temp.shuffle
	end





end

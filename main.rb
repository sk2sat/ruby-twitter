#!/usr/bin/ruby
require 'yaml'
load 'client.rb'

twitter_client = TwitterClient.new

tc = twitter_client.getClient
tc.update "起動中..."

$t_id = 0
$yohanesu_num = 0

def load_yaml
	yml = YAML.load_file("data.yml")["data"]
	$t_id = (yml["t_id"]).to_i
	$yohanesu_num = (yml["yohanesu_num"]).to_i
	puts yml["yohanesu_num"]
end

def save_yaml
	open("data.yml", "w") do |f|
		f.puts("data:")
		f.puts("  t_id: "+$t_id.to_s)
		f.puts("  yohanesu_num: "+$yohanesu_num.to_s)
	end
end

load_yaml
while true do
	tweet = tc.search("千種夜羽").first
	if tweet.id != $t_id
		user = tweet.user
		puts user.name,tweet.text
		if user.id != 876273884563030018
			str = "@sksat_tty "
			if user.id == 730341017736470528
				str += "わたしの名前を呼びましたね？\nちなみに" + $yohanesu_num.to_s + "回目ですよ！"
				$yohanesu_num += 1
				puts "よはねす"
			else
				str += user.name + "(" + user.uri + ")さんが千種夜羽についてツイートしています"
				puts str
			end
			tc.update(str, in_reply_to_status_id: tweet.id)
		end
	end
	$t_id = tweet.id
	save_yaml
	sleep 5
end

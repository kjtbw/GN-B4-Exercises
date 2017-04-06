$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sinatra'
require 'SlackBot'

#make some func for My SlackBot
class MySlackBot < SlackBot
  
  def text_respond(params, options = {})
    return nil if params[:user_name] == "slackbot" || params[:user_id] == "USLACKBOT"
    # user_name = params[:user_name] ? "@#{params[:user_name]}" : ""xs
    return params.merge(options).to_json
  end

 def get_par_content(str)
    #index(par,offset):get par index
    #if offset exist, search start point is offset
    #ex. index(a,3):start third point
    #ex. index(a,-1):start last point
    #ex. index(a,-2):start last from second point 
    i1=str.index("[");
    i2=str.index("]",-1);
    return str[i1+1...i2];
  end
  
  
  
  # cool code goes here
end

slackbot = MySlackBot.new
slackbot.post_message("hello");

set :environment, :production

get '/' do
  "SlackBot Server"
end

#params:get_data(json form)
post '/slack' do
  content_type :json
  slackbot.naive_respond(params, username: "Bot")
end

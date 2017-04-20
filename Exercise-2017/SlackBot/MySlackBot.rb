# coding: utf-8
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sinatra'
require 'SlackBot'
require 'Anniversary'

#make some func for My SlackBot
class MySlackBot < SlackBot
  
  def text_respond(params, options = {})
    return nil if params[:user_name] == "slackbot" || params[:user_id] == "USLACKBOT"
    user_name = params[:user_name] ? "#{params[:user_name]}" : ""
    user_id = params[:user_id] ? "#{params[:user_id]}" : ""
    print user_id
    
    #slice @YBot and get data
    recv_str=params[:text]
    recv_str.slice!(0..5)
    str = get_par_content(recv_str)
    date = get_date(recv_str)
    
    if  str == nil && date != nil 
      anniversary = Anniversary.new(date)
      array = anniversary.to_array
      str = anniversary.make_bot_text(array)
    end
    
    str="Hello" if  str==nil && date==nil 
    data={:text => "<@#{user_id}|#{user_name}> " + str}
    return  data.merge(options).to_json
  end
  

  def get_par_content(str)
    i1=str.index("「")
    i2=str.rindex("」と言って",-1)  
    return nil if i1==nil || i2==nil  
    return str[i1+1...i2];
  end

 
  def get_date(str)
    return Date.today if str.include?("今日は何の日")
    return nil if str.match(/\s*\d+月\s*\d+日は何の日/) == nil
    matchm=str.match(/\s*\d+月/)
    matchd=str.match(/\s*\d+日/)
    im=matchm.to_s.to_i
    id=matchd.to_s.to_i
    
    if im==2 && id==29
      iy=2016
    else iy=2017
    end
    
    return Date.new(iy,im,id) if Date.valid_date?(iy,im,id)
    return nil
  end
  # cool code goes here
end

# for debug loop
# i=0
# date=Date.new(2016,12,1)
# while i< 31
#  debug_flag=false
#  anniversary=Anniversary.new(date,debug_flag)
#  print "\n#{anniversary.date_offset}\n" 
#  anniversary.to_array.each do |key|
#    print "#{key}\n"
#  end
#  i+=1
#  date=date.next
#  #sleep(0.75)
# end
# exit


slackbot = MySlackBot.new

set :environment, :production

get '/' do
  "SlackBot Server"
end


post '/slack' do
  content_type :json
  slackbot.text_respond(params, username: "YBot")
end

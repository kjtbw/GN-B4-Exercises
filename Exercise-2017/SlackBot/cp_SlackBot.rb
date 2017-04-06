require 'json'
require 'uri'
require 'yaml'
require 'net/https'

class SlackBot
  def initialize(settings_file_path = "settings.yml")
    #exist?(file_name):if file_name exist, return true
    #load_file(file_name):read file_name, and return hash
    #YAML: hash or array etc...
    #config class : hash
    config = YAML.load_file(settings_file_path) if File.exist?(settings_file_path)
    # This code assumes to set incoming webhook url as evironment variable in Heroku
    # SlackBot uses settings.yml as config when it serves on local

    #Q point
    #str[other_str]:return other_str?
    #ENV[]:return env key
    #|| : check value return value
    #| :check value(0,1) return 0,1
    #0, nil :false, other :true
    #@ variable : can use class, normal variable use only method
    @incoming_webhook = ENV['INCOMING_WEBHOOK_URL'] || config["incoming_webhook_url"]
  end

  #options={}:if options exist, use options
  #else options={},
  #options class:hash
  def post_message(string, options = {})
    #payload, options class :hash
    #merge: add hash
    payload = options.merge({text: string})
    #uri class :URI::HTTP
    #parse :make uri class from uri str
    uri = URI.parse(@incoming_webhook)
    res = nil
    #to_json:make json to hash
    json = payload.to_json
    request = "payload=" + json

    #start:http conection start
    #host, port:return them host or post

    #Q point
    #use_ssl?
    #start:start conection http
    # use_ssl: set flag to use ssl
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      #verify_mode:set verify mode for conection
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      #post :post request to uri
      #request_uri:return them path
      res = http.post(uri.request_uri, request)
    end

    return res
  end

  def naive_respond(params, options = {})
    #ignore bot speak
    #params class :hash
    #hash[other]:make new hash ,key:other  and return maked hash value
    return nil if params[:user_name] == "slackbot" || params[:user_id] == "USLACKBOT"

    #if(cond)eq1 else eq2 == cond ? eq1 :eq2
    # " #{val}  ":can use eq in str
    user_name = params[:user_name] ? "@#{params[:user_name]}" : ""
    #return text by json form
    return {text: "#{user_name} Hi!"}.merge(options).to_json
  end
end

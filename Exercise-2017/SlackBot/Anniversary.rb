# coding: utf-8
require 'json'
require 'uri'
require 'yaml'
require 'net/https'
require 'Cleaner'




class Anniversary
  def initialize(date,debug_flag = {})
    @debug_flag=debug_flag
    @date   = date
    respond =  JSON.parse(get_wiki(date))
    pageid  = respond["query"]["pages"].keys[0]
    body    = respond["query"]["pages"][pageid]["revisions"][0]["*"]
    @data   = wiki_parse(body)
    @url    = "https://ja.wikipedia.org/wiki/" + date_offset
  end

  
  def date_offset
    date_offset="#{@date.month}" + "月" + "#{@date.day}" + "日"
  end
  

  attr_reader :url
  attr_reader :date

  
  def get_wiki(date)
    url_offset = "https://ja.wikipedia.org/w/api.php?format=json&utf8&action=query&prop=revisions&rvprop=content&titles=" + date_offset
    url = URI.escape(url_offset)
    uri = URI.parse(url)
    res = Net::HTTP.get(uri)
    return res
  end

  
    def to_array
      data_hash = get_anniversary(@data)
      i=0
      key_array=Array.new
      data_hash.each_key{ |key|
        key_array[i]=key
        i=i+1
      }
      return key_array
    end

    
    def to_hash
      get_anniveresary(@data)
    end

    
    def make_bot_text(array)
      length = array.length
      colum_n = 5
      str = date_offset + "の情報は#{length}件存在します．\n"
      if length > colum_n
        length = colum_n
        str = str + "上位#{colum_n}件を表示します．\n"
      end
      j = 0
      while j< length
        str = str + array[j] +"\n"
        j = j+1
      end
      str = str+"\n"+"リンク:"+ url+"\n"
      return str
    end
 
    
    private
    def wiki_parse(body)
      body = body.partition("== 記念日・年中行事 ==\n")
      body = body[2].partition("== フィクションのできごと ==")
      body = body[0].partition("==フィクションのできごと==")
      return body[0]
    end

    
   def get_anniversary(data_str)
     cleaner = Cleaner.new
     debug_print(data_str)
     data_str = cleaner.wiki_str(data_str);
     debug_print(data_str)
     data_array = data_str.split(/\n/)
     debug_print(data_array)
     data_hash = array_to_hash(data_array)  
    return data_hash
   end#get_anniversary

   
   def array_to_hash(data_array)
     i=0
     length = data_array.length
     data_hash=Hash.new
     while i< length
       data_array[i].delete!("*")
       data_array[i].lstrip!
       data_key=data_array[i]
       data_hash[data_key]= nil
       j=1
       break if data_array[i+j]==nil
       while data_array[i+j].match(/^\*[^:\*]/)  == nil
         data_value=String.new
         data_value=data_value + data_array[i+j]
         j=j+1
         break if data_array[i+j]==nil
       end
       data_hash[data_key]= data_value
       i=i+j
     end
    return data_hash   
   end #end split_data_array

   
   def debug_print(data)
     print "\n" + "#{data}" + "\n" if @debug_flag==true 
   end

end # class Anniverasary

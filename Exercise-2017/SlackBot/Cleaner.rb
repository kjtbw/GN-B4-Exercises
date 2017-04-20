# coding: utf-8
class Cleaner

  def initialize
  end
  attr_reader :str
  
  def wiki_str(str)
    @str=str
    #clear comment, and init point
    #must be first
    slice_between("<!--","<","-->",2)
    str.slice!(0...str.index("*"))
    
    #clear photo etc
    slice_between("[[Image","[","]",1)
    slice_between("[[画像","[","]",1)
    slice_between("[[File","[","]",1)
    slice_between("{{Anchor","{","}",0)
    slice_between("CP932フォント","C","|",0)
    slice_between("{要出典","{","}",0)
    slice_between("{cn","{","}",0)
    slice_between("{weight|normal","{","l|",1)
    
    #clear refs
    slice_between("<ref>","<","</ref>",5)
    slice_between("<blockquote>","<","</blockquote>",5)
    
    
    #clear link
    link_n=str.scan(/{{[^}]+\|[^}]+\|[^{]+}}/).length
    i=0
    while i < link_n
      is=str.index(/{{[^}]+\|[^}]+\|[^{]+}}/)
      ivar1=str.index("|",is)
      str.slice!(is..ivar1)
      ivar2=str.index("|",is)
      ie=str.index("}}",ivar2)
      str.slice!(ivar2..ie+1)
      i=i+1
    end
    slice_pattern(/\[\[[^\]]+\|[^\[]+\]\]/,"|",0)
    slice_pattern(/http.*\s/,"\s",0)
  
    
    #clear nation and parenthesis 
    slice_pattern(/\（{{.+}}\）/,"）",0)
    slice_pattern(/{{\w+}}/,"}",1)
    slice_pattern(/\(\s*\)/,")",0)
    slice_pattern(/（\s*）/,"）",0)
    slice_pattern(/\(\s*）/,"）",0)
    slice_pattern(/（\s*\)/,")",0)
    slice_pattern(/<[^<]+>/,">",0)
    
    #clear date and meaningless point
    slice_between("date","d","月",0)
    slice_between(/・など/,"・","ど",0)
    slice_char(/[\s・（]・|・[\s・）]/,"・")
    slice_char(/（の/,"の")
    str=str.delete("\]{},<>\[、;'")
 
    return str
  end# wiki_str

  
  private
  def slice_pattern(pattern,end_char,end_size)
    par_n=str.scan(pattern).length
    i=0
    while i < par_n
      is=str.index(pattern)
      ie=str.index(end_char,is)
      return nil if is == nil || ie == nil
      str.slice!(is..ie + end_size)
      i=i+1
    end
  end

  
  def slice_char(pattern,char)
    par_n=str.scan(pattern).length
    i=0
    while i < par_n
      is=str.index(pattern)
      ie=str.index(char,is-1)
      return nil if is == nil || ie == nil
      str.slice!(ie)
      i=i+1
    end
  end
  

  def slice_between(start_str,start_char,end_str,end_size)
    ref_n = str.scan(start_str).length
    i=0
    while i < ref_n
      is = str.index(start_str)
      ie = str.index(end_str,is)
      return nil if is == nil || ie == nil
      while is >= ie
        ie=str.index(end_str,ie+1)
        i=i+1
      end
      if str[is+1...ie].include?(start_char)
        str[is+1...ie].slice!(str.index(start_char,is+1))
        ie = ie-1
        ie = str.index(end_str,ie+1)
        i = i+1
      end
      return nil if is == nil || ie == nil
      str.slice!(is..ie + end_size)
      i = i+1
    end
  end#slice_between
  
end#class Cleaner

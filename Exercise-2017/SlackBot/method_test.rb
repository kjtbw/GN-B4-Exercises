class Test
  
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
  
  
end

inst=Test.new;

puts inst.get_par_content("[a]");
puts inst.get_par_content("[[[]a]");


puts inst.get_par_content("[a]][]]");

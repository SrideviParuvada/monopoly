class Person
  #attr_reader is the replacement for method name to access @name
  attr_reader :name, :months
  def initialize(name)
    @name = name
    @nums = []
    @chars = Hash.new
  end
  # def name
  #   @name
  # end


  def assign_key_value_to_array
    i = 0
    while i < 2
      @nums << ["#{i}" => "#{i}".to_i+5]
      #break
       i = i+1
    end
    @nums
  end

  def assign_key_value_to_hash(name)
    @chars = {1 => "#{name}"}
    puts "#{@chars[1]}"
    @chars.store(2, "#{name}")
    @chars.store(3, "#{name}")
    @chars
  end


  def hash_manipulations(hash)
    puts "hash as it is: #{hash}"
    puts "access hash values using index: #{hash[1]}"
    puts "access hash values using key: #{hash["space_01"]}"
    puts "access secondary hash value using key: #{hash["space_01"]["name"]}"
    # transform_keys method is used to transform keys in a hash, in beloow example changing all keys to symbols
    # transform_keys! will make changes to existing hash, in this case "hash"
    hash.transform_keys! do |key|
       key.to_sym
    end
    puts "Hash: #{hash}"
    puts "access hash values using key: #{hash[:space_01]}"
    puts "access secondary hash values using key: #{hash[:space_01]["name"]}"
    end
end


person = Person.new("Eesha")
# puts person.name
# puts person.assign_key_value_to_array
# puts person.assign_key_value_to_array[0]
# puts person.assign_key_value_to_array[1]
# puts person.assign_key_value_to_hash("Abhi")
hash =  {"space_01"=>{"name"=>"Mediterranean Avenue", "type"=>"property", "value"=>60}, "space_02"=>{"name"=>"Baltic Avenue", "type"=>"property", "value"=>60}, "space_03"=>{"name"=>"Oriental Avenue", "type"=>"p
roperty", "value"=>100}, "space_04"=>{"name"=>"Vermont Avenue", "type"=>"property", "value"=>100}}
puts person.hash_manipulations(hash)



# use pry for debugging
# it cannot be last statement in the program
# it needs something after it
# it will stop at  pry step foryou to debug
# binding.pry
#
#
# In ruby if you want to access the last element -1 should do it
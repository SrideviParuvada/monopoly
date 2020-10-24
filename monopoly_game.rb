require 'yaml'
require 'pry'
require_relative './classes.rb'
require_relative './modules.rb'
include Monopoly

puts "How many players would like to play the game?"
number_of_players = gets.strip.to_i
players = []

number_of_players.times do |count|
  puts "What is the name of player #{count+1}?"
  players << Player.new(gets.strip.to_s)
end

user_input = nil
until exit_text(user_input)
  players.each { |player|
      is_double = true
      begin
        is_double = turn(player)
        puts "Your turn again #{player.name} as you rolled double"
      end until is_double == false
      owned_properties(player.name)
   }
end



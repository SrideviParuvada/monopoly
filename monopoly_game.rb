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
     turn(player)
     properties_owned_by_player(player.name)
   }
end



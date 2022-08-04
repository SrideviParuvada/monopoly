require 'pry'
require 'yaml'

Dir.glob(File.join(File.dirname(__FILE__), 'support_game', '*.rb'), &method(:require))

include Menu

option = menu(options: ['New Game', 'Load Game', 'Exit Game'],
              title: 'Please choose one of the options to start the game')

#Initialising board, community chest and chance cards
@community_chest = CardPile.new(file: 'Community_chest.yml')
@chance_cards = CardPile.new(file: 'Chance_cards.yml')
BOARD = send option

@players.cycle do |player|
  if player.status == 'Active'
    @current_turn ||= NewTurn.new(player: player)
    turn(current_turn:@current_turn)
    @current_turn = nil
  end
end





#Instead of getting money on Go You are getting money on Board walk

# Next week
# Mortegaging the properties
# Handling other kinds of debt
# add chance and community chest

# there are 3 ways go to jail
# 1. roll 3 doubles
# 2. land on Go to jail space
# 3. when you draw go to jail card from community chest and chance
#
# Next week
# We will handle debt - right now if player doesn't have any funds and in jail and they didn't roll double to come out of jail, funds are going negative instead it should stop player from moving
# mathmetical way to handle real road
#
# 2/16
# if you don't have enough funds to pay rent or jail fine, you should not be allowed move until you clear that debt -
# test if rent is getting paid correctly to right owner in a 4 player game
# adjust the save game and force player to clear debt before they can roll
#
# Bug: When player goes to jail and choose to roll and ends turn and when it is his turn again, debt is getting set to 0
#
#
# 3/9
# Community chest functionality
# First add 2 community chest spaces on board where they belong
# when you land on those you will draw a card from draw pile
# get out of jail card stays with player until they use it but other cards go to discard pile until draw pile is not empty
# some cards take money from bank and give it to player
# some cards take money from other players and give it to player
# some cards send you to jail or teleports to other places
# and if you pass go collect 200 $
#
# 3/23
# Create a community chest yml and chance yml
#

#4/20
# one tricky card is get out of jail free card - do this last as it is hard
# handle debt - done
# so you are in jail, you tried to rll doubles in 3 turns but your didn't so now you have to pay 50 but you
# don't have that funds then your are at -50, you can move but cannot end turn until you pay
# this 50
# need to remove debt method
# one more rule, you cannot roll if your funds are below zero
#
# 4/27
# Add a separate method to reshuffle - populate file and randomise card order
# Change cards class to pile again
#
# Will continue work on card piles with Chris next week - reminder

#5/4
#Refine debt logic - done
#if you are negative you can't end turn - done
# look at the methods and make sure they are single responsibility
# look at the draw card
#
#
# # Add a separate method to reshuffle - populate file and randomise card order
# # Change cards class to pile again
# #
# # Will continue work on card piles with Chris next week - reminder
#
#
#
#
# 5/11/22
# So make it work with CardPile
# And single responsibility
# if have time work on  Bug: if one player is out of money, it is ending game for everyone, it should let other team player play
# add fore fit option should be available at any time
# if player forfeits banker should get everything player has, meaning a property will get transferred to banker
#
# 6/1/22
# when a player forfeits it is skipping a player and going to 3rd player's turn - Fixed
# when they forfeit instead of deleting a player, you might want to flag them and skip them ..so they are in the list but they are not active - Done
#make sure using cardpile class and remove duplicate individual methods - done
#
#
# 6/29/22
# Work on adding functionality to all cards in community chest and chance piles
# Figure out how to save community chest and chance pile and how to load them - semi done
#
# 7/6/22
# card pile is getting reinitiated with smaller deck when we load the game, and when pile is empty, it never reinitiates entire deck  - done
# add ability to manage_properties
#
# Line 18 in player.rb may not be right to check for length of 2 anymore
# 
# Backlog
# next class, start with handling get out of jail card
# Houses and hotels
# mortgage
# trade
#
# auctions - nice to have
# Add UI

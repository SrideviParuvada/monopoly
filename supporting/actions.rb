def roll(min: 2, max: 2, player:player)
  player.rent_payed = false
  num1 = rand(min..max)
  num2 = rand(min..max)
  puts "Dice 1: #{num1}"
  puts "Dice 2: #{num2}"
  total_roll = num1 + num2
  puts "Dice roll: #{total_roll}"
  if num1 == num2
    player.is_double = true
    player.double_count += 1
  end
  total_roll
end

def buy_property(player)
  player.cash -= BOARD[player.position].value
  BOARD[player.position].owner = player.name
end

def pay_rent(player)
  owner = BOARD[player.position].owner
  rent = BOARD[player.position].rent
  if BOARD[player.position].type == 'rail_road'
      puts "it is a rail road"
      rent = rail_road_rent(owner)
  end
  puts "#{player.name} is on #{BOARD[player.position].name} and it's rent is #{rent}"
  if player.cash < rent
    puts "#{player.name} doesn't have enough cash to pay rent"
  else
    owner_player = player_information(owner)
    owner_player.cash += rent
    player.cash -= rent
    player.rent_payed = true
  end
end

def move_player(player:, move: nil, move_to: nil)
  if move_to.nil?
    position_before_moving = player.position
    player.position += move.to_i
    if player.position > BOARD.length - 1
      player.position -= BOARD.length
    end
    if (player.position < position_before_moving && player.position != 0) || (position_before_moving  == 0 && !player.is_start)
      puts "#{player.name} you just passed Go and you will get $200"
      player.cash += 200
    end
    player.is_start = false
  else
    player.position = space_index(space_name: move_to)
  end
  player.has_rolled = true
end
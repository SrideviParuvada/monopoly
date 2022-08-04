require 'io/console'

module Menu

  def menu(options:, title:, name:'')
    if name.empty?
      puts title
    else
      puts "#{name} #{title}"
    end
    options.each_with_index { |value, index| puts "#{index + 1}: #{value}" }
    pick_valid_choice(options)
  end

  private

  def pick_valid_choice(options)
    begin
      user_input = gets.strip.to_i
      # user_input = STDIN.getch
      if user_input < 1 || user_input > options.length
        puts "user input : #{user_input} and option length: #{options.length}"
        puts 'Invalid choice please try again'
      end
    end until user_input.between?(1, options.length)
    options[user_input - 1].gsub(' ', '_').downcase
  end

end
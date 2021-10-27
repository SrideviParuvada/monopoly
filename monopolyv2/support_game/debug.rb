DEBUG = ENV['DEBUG'] || 'false'

def log(message)
  puts message if DEBUG == 'true'
end
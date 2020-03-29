class Game

  attr_reader :user_board, :computer_board, :user_ships, :computer_ships
  def initialize(user_board, computer_board, user_ships, computer_ships)
    @user_board = user_board
    @computer_board = computer_board
    @user_ships = user_ships
    @computer_ships = computer_ships
  end

  def start
    while true
      main_menu
      computer_places_ships
      user_places_ships
      until user_lost || computer_lost
        execute_turn
      end
      if user_lost
        puts "I won!"
      else computer_lost
        puts "You won!"
      end
    end
  end

  def main_menu
    input = welcome_message
    until input == "p" || input == "q"
      welcome_message
      input = welcome_message
    end

    if input == "p"
      return
    elsif input == "q"
      exit
    end
  end

  def welcome_message
    puts "Welcome to BATTLESHIP"
    puts "Enter p to play. Enter q to quit."
    gets.chomp.downcase
  end

  def computer_places_ships(ships = @computer_ships)
    ships.each do |ship|
      random_ship_placement(ship)
    end
    puts ("I have laid out my ships on the grid.\nYou now need to lay out your two ships.\n"+
    "The #{@user_ships[0].name.capitalize} is #{@user_ships[0].length} units long and the #{@user_ships[1].name.capitalize} is #{@user_ships[1].length} units long.")
    puts @user_board.render
  end

  def random_ship_placement(ship)
    coordinates = []
    ship.length.times {coordinates <<  computer_chooses_random_cell }
    until @computer_board.valid_placement?(ship, coordinates)
      coordinates.shift
      coordinates << computer_chooses_random_cell
    end
    @computer_board.place(ship, coordinates)
  end

  def computer_chooses_random_cell
    @computer_board.cells.keys.shuffle[0]
  end

  def user_places_ships(submarine = @user_ships[0], cruiser = @user_ships[1])
    user_places_submarine(submarine)
    user_places_cruiser(cruiser)
  end

  def user_places_submarine(submarine)
    print "Enter the squares for the Submarine (2 spaces):\n>"
    input = gets.chomp.upcase
    coordinates = input.split(" ")
    until @user_board.valid_placement?(submarine, coordinates)
      print "Those are invalid coordinates. Please try again:\n>"
      input = gets.chomp.upcase
      coordinates = input.split(" ")
    end
    @user_board.place(submarine, coordinates)
    puts @user_board.render(true)
  end

  def user_places_cruiser(cruiser)
    print "Enter the squares for the Cruiser (3 spaces):\n>"
    input = gets.chomp.upcase
    coordinates = input.split(" ")
    until @user_board.valid_placement?(cruiser, coordinates)
      print "Those are invalid coordinates. Please try again:\n>"
      input = gets.chomp.upcase
      coordinates = input.split(" ")
    end
    @user_board.place(cruiser, coordinates)
  end

  def execute_turn
    turn = Turn.new(@user_board, @computer_board)
    turn.render_boards
    turn.user_shoots
    turn.computer_shoots
  end

  def user_lost
    @user_ships.all? do |ship|
      ship.sunk?
    end
  end

  def computer_lost
    @computer_ships.all? do |ship|
      ship.sunk?
    end
  end

end

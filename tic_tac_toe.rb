class TicTacToe

  X = "x"
  O = "o"

  attr_reader :player_piece, :computer_piece, :board
  attr_writer :player_piece, :computer_piece, :board

	def initialize
    @board = [[nil, nil, nil],
              [nil, nil, nil],
              [nil, nil, nil]]
	end

  def start
    puts "Do you want to be x or o?"
    chosen_piece = gets
    chosen_piece.chomp!
    initalize_pieces(chosen_piece)
    if valid_pieces?
      play
    end
  end

  def initalize_pieces(chosen_piece)
    chosen_piece.downcase!
    if chosen_piece == X || chosen_piece == O
      @player_piece = chosen_piece
      @computer_piece = O if @player_piece == X
      @computer_piece = X if @player_piece == O
    else
      puts "You have chosen an incorrect piece!"
    end
  end

  def valid_pieces?
    @player_piece != nil && @computer_piece != nil
  end

	def play
		unless game_over?
      display_board      
      row, column = gather_input
      if valid_move?(row, column)
        update_board(row, column, @player_piece)
        computer_turn unless board_full?
      end
      play
		else
      puts "*********"
      puts "*********"		  
      display_board      
      puts "Game over!"
      return
		end
	end

  def gather_input
      puts "Please enter row, column (exp. 1,2):"
		  user_value = gets
      row, column = parse_input(user_value)
      [row, column]
  end

  def valid_move?(row, column)
    if row > 2 || column > 2
      puts "You have chosen a value outside the range!  Try between 1 and 3."
      return false
    elsif !empty_spot?(row, column)
      puts "You have chosen a spot already occupied!  Try again!"
      return false
    end
    return true
  end

  def board_full?
    !@board.flatten.include?(nil)
  end

  def empty_spot?(row, column)
    return true if board[row][column] == nil
    return false
  end

  def parse_input(user_value)
    values = user_value.split(",")
    values.collect! {|v| v.to_i - 1 }
    return values
  end

  def display_board
    puts "-------"
    0.upto(2) do |row|
      puts "|#{marker(row, 0)}|#{marker(row, 1)}|#{marker(row, 2)}|"
    end
    puts "-------"
  end

  def marker(row, column)
    return "-" if empty_spot?(row, column)
    return @board[row][column]
  end

	def game_over?
		return true if row_match?
    return true if column_match?
    return true if diagnol_match?
    return true if board_full?
    return false
	end

  def update_board(row, column, piece)
    board[row][column] = piece
  end

  def computer_turn
    row, column = computer_choice
    update_board(row, column, @computer_piece)
  end

  def computer_choice
    row = nil
    column = nil
    # go for the win
    row, column = computer_fill_row_move(@computer_piece, @player_piece)
    row, column = computer_fill_column_move(@computer_piece, @player_piece) if row == nil || column == nil
    row, column = computer_fill_diagnol_move(@computer_piece, @player_piece) if row == nil || column == nil
    # block the player
    row, column = computer_fill_row_move(@player_piece, @computer_piece) if row == nil || column == nil
    row, column = computer_fill_column_move(@player_piece, @computer_piece) if row == nil || column == nil
    row, column = computer_fill_diagnol_move(@player_piece, @computer_piece) if row == nil || column == nil
    # prioritize based on player move
    row, column = computer_priortize_move if row == nil || column == nil
    [row, column]
  end

  def computer_fill_row_move(included_piece, not_included_piece)
    @board.each do |row|
      if row.include?(included_piece) && !row.include?(not_included_piece) && row.compact.size == 2
        return @board.index(row), row.index(nil)
      end
    end
    return nil, nil  
  end

  def computer_fill_column_move(inlcuded_piece, not_included_piece)
    0.upto(2) do |column|
      column_array = []
      @board.each do |row|
        column_array << row[column]
      end
      if column_array.include?(inlcuded_piece) && !column_array.include?(not_included_piece) && column_array.compact.size == 2
        return column_array.index(nil), column
      end        
    end
    return nil, nil
  end

  def computer_fill_diagnol_move(included_piece, not_included_piece)
    diagnol1 = []
    diagnol2 = []

    diagnol1 << @board[0][0]
    diagnol1 << @board[1][1]
    diagnol1 << @board[2][2]
    
    diagnol2 << @board[2][0]
    diagnol2 << @board[1][1]
    diagnol2 << @board[0][2]

    if diagnol1.include?(included_piece) && !diagnol1.include?(not_included_piece) && diagnol1.compact.size == 2
      return diagnol1.index(nil), diagnol1.index(nil)
    end        

    if diagnol2.include?(included_piece) && !diagnol2.include?(not_included_piece) && diagnol2.compact.size == 2
      case diagnol2.index(nil)
        when 2 : row = 0
        when 1 : row = 1
        when 0 : row = 2
      end  
      return row, diagnol2.index(nil)
    end        
    return nil, nil
  end

  def computer_priortize_move
    corners = [[0,0],[0,2],[2,0],[2,2]]
    sides = [[1,0],[0,1],[1,2],[2,1]]
    
    corner_populated = false
    middle_populated = false
    side_populated = false

    corners.each do |corner|
      row = corner[0]
      column = corner[1]
      if @player_piece == @board[row][column]
        corner_populated = true
        break
      end
    end
    
    sides.each do |side|
      row = side[0]
      column = side[1]
      if @player_piece == @board[row][column]
        side_populated = true
        break
      end      
    end

    if @board[1][1] == @player_piece
      middle_populated = true
    end

    if corner_populated
      row, column = find_random_open_spot(sides)
      return row, column
    end

    if side_populated
      row = 1
      column = 1
      return row, column
    end

    if middle_populated
      row, column = find_random_open_spot(corners)
      return row, column
    end
  end

  def find_random_open_spot(spots)
    spots.reject! {|spot| @board[spot[0]][spot[1]] != nil }
    rand_num = rand(spots.size)
    spot = spots[rand_num]
    return spot[0], spot[1]
  end

  def row_match?
    @board.each do |row|
      return true if row == [X, X, X] || row == [O, O, O]
    end 
    return false
  end

  def column_match?
    0.upto(2) do |column|
      return true if @board[0][column] == X && @board[1][column] == X && @board[2][column] == X
      return true if @board[0][column] == O && @board[1][column] == O && @board[2][column] == O
    end
    return false
  end

  def diagnol_match?
    return true if (@board[0][0] == X && @board[1][1] == X && @board[2][2] == X)
    return true if (@board[0][2] == X && @board[1][1] == X && @board[2][0] == X)
    return true if (@board[0][0] == O && @board[1][1] == O && @board[2][2] == O)
    return true if (@board[0][2] == O && @board[1][1] == O && @board[2][0] == O)
    return false
  end

end


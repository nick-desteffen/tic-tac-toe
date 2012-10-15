require 'bundler'
Bundler.require

require 'tic_tac_toe'

describe TicTacToe do

  before(:each) do
    @ttt = TicTacToe.new
  end

  describe "initalize_pieces" do
    it "should set the player piece to x and the computer to o if the player chooses x" do
      @ttt.initalize_pieces("x")
      @ttt.player_piece.should == "x"
      @ttt.computer_piece.should == "o"
    end
    it "should set the player piece to o and the computer to x if the player chooses o" do
      @ttt.initalize_pieces("o")
      @ttt.player_piece.should == "o"
      @ttt.computer_piece.should == "x"      
    end
    it "should be case insensitive" do
      @ttt.initalize_pieces("O")
      @ttt.player_piece.should == "o"
    end
  end

  describe "valid_pieces?" do
    it "should be true if both pieces are valid" do
      @ttt.player_piece = "x"
      @ttt.computer_piece = "o"
      @ttt.valid_pieces?.should == true
    end
    it "should be false if one piece is not valid" do
      @ttt.player_piece = "B"
      @ttt.valid_pieces?.should == false      
    end
  end

  describe "row_match?" do
  	it "should be true if all values in row1 are the same" do
      @ttt.board = [['x', 'x', 'x'], nil, nil]
      @ttt.row_match?.should == true
  	end
    it "should be true if all values in row2 are the same" do
      @ttt.board = [nil, ['x', 'x', 'x'], nil]
      @ttt.row_match?.should == true
    end
    it "should be true if all values in row3 are the same" do
      @ttt.board = [nil, nil, ['x', 'x', 'x']]
      @ttt.row_match?.should == true
    end
    it "should be false if none of the rows are the same" do
      @ttt.board = [['x', 'x', 'o'], nil, nil]
      @ttt.row_match?.should == false
    end
  end

  describe "column_match?" do
    it "should be true if all the values in the first column are the same" do 
      @ttt.board = [['x', nil, nil], ['x', nil, nil], ['x', nil, nil]]
      @ttt.column_match?.should == true
    end
    it "should be true if all the values in the second column are the same" do 
      @ttt.board = [[nil, 'x', nil], [nil, 'x', nil], [nil, 'x', nil]]
      @ttt.column_match?.should == true
    end
    it "should be true if all the values in the third column are the same" do 
      @ttt.board = [[nil, nil, 'x'], [nil, nil, 'x'], [nil, nil, 'x']]
      @ttt.column_match?.should == true
    end
    it "should be false if none of the columns are the same" do 
      @ttt.board = [[nil, nil, 'x'], [nil, nil, 'x'], [nil, nil, 'o']]
      @ttt.column_match?.should == false    
    end
  end

  describe "diagnol_match?" do
    it "should be true if top left, center, and bottom right are the same" do
      @ttt.board = [['x', nil, nil],[nil, 'x', nil],[nil, nil, 'x']]
      @ttt.diagnol_match?.should == true
    end
    it "should be true if top right, center, and bottom left are the same" do
      @ttt.board = [[nil, nil, 'x'],[nil, 'x', nil],['x', nil, nil]]
      @ttt.diagnol_match?.should == true
    end
    it "should be false if there isn't a diagnol match" do 
      @ttt.board = [[nil, nil, 'x'],[nil, nil, nil],['x', nil, nil]]
      @ttt.diagnol_match?.should == false
    end
  end

  describe "parse_input" do
    it "should return a row and column" do
      @ttt.parse_input("1,2").should == [0, 1]
    end
  end

  describe "marker" do
    it "should return - if the spot on the board is nil" do
      @ttt.board[0][0] = nil
      @ttt.marker(0,0).should == "-"
    end
    it "should return the value on the spot if it is not nil" do 
      @ttt.board[0][0] = 'x'
      @ttt.marker(0,0).should == 'x'
    end
  end

  describe "empty_spot?" do
    it "should return true if the spot spot passed in is nil" do
      @ttt.board[0][0] = nil
      @ttt.empty_spot?(0,0).should == true
    end
    it "should return false if the spot passed in is not empty" do
      @ttt.board[0][0] = 'x'
      @ttt.empty_spot?(0,0).should == false
    end
  end

  describe "valid_move?" do
    it "should be true if the choice is not occupied already" do
      @ttt.board[0][0] = nil
      @ttt.valid_move?(0,0).should == true
    end
    it "should be false if the choice is already occupied" do
      @ttt.board[0][0] = 'x'
      @ttt.valid_move?(0,0).should == false
    end
    it "should be false if the row is > 3" do
      @ttt.valid_move?(4,1).should == false
    end
    it "should be false if the column is > 3" do
      @ttt.valid_move?(1,4).should == false
    end
  end

  describe "computer_fill_row_move" do
    it "should return the index to put a piece if the user is going to fill up a row" do
      @ttt.player_piece = 'x'
      @ttt.computer_piece = 'o'  

      @ttt.board = [['x', 'x', nil], 
                    ['o', nil, nil],
                    [nil, nil, nil]]
      @ttt.computer_fill_row_move(@ttt.player_piece, @ttt.computer_piece).should == [0, 2]

      @ttt.board = [[nil, 'x', 'x'], 
                    ['o', nil, nil],
                    [nil, nil, nil]]
      @ttt.computer_fill_row_move(@ttt.player_piece, @ttt.computer_piece).should == [0, 0]

      @ttt.board = [[nil, nil, nil], 
                    ['o', nil, nil],
                    ['x', nil, 'x']]
      @ttt.computer_fill_row_move(@ttt.player_piece, @ttt.computer_piece).should == [2, 1]
    end
    it "should return nil, nil if no rows need to be blocked" do
      @ttt.player_piece = 'x'
      @ttt.computer_piece = 'o'  
      @ttt.board = [[nil, nil, nil], 
                    ['o', 'x', nil],
                    ['x', nil, nil]]
      @ttt.computer_fill_row_move(@ttt.computer_piece, @ttt.player_piece).should == [nil, nil]      
    end
  end

  describe "computer_fill_column_move" do
    it "should return the index to put a piece if the user is going to fill up a column" do
      @ttt.player_piece = 'x'
      @ttt.computer_piece = 'o'  
      @ttt.board = [['x', nil, nil],
                ['x', 'o', nil],
                [nil, nil, nil]]
      @ttt.computer_fill_column_move(@ttt.player_piece, @ttt.computer_piece).should == [2,0]

      @ttt.board = [['o', 'x', nil],
                    [nil, 'x', nil],
                    [nil, nil, nil]]
      @ttt.computer_fill_column_move(@ttt.player_piece, @ttt.computer_piece).should == [2,1]

      @ttt.board = [['o', nil, 'x'],
                    [nil, nil, nil],
                    [nil, nil, 'x']]
      @ttt.computer_fill_column_move(@ttt.player_piece, @ttt.computer_piece).should == [1,2]

    end
    it "should return nil, nil if no columns need to be blocked" do
      @ttt.player_piece = 'x'
      @ttt.computer_piece = 'o'  
      @ttt.board = [['x', nil, 'x'],
                    [nil, 'o', nil],
                    [nil, nil, nil]]
      @ttt.computer_fill_column_move(@ttt.player_piece, @ttt.computer_piece).should == [nil, nil]
    end
  end

  describe "computer_fill_diagnol_move" do

    it "should return the index to put a piece if the user is going to fill up a diagnol row" do
      @ttt.player_piece = 'x'
      @ttt.computer_piece = 'o'  
      @ttt.board = [['x', nil, nil],
                    ['o', 'x', nil],
                    [nil, nil, nil]]
      @ttt.computer_fill_diagnol_move(@ttt.player_piece, @ttt.computer_piece).should == [2,2]

      @ttt.board = [[nil, nil, 'x'],
                    ['o', 'x', nil],
                    [nil, nil, nil]]
      @ttt.computer_fill_diagnol_move(@ttt.player_piece, @ttt.computer_piece).should == [2,0]

    end

    it "should return nil, nil if the diagnol rows don't need to be blocked" do
      @ttt.player_piece = 'x'
      @ttt.computer_piece = 'o'  
      @ttt.board = [[nil, 'x', nil],
                    ['o', 'x', nil],
                    [nil, nil, nil]]
      @ttt.computer_fill_diagnol_move(@ttt.computer_piece, @ttt.player_piece).should == [nil, nil]
    end

  end

  describe "board_full?" do
    it "should be true if all spots are filled" do
      @ttt.board = [['x', 'o', 'x'],
                    ['o', 'x', 'o'],
                    ['o', 'x', 'o']]
      @ttt.board_full?.should == true
    end
    it "should be false if not all spots are filled" do
      @ttt.board = [['x', nil, nil],
                    [nil, nil, nil],
                    [nil, nil, nil]]
      @ttt.board_full?.should == false
    end
  end

  describe "computer_choice" do
    it "should go for the win if it can match a row" do
      @ttt.player_piece = 'x'
      @ttt.computer_piece = 'o'  

      @ttt.board = [[nil, 'o', 'o'],
                    ['x', nil, nil],
                    [nil, nil, nil]]
      @ttt.computer_choice.should == [0,0]

      @ttt.board = [[nil, 'x', 'x'],
                    ['o', nil, 'o'],
                    [nil, nil, 'x']]
      @ttt.computer_choice.should == [1,1]
    end

    it "should go for the win if it can match on a column" do
      @ttt.player_piece = 'x'
      @ttt.computer_piece = 'o'  

      @ttt.board = [[nil, 'x', 'o'],
                    ['x', nil, nil],
                    [nil, 'x', 'o']]
      @ttt.computer_choice.should == [1,2]

      @ttt.board = [[nil, 'x', 'o'],
                    ['x', nil, 'o'],
                    ['x', nil, nil]]
      @ttt.computer_choice.should == [2,2]    
    end

    it "should go for the win if it can match on a diagnol" do
      @ttt.player_piece = 'x'
      @ttt.computer_piece = 'o'  

      @ttt.board = [['o', 'x', nil],
                    [nil, nil, nil],
                    ['x', 'x', 'o']]
      @ttt.computer_choice.should == [1,1]

      @ttt.board = [['x', 'x', 'o'],
                    ['x', 'o', nil],
                    [nil, nil, nil]]
      @ttt.computer_choice.should == [2,0]    
    end

    it "should block the player if they are one away from a row match" do
      @ttt.player_piece = 'x'
      @ttt.computer_piece = 'o'  

      @ttt.board = [[nil, 'x', 'x'],
                    ['o', nil, nil],
                    [nil, nil, nil]]
      @ttt.computer_choice.should == [0,0]

      @ttt.board = [['x', nil, 'x'],
                    ['o', nil, nil],
                    [nil, nil, nil]]
      @ttt.computer_choice.should == [0,1]

      @ttt.board = [['x', 'x', nil],
                    ['o', nil, nil],
                    [nil, nil, nil]]
      @ttt.computer_choice.should == [0,2]

      @ttt.board = [['o', nil, nil],
                    [nil, nil, nil],
                    [nil, 'x', 'x']]
      @ttt.computer_choice.should == [2,0]

      @ttt.board = [['o', nil, nil],
                    [nil, nil, nil],
                    ['x', nil, 'x']]
      @ttt.computer_choice.should == [2,1]

      @ttt.board = [['o', nil, nil],
                    [nil, nil, nil],
                    ['x', 'x', nil]]
      @ttt.computer_choice.should == [2,2]
    end

    it "should block the player if they are one away from a column match" do
      @ttt.player_piece = 'x'
      @ttt.computer_piece = 'o'  

      @ttt.board = [['x', 'o', nil],
                    [nil, nil, nil],
                    ['x', nil, nil]]
      @ttt.computer_choice.should == [1,0]    

      @ttt.board = [['x', 'o', nil],
                    ['x', nil, nil],
                    [nil, nil, nil]]
      @ttt.computer_choice.should == [2,0]

      @ttt.board = [['o', nil, nil],
                    [nil, 'x', nil],
                    [nil, 'x', nil]]
      @ttt.computer_choice.should == [0,1]    

      @ttt.board = [['o', 'x', nil],
                    [nil, nil, nil],
                    [nil, 'x', nil]]
      @ttt.computer_choice.should == [1,1]    

      @ttt.board = [['o', nil, 'x'],
                    [nil, nil, nil],
                    [nil, nil, 'x']]
      @ttt.computer_choice.should == [1,2]    

      @ttt.board = [['o', nil, 'x'],
                    [nil, nil, 'x'],
                    [nil, nil, nil]]
      @ttt.computer_choice.should == [2,2]
    end

    it "should block the player if they are one away from a diagnol match" do
      @ttt.player_piece = 'x'
      @ttt.computer_piece = 'o'  

      @ttt.board = [[nil, 'o', nil],
                    [nil, 'x', nil],
                    [nil, nil, 'x']]
      @ttt.computer_choice.should == [0,0]          

      @ttt.board = [['x', 'o', nil],
                    [nil, nil, nil],
                    [nil, nil, 'x']]
      @ttt.computer_choice.should == [1,1]          

      @ttt.board = [['x', 'o', nil],
                    [nil, 'x', nil],
                    [nil, nil, nil]]
      @ttt.computer_choice.should == [2,2]

      @ttt.board = [[nil, 'o', 'x'],
                    [nil, 'x', nil],
                    [nil, nil, nil]]
      @ttt.computer_choice.should == [2,0]          
    end
  end

end


# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  All_My_Pieces = [
               rotations([[0, 0], [1, 0], [-1, 0], [0, -1], [-1, -1]]), # Enhanced1
               [[[0, 0], [-1, 0], [1, 0], [2, 0], [-2, 0]], # Enhanced2
               [[0, 0], [0, -1], [0, 1], [0, 2], [0, -2]]],
               rotations([[0, 0], [1, 0], [0, -1]]) # Enhanced3
               ] + All_Pieces 

  # your enhancements here
  def self.next_piece (board)
    if (board.cheat && !board.score.nil? && board.score >= 100)
      board.cheat = false
      board.setScore(board.score - 100)
      MyPiece.new([[[0, 0]]], board) # just a single cube to drop now
    else
      board.cheat = false
      MyPiece.new(All_My_Pieces.sample, board)
    end
  end
end

class MyBoard < Board
  # your enhancements here
  def initialize (game)
    super(game)
    @cheat = false
    @current_block = MyPiece.next_piece(self)
  end

  def next_piece_cheat
    @cheat = true
  end

  def setScore (score)
    @score = score
  end

  # gets the next piece
  def next_piece
    @current_block = MyPiece.next_piece(self)
    @current_pos = nil
  end

  # rotates the current piece 180deg 
  def rotate_180
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2) #Need access to current block variable
    end
    draw
  end

  #override this method because we have new pieces that have more or less than 4 blocks
  def store_current 
    locations = @current_block.current_rotation 
    displacement = @current_block.position
    locations.each_index{|index| 
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
      @current_pos[index] 
    }
    remove_filled
    @delay = [@delay - 2, 80].max 
  end

  attr_accessor :cheat #expose a getter and setter for cheat variable
end

class MyTetris < Tetris
  # your enhancements here
  # just override the definitiion for key_bindings and also call super to set bindings in base class
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings  
    super
    @root.bind('u', proc {@board.rotate_180})
    @root.bind('c', proc {@board.next_piece_cheat})
  end
end
def reload
	reload = load 'tic_tac_toe.rb'
end

p "Type 'start_game' if you would like to play."
def start_game
	x = Game.new
	x.new_game_setup
end

class Player
	attr_reader :player1, :player2, :current_player, :score
	def initialize
		@player1 = 1
		@player2 = 2
		@current_player = 1
		@score = [0, 0, 0]
	end

	def switch_player
		if @current_player == @player1
			@current_player = @player2
		elsif @current_player == @player2
			@current_player = @player1
		end
	end			
end

class Board
	attr_accessor :board_values

	def initialize(board_values)
		@board_values = board_values
		@board_output = []
		@players = Player.new
	end

	def values_to_output
		@board_output = @board_values.map do |s| 
			if s == @players.player1
				s = "[X]"
			elsif s == @players.player2
				s = "[O]"
			else
				s = "[ ]"
			end
		end
	end

	def draw_board
		values_to_output
		@board_output.each_with_index do |s, index|
			if index == 2 || index == 5 || index == 8
				print "#{s}" + "\n"
			else 
				print s
			end
		end
	end

	def lines
		lines = { :top_r => @board_values.values_at(0,1,2),
		:middle_r => @board_values.values_at(3,4,5),
		:bottom_r => @board_values.values_at(6,7,8),
		:left_c => @board_values.values_at(0,3,6),
		:middle_c => @board_values.values_at(1,4,7),
		:right_c => @board_values.values_at(2,5,8),
		:diag_top_left => @board_values.values_at(0,4,8),
		:diag_top_right => @board_values.values_at(2,4,6)
		 }
	end
end

class Game
	attr_accessor :players, :score
	def initialize
		@board = Board.new([0,0,0,0,0,0,0,0,0])
		@players = Player.new
		@score = @players.score
	end

	def current_board_values
		current_board_values = @board.board_values
	end

	def current_board
		@current_board = @board.draw_board
	end

	def current_player
		@players.current_player
	end

	def turn
		current_board
		final_move = false
		until final_move == true
			puts "Player #{current_player}, choose a square:"
			selected_move = gets.chomp.to_i.abs
			if current_board_values[selected_move] != 0
				puts "Invalid move, please choose another square."
			else
				current_board_values[selected_move] = current_player
				current_board
				if win? == true || tie? == true
					final_move = true
					end_game
				else
					@players.switch_player
				end
			end
		end
	end

	def win?
		@board.lines.any? {|x, y| y == [1,1,1] || y ==[2,2,2] }
	end

	def tie?
		current_board_values.none? {|x| x == 0} && win? == false
	end

	def end_game
		if win?
			p "Player #{current_player} Wins!"
			score[current_player - 1] += 1 
		elsif tie?
			p "Tie game" 
			@score[-1] += 1
		end
		p @score
		replay
	end

	def score_reset
		@score = [0, 0, 0]
	end

	def board_reset
		@board.board_values = ([0,0,0,0,0,0,0,0,0])
	end

	def player_reset
		current_player = 0
	end

	def reset
		score_reset
		board_reset
		player_reset
	end

	def replay
		loop do
			p "Would you like to play again?"
			replay_ans = gets.chomp.downcase
			if replay_ans == "yes" || replay_ans == "y"
				new_game_setup
				break							
			elsif replay_ans == "no" || replay_ans == "n"
				reset
				new_game
				break								
			else
				current_board
			end
		end
	end

	def new_game
		board_reset
		loop do
			p "Type 'new game' if you would like to play."
			create_game = gets.chomp.downcase
			if (create_game == "newgame") || (create_game == "new_game") || (create_game == "new game") || (create_game == "new")
				new_game_setup
				break
			end
		end
	end

	def new_game_setup
		loop do
			p "Press 1 if vs Human. Press 2 if vs Computer."
			selection = gets.chomp.to_i
			if selection == 1	
				if tie? == true || @score == [0, 0, 0]
					p "Player 1 goes first"
					current_player = 1
					current_player
				else
					p "Loser goes first."
					@players.switch_player
				end
				board_reset
				self.turn
				break	
			elsif selection == 2
				p "Will deploy later"	
			else
				p "Invalid, please press 1 or 2"
			end
		end
	end
end

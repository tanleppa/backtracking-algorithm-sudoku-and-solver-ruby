require "./board.rb"

class Game
    def initialize(board)
        @board = board
    end

    def play
        until @board.solved?
            clear_and_render_board
            position = ask_user_for_position

            if position == "solve"
                solve_using_backtrack
                break
            end
            
            value = ask_user_for_value
            assign_value_to_a_correct_position(position, value)
        end
        clear_and_render_board
        puts "Sudoku Solved!"
    end

    private

    def solve_using_backtrack
        @board.clear_user_inputs
        if @board.solve
            puts "Solved using the backtrack algorithm"
        else
            puts "Backtrack algorithm found no solutions"
        end
    end

    def clear_and_render_board
        system("clear")
        @board.render
        puts
    end

    def assign_value_to_position(pos, value)
        @board[pos] = value
    end

    def assign_value_to_a_correct_position(pos, value)
        begin
            assign_value_to_position(pos, value)
        rescue
            puts "INVALID POSITION"
            sleep(1)
        end
    end

    def ask_user_for_position
        puts "Enter a position (e.g. \'2,3\'):"
        input = gets.chomp
        if input.downcase == "solve"
            return "solve"
        end
        [input.split(",")[0].to_i, input.split(",")[1].to_i,]
    end

    def ask_user_for_value
        puts "Enter a value (0 = unassigned):"
        input = gets.chomp
        input.to_i
    end
end

if __FILE__ == $PROGRAM_NAME
    puts "Enter the name of the txt-file you'd like to solve in the puzzles directory:"
    input = gets.chomp
    Game.new(Board.new(input)).play
end
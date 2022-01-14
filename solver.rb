class SudokuSolver
    def initialize(board)
        @board = board
    end

    def solve
        (0...81).each do |cell|
            row = cell / 9
            col = cell % 9
            if @board[[row, col]] == 0
                
            end
        end
    end
end
require "./tile.rb"

class Board
    def self.from_file(file)
        grid = []
        File.readlines("./puzzles/#{file}.txt").each do |line|
            grid << Array.new
            line.chomp.each_char do |char|

                if char == "0"
                    char_is_given = false
                else
                    char_is_given = true
                end

                grid[-1] << Tile.new(char.to_i, char_is_given)
            end
        end
        return grid
    end

    def initialize(file_name)
        @grid = Board.from_file(file_name)
    end

    def [](pos)
        row, col = pos
        @grid[row][col]
    end
    
    def []=(pos, value)
        row, col = pos
        tile = @grid[row][col]
        tile.assign_value(value)
    end

    def render
        @grid.each do |row|
            puts
            row.each do |tile|
                print tile.value_to_s
                print " "
            end
        end
    end

    def solved?
        rows_solved? && cols_solved? && squares_solved?
    end

    def rows_solved?
        @grid.each do |row|
            num_counts = Hash.new(0)
            row.each do |tile|
                num_counts[tile.value] += 1
            end
            return false if num_counts.any? { |k, v| v != 1 } || num_counts.has_key?(0)
        end
        true
    end

    def cols_solved?
        @grid.transpose.each do |row|
            num_counts = Hash.new(0)
            row.each do |tile|
                num_counts[tile.value] += 1
            end
            return false if num_counts.any? { |k, v| v != 1 } || num_counts.has_key?(0)
        end
        true
    end

    def check_square(row, col)
        lower_row = 3 * (row / 3)
        lower_col = 3 * (col / 3)
        upper_row = lower_row + 3
        upper_col = lower_col + 3

        num_counts = Hash.new(0)
        (lower_row...upper_row).each do |row|
            (lower_col...upper_col).each do |col|
                tile = self[[row, col]]
                num_counts[tile.value] += 1
            end
        end
        num_counts.all? { |k, v| v == 1 } && !num_counts.has_key?(0)
    end

    def squares_solved?
        check_square(0, 0) &&
        check_square(0, 3) &&
        check_square(0, 6) &&
        check_square(3, 0) &&
        check_square(3, 3) &&
        check_square(3, 6) &&
        check_square(6, 0) &&
        check_square(6, 3) &&
        check_square(6, 6)
    end

    def row_to_values(row_idx)
        values = []
        @grid[row_idx].each do |tile|
            values << tile.value
        end
        values
    end

    def col_to_values(col_idx)
        values = []
        @grid.transpose[col_idx].each do |tile|
            values << tile.value
        end
        values
    end

    def square_to_values(row, col)
        values = []

        lower_row = 3 * (row / 3)
        lower_col = 3 * (col / 3)
        upper_row = lower_row + 3
        upper_col = lower_col + 3

        (lower_row...upper_row).each do |row|
            (lower_col...upper_col).each do |col|
                tile = self[[row, col]]
                values << tile.value
            end
        end
        values
    end
    
    def clear_user_inputs
        @grid.each do |row|
            row.each do |tile|
                tile.assign_value(0) if tile.value != 0
            end
        end
    end

    def check_inclusion_in_rows_cols_squares(row, col, num)
        !row_to_values(row).include?(num) &&
        !col_to_values(col).include?(num) &&
        !square_to_values(row, col).include?(num)
    end

    def solve
        row = 0
        col = 0
        (0...81).each do |cell|
            row = cell / 9
            col = cell % 9
            if self[[row, col]].value == 0
                (1..9).each do |num|
                    if check_inclusion_in_rows_cols_squares(row, col, num)
                        self[[row, col]] = num
                        #show_algorithm
                        if solved?
                            return true
                        elsif solve
                            return true
                        end
                    end
                end
                break
            end
        end
        self[[row, col]] = 0
        false
    end

    def show_algorithm
        system("clear")
        render
        puts "\nSOLVING"
        sleep(0.005)
    end
end
require "colorize"

class Tile
    attr_reader :value, :given_tile

    def initialize(value, true_or_false)
        @value = value
        @given_tile = true_or_false
    end

    def value_to_s
        if @given_tile
            return @value.to_s.colorize(:red)
        elsif @value == 0
            return @value.to_s.colorize(:white)
        end
        @value.to_s.colorize(:green)
    end

    def assign_value(new_value)
        @value = new_value unless @given_tile
    end
end
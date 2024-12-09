require "bundler/setup"
Bundler.require(:default)

require "rspec/autorun" unless ENV["SKIP_TESTS"] || ENV["PART"]

def load_input(current_filename)
  File.read [__dir__, "/", File.basename(current_filename, ".rb"), ".txt"].join
end

class Grid
  class << self
    def from_text(input, factory)
      two_d_array = input.split("\n").map{|line| line.split("")}
      
      new(two_d_array, factory)
    end
  end

  def initialize(two_d_array, space_factory)
    @space_factory = space_factory
    @point_map = {}

    two_d_array.each_with_index do | row, row_index| 
      # Reverse so it's indexed like the x/y cartisian plane, 
      # with 0,0 at the lower left corner.
      y_coordinate = two_d_array.length - 1 - row_index

      row.each_with_index do |element, column_index| 
        x_coordinate = column_index 

        point = Point.new(x_coordinate, y_coordinate)

        @point_map[point] = @space_factory.for_marker(element)
      end
    end 
  end

  def fetch(point)
    @point_map.fetch(point, @space_factory.out_of_bounds)
  end

  def select(&block)
    @point_map.filter { |key, value| yield value }.keys
  end

  def set(point, value)
    @point_map[point] = @space_factory.for_marker(value)
  end
end

Point = Struct.new(:x, :y) do
  def +(other)
    Point.new(x + other.x, y + other.y)
  end

  def -(other)
    Point.new(x - other.x, y - other.y)
  end
end

#!/usr/bin/env ruby

require_relative "./shared"


INPUT = load_input(ENV["INPUT"] || __FILE__).chomp

class LabMap
  attr_reader :starting_point

  def initialize(two_d_array)
    @grid = {}
    @starting_point = nil

    two_d_array.each_with_index do | row, row_index| 
      # Reverse so it's indexed like the normal cartisian plane, starting in
      # the top left corner.
      y_coordinate = two_d_array.length - 1 - row_index

      row.each_with_index do |element, column_index| 
        x_coordinate = column_index 
        
        point =  MapLocation.for_marker(element)
        @grid[[x_coordinate,y_coordinate]] = point

        if element == "^" 
          @starting_point = [x_coordinate, y_coordinate]
        end
      end
    end 
  end

  def add_obstacle(coordinates)
    @grid[coordinates] = MapLocation.for_marker("#") unless coordinates == @starting_point
  end

  def all_locations
    @grid.keys
  end

  def fetch(coordinates)
    @grid.fetch(coordinates, MapLocation.out_of_bounds)
  end

  def visited_locations
    @grid.filter_map { |coordinates, point| 
      coordinates if point.visited 
    }
  end
end

class MapLocation
  def self.for_marker(map_marker)
    case map_marker 
    when "#"
      Obstacle.new
    when "."
      Space.new
    when "^"
      Space.new(visited: true)
    else 
      raise "Unsupported map marker: #{map_marker}"
    end 
  end

  def self.out_of_bounds
    OutOfBounds.new
  end
end

class OutOfBounds
  def visit(**kwargs)
    throw :end, :out_of_bounds
  end
end

class Obstacle
  attr_reader :visited
  def visit(**kwargs)
    false
  end
end

class Space
  CYCLE_LIMIT = 4

  attr_reader :visited
  def initialize(visited: false)
    @visited = visited
    @treadmarks = Set.new 
  end

  def visit(direction: nil)
    throw(:end, :cycle_detected) if @treadmarks.include?(direction)
    @treadmarks << direction if direction

    @visited = true
  end
end

class Guard
  DIRECTIONS = {up: [0,1], right: [1,0], down: [0,-1], left: [-1,0]}

  def initialize(map)
    @direction = :up
    @location = map.starting_point
    @map = map
  end

  def move
    if @map.fetch(next_move).visit(direction: @direction)
      @location = next_move 
    else
      turn_right    
    end
  end
  
  def next_move
    @location.dup.zip(DIRECTIONS[@direction].dup).map(&:sum)
  end

  def turn_right
    @direction = case @direction
                 when :up
                   :right
                 when :left
                   :up
                 when :down
                   :left
                 when :right
                   :down
                 end
  end
end

def part_one(input)
  input = input.split("\n").map{|line| line.split("")}
  
  map = LabMap.new(input)

  guard = Guard.new(map)

  catch(:end) do
    while
      guard.move
    end
  end

  map.visited_locations.count
end

def part_two(input)
  input = input.split("\n").map{|line| line.split("")}
  
  map = LabMap.new(input)

  guard = Guard.new(map)

  catch(:end) do
    while
      guard.move
    end
  end

  obstacle_positions = map.visited_locations
  obstacle_positions.delete(map.starting_point)

  possible_cycle_count = 0

  obstacle_positions.each do |obstacle_position|
    map = LabMap.new(input)
    map.add_obstacle(obstacle_position)
    guard = Guard.new(map)

    end_condition = catch(:end) do
      while
        guard.move
      end
    end

    possible_cycle_count +=1 if end_condition == :cycle_detected
  end

  possible_cycle_count
end

puts "Solution for part one: #{part_one(INPUT).inspect}" if ENV["PART"] == "1"
puts "Solution for part two: #{part_two(INPUT).inspect}" if ENV["PART"] == "2"

RSpec.describe "the solution" do
  describe "#part_one" do
    let(:input) { File.open('06sample.txt').read }
    subject{ part_one(input) }
    
    it{is_expected.to eq(41)}

    it "does a simple one" do
      input = ".#.\n...\n.^."   
      expect(part_one(input)).to eq 3
    end
  end

  describe "#part_two" do
    let(:input) { File.open('06sample.txt').read }
    subject{ part_two(input) }
    
    it{is_expected.to eq(6)}
  end
end

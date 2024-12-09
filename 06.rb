#!/usr/bin/env ruby

require_relative "./shared"


INPUT = load_input(ENV["INPUT"] || __FILE__).chomp

class LabMap
  attr_reader :starting_point

  def initialize(raw_text)
    @raw_text = raw_text 
    @grid = Grid.from_text(raw_text, MapLocation) 
    @starting_point = @grid.select { |value| value.visited  }.first
  end
  
  def reset() @grid = Grid.from_text(@raw_text, MapLocation) end

  def add_obstacle(point)
    @grid.set(point, "#")
  end

  def fetch(point)
    @grid.fetch(point)
  end

  def visited_locations
    @grid.select { |space| 
      space.visited 
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
  DIRECTIONS = {up: Point.new(0,1), right: Point.new(1,0), down: Point.new(0,-1), left: Point.new(-1,0)}

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
    DIRECTIONS[@direction] + @location
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
    map.reset
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

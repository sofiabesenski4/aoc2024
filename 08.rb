#!/usr/bin/env ruby

require_relative "./shared"

INPUT = load_input(ENV["INPUT"] || __FILE__).chomp

def part_one(input)
  map = Grid.from_text(input, CityMapLegend.new)

  antennae = map.select{_1.emit_frequency}
end

def part_two(input)
end


class CityMapLegend
  def initialize
    @markers = Hash(Antennae)
    @markers["."] = Space
  end

  def for_marker(marker)
    @markers[marker].new(marker)
  end

  def markers
    @markers.keys
  end

  def out_of_bounds
    OutOfBounds 
  end
end

class Space
  def initialize(**kwargs)
  end

  def emit_frequency
    nil
  end

  def resonates?
    true
  end
end

class Antenna
  def initialize(frequency)
    @frequency = frequency 
  end

  def emit_frequency
    @frequency
  end

  def resonates?
    true
  end
end

class OutOfBounds
  def self.resonates?
    false
  end
end

puts "Solution for part one: #{part_one(INPUT).inspect}" if ENV["PART"] == "1"
puts "Solution for part two: #{part_two(INPUT).inspect}" if ENV["PART"] == "2"

RSpec.describe "the solution" do
  describe "#part_one" do
    let(:input) { File.open('08sample.txt').read }
    subject{ part_one(input) }

    it {is_expected.to eq(14)}
  end

  describe "#part_two" do
    let(:input) { File.open('sample.txt').read }
    subject{ part_two(input) }
    
    it{is_expected.to eq(6)}
  end
end

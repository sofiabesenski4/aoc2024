#!/usr/bin/env ruby

require_relative "./shared"

INPUT = load_input(__FILE__).chomp

def part_one(input)
end

def part_two(input)
end

puts "Solution for part one: #{part_one(INPUT).inspect}" unless ENV["PART"] == "2"
puts "Solution for part two: #{part_two(INPUT).inspect}" unless ENV["PART"] == "1"

RSpec.describe "the solution" do
  describe "#part_one" do
    subject { part_one input }
  end

  describe "#part_two" do
    subject { part_two input }
  end
end

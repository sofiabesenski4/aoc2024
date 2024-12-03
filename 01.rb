#!/usr/bin/env ruby

require_relative "./shared"

INPUT = load_input(ENV["INPUT"] || __FILE__).chomp

def diff(a, b)
  (a - b).abs
end

def part_one(input)
  list_1 = []
  list_2 = []

  input.split("\n").each do |pair|
    first_list_element, second_list_element = pair.split

    list_1 << first_list_element.to_i
    list_2 << second_list_element.to_i
  end

  list_1.sort.zip(list_2.sort).sum { |first, second|
    diff(first,second)
  }
end

def part_two(input)
  list_1 = []
  list_2 = []

  input.split("\n").each do |pair|
    first_list_element, second_list_element = pair.split

    list_1 << first_list_element.to_i
    list_2 << second_list_element.to_i
  end
  
  multipliers = list_2.tally

  list_1.sum { _1 * multipliers.fetch(_1, 0) }
end

puts "Solution for part one: #{part_one(INPUT).inspect}" unless ENV["PART"] == "2"
puts "Solution for part two: #{part_two(INPUT).inspect}" unless ENV["PART"] == "1"

RSpec.describe "the solution" do
  describe "#part_one" do
    subject { part_one input }

    let(:input) { "1   3\n5   2" }

    it {is_expected.to eq 3}
  end

  describe "#part_two" do
    subject { part_two input }

    let(:input) { "2   5\n2   2\n3   6\n3   2"}

    it { is_expected.to eq 8 }
  end
end

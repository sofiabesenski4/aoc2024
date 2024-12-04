#!/usr/bin/env ruby

require_relative "./shared"

INPUT = load_input(ENV["INPUT"] || __FILE__).chomp

def within_diff?(a, b)
  ((a - b).abs < 4) && a != b
end

def ordered?(list:, reverse:)
  reverse ? list.sort.reverse == list : list.sort == list
end

def part_one(input)
  input.split("\n").sum { | report |
    report = report.split.map!{_1.to_i}

    safe = 1

    safe = 0 unless (ordered?(list: report, reverse: true) || ordered?(list: report, reverse: false))

    report.each_cons(2){ |a, b| safe = 0 unless within_diff?(a,b) }

    safe
  } 
end

def part_two(input)
end

puts "Solution for part one: #{part_one(INPUT).inspect}" unless ENV["PART"] == "2"
puts "Solution for part two: #{part_two(INPUT).inspect}" unless ENV["PART"] == "1"

RSpec.describe "the solution" do
  describe "#part_one" do
    subject { part_one(input) }
    let(:input) { "1 3 5 7\n4 5 1 0\n9 5 4 1\n9 8 7 6" }

    it "" do
        binding.pry
    end
    it {is_expected.to eq(2)}
  end

  describe "#part_two" do
  end
end
   

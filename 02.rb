#!/usr/bin/env ruby

require_relative "./shared"

INPUT = load_input(ENV["INPUT"] || __FILE__).chomp

def within_diff?(a, b)
  ((a - b).abs < 4) && a != b
end

def ordered?(list:, reverse:)
  reverse ? list.sort.reverse == list : list.sort == list
end

def check_report(report)
    safe = 1

    safe = 0 unless (ordered?(list: report, reverse: true) || ordered?(list: report, reverse: false))

    report.each_cons(2){ |a, b| safe = 0 unless within_diff?(a,b) }

    safe
end

def part_one(input)
  input.split("\n").sum { | report |
    check_report(report.split.map!{_1.to_i})
  } 
end

def part_two(input)
  input.split("\n").sum { | report |
    report = report.split.map(&:to_i)

    report.combination(report.length - 1)
      .any?{ |report_subset| check_report(report_subset) == 1 } ? 1 : 0
  }
end

puts "Solution for part one: #{part_one(INPUT).inspect}" unless ENV["PART"] == "2"
puts "Solution for part two: #{part_two(INPUT).inspect}" unless ENV["PART"] == "1"

RSpec.describe "the solution" do
  describe "#part_one" do
    subject { part_one(input) }
    let(:input) { "1 3 5 7\n4 5 1 0\n9 5 4 1\n9 8 7 6" }

    it {is_expected.to eq(2)}
  end

  describe "#part_two" do
    it "correctly marks a report as safe" do
      expect(part_two("1 3 5 7")).to eq(1)
    end

    it "will recognize an unsafe report" do
      expect(part_two("10 5 1")).to eq(0)
    end
  end
end
   

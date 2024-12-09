#!/usr/bin/env ruby

require_relative "./shared"

INPUT = load_input(ENV["INPUT"] || __FILE__).chomp

 def part_one(input)
end

def part_two(input)
end

puts "Solution for part one: #{part_one(INPUT).inspect}" if ENV["PART"] == "1"
puts "Solution for part two: #{part_two(INPUT).inspect}" if ENV["PART"] == "2"

RSpec.describe "the solution" do
  describe "#part_one" do
    let(:input) { File.open('sample.txt').read }
    subject{ part_one(input) }
  end

  describe "#part_two" do
    let(:input) { File.open('sample.txt').read }
    subject{ part_two(input) }
    
    it{is_expected.to eq(6)}
  end
end


#!/usr/bin/env ruby

require_relative "./shared"

INPUT = load_input(ENV["INPUT"] || __FILE__).chomp


def part_one(input)
  sum = 0

  while
    match = input.match(/mul\((\d{1,3}),(\d{1,3})\)(.*)/)
    
    break unless match

    first = match[1].to_i
    second = match[2].to_i
    
    sum = sum + (first * second)

    input = match[3]
  end

  sum
end

def part_two(input)
end

puts "Solution for part one: #{part_one(INPUT).inspect}" unless ENV["PART"] == "2"
# puts "Solution for part two: #{part_two(INPUT).inspect}" unless ENV["PART"] == "1"

RSpec.describe "the solution" do
  describe "#part_one" do
    let(:input) {"xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"}
    subject {  part_one(input)}
    
    it {is_expected.to eq 161}

    it "recognizes up to 3 digits" do
      expect(part_one("mul(100,300)")).to eq 30000
    end

    it "" do
      expect(part_one("mul(100,300)")).to eq 30000
    end
  end

  describe "#part_two" do
  end
end
   


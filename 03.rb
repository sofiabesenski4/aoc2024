#!/usr/bin/env ruby

require_relative "./shared"

INPUT = load_input(ENV["INPUT"] || __FILE__).chomp


def part_one(input)
  sum = 0

  input = input.gsub("\n"," ")

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
  sum = 0

  input = input.gsub("\n"," ")

  while input && input != ""
    stop_index = input.index("don't()")

    sum += part_one(input[...stop_index])

    input = input[stop_index + 7..]

    if (start_index = input.index("do()"))
      input = input[input.index("do()") + 4..]
    else
      break
    end
  end

  sum
end

# puts "Solution for part one: #{part_one(INPUT).inspect}" unless ENV["PART"] == "2"
puts "Solution for part two: #{part_two(INPUT).inspect}" unless ENV["PART"] == "1"

RSpec.describe "the solution" do
  describe "#part_one" do
    let(:input) {"xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"}
    subject {  part_one(input)}
    
    it {is_expected.to eq 161}

    it "recognizes up to 3 digits" do
      expect(part_one("mul(100,300)")).to eq 30000
    end

    it "handles newlines" do
      expect(part_one("mul(1,3)\nmul(2,5)")).to eq 13
    end

    it "handles back to back muls" do
      expect(part_one("mul(1,3)mul(2,5s)")).to eq 13
    end
    
    it "handles garbage in between muls" do
      expect(part_one('%&*&%\mul(1,3)48skjmul(fjhlkdjmulmul(2,5)')).to eq 13
    end
    
    it "recognizes parenthesis" do
      expect(part_one("mul[1,3]mul(2,5)")).to eq 10
    end

    it "will not count more than 3 digits" do
      expect(part_one("mul(100,3000)")).to eq 0 
    end

    it "will not include negative numbers" do
      expect(part_one("mul(-1,3)")).to eq 0
    end
  end

  describe "#part_two" do
    let(:input) {"don't()mul(100,100)jfkldajflsakdo()xmul(2,4)%&don't()mul(100,100)do()mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"}
    subject {  part_two(input)}
    
    it {is_expected.to eq 161}
  end
end
   


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
    let(:input) { "47078   87818\n99261   15906\n44723   23473\n87598   26876" }

    it 'returns a number' do
      expect(subject).to be_a(Integer)
    end
  end

  describe "#part_two" do
    subject { part_two input }
  end
end

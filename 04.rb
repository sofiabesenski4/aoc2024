#!/usr/bin/env ruby

require_relative "./shared"

INPUT = load_input(ENV["INPUT"] || __FILE__).chomp

class WordSearch
  def initialize(two_d_array)
    @elements = {}

    two_d_array.each_with_index { | row, row_index| 
      row.each_with_index{|element, column_index| 
        @elements[[row_index,column_index]] = element 
      }
    }
  end

  def find_all_letter_coordinates(letter)
    coordinates = []
    @elements.each { |key, value| 
      coordinates.push key if value == letter
    }

    coordinates
  end

  def check_for_match(coordinates, substring, translation)
    return 1 if substring == ""

    if @elements[move(coordinates, translation)] == substring[0]
      check_for_match(move(coordinates, translation), substring[1..], translation)
    else
      return 0
    end
  end

  private

  def move(coordinates, translation)
    coordinates.zip(translation).map(&:sum)
  end
end

def part_one(input)
  target = "XMAS"
  letters_grid = input.split("\n").map{|line| line.split("")}
  
  word_search = WordSearch.new(letters_grid)
  starting_points = word_search.find_all_letter_coordinates(target[0])

  starting_points.sum do |starting_point|
    [-1,-1,0,0,1,1].permutation(2).uniq.map do | direction |
      word_search.check_for_match(starting_point, target[1..], direction)
    end.sum
  end
end

def part_two(input)
  target = "XMAS"
  letters_grid = input.split("\n").map{|line| line.split("")}
  
  word_search = WordSearch.new(letters_grid)
  starting_points = word_search.find_all_letter_coordinates("A")

  starting_points.sum do |starting_point|
    first_mas =  word_search.check_for_match(starting_point, "S", [1,1]) == 1 \
      && word_search.check_for_match(starting_point, "M", [-1,-1]) == 1 ||
      word_search.check_for_match(starting_point, "S", [-1,-1]) == 1 \
      && word_search.check_for_match(starting_point, "M", [1,1]) == 1

    second_mas = word_search.check_for_match(starting_point, "S", [1,-1]) == 1 \
      && word_search.check_for_match(starting_point, "M", [-1,1]) == 1 ||
      word_search.check_for_match(starting_point, "S", [-1,1]) == 1 \
      && word_search.check_for_match(starting_point, "M", [1,-1]) == 1

    first_mas && second_mas ? 1 : 0
  end
end

# puts "Solution for part one: #{part_one(INPUT).inspect}" unless ENV["PART"] == "2"
puts "Solution for part two: #{part_two(INPUT).inspect}" unless ENV["PART"] == "1"

RSpec.describe "the solution" do
  describe "#part_one" do
    let(:input) { 
      "MMMSXXMASM\nMSAMXMSMSA\nAMXSXMAAMM\nMSAMASMSMX\nXMASAMXAMM\nXXAMMXXAMA\nSMSMSASXSS\nSAXAMASAAA\nMAMMMXMMMM\nMXMXAXMASX"
    }

    subject { part_one(input)}

    it {is_expected.to eq 18}

    it "will find the simple case" do
      input = "XMAS"

      expect(part_one(input)).to eq(1)
    end

    it "will find diagonal" do
      input = "X...\n.M..\n..A.\n...S"
      expect(part_one(input)).to eq(1)
    end
  end

  describe "#part_two" do
  end
end
   



#!/usr/bin/env ruby

require_relative "./shared"

INPUT = load_input(ENV["INPUT"] || __FILE__).chomp

class RuleSet
  def initialize(input)
    @rule_set = {}
    
    input.split("\n").map{|pair| pair.split("|")}.each do |target, comes_before|
      @rule_set[target] ? @rule_set[target].append(comes_before) && 
        @rule_set[target].uniq! : @rule_set[target] = [comes_before]
      end
  end

  def get_followers(target)
    @rule_set[target]
  end
end

class UpdateValidator
  def initialize(rules)
    @rules = rules
  end

  def valid?(update_sequence)
    return true if update_sequence.empty?

    target = update_sequence[-1]
    before_target = update_sequence[...-1]

    if @rules.get_followers(target) && @rules.get_followers(target).intersect?(before_target)
      return false
    else
      return valid?(update_sequence[...-1])
    end
  end

  def make_valid(update_sequence)
    make_valid_recurse(update_sequence, [])
  end

  private

  def make_valid_recurse(update_sequence, new_sequence) 
    return new_sequence if update_sequence.empty?
    target = update_sequence[0]

    index = new_sequence.length

    while new_sequence[...index].intersect?(@rules.get_followers(target) || [])
      index -= 1
    end

    make_valid_recurse(update_sequence[1...], new_sequence.insert(index,target)) 
  end
end

def part_one(input)
  rules_updates = input.split("\n\n")

  rule_set = RuleSet.new(rules_updates[0])

  update_validator = UpdateValidator.new(rule_set)
  updates = rules_updates[1]

  updates.split("\n").sum { |instructions|
    instructions = instructions.split(",")
    update_validator.valid?(instructions) ? instructions[instructions.length/2].to_i : 0
  }
end

def part_two(input)
  rules_updates = input.split("\n\n")

  rule_set = RuleSet.new(rules_updates[0])
  update_validator = UpdateValidator.new(rule_set)


  updates = rules_updates[1]

  updates.split("\n").sum { |instructions|
    instructions = instructions.split(",")
    update_validator.valid?(instructions) ? 0 : update_validator.make_valid(instructions)[instructions.length / 2].to_i
  }
end

puts "Solution for part one: #{part_one(INPUT).inspect}" unless ENV["PART"] == "2"
puts "Solution for part two: #{part_two(INPUT).inspect}" unless ENV["PART"] == "1"

RSpec.describe "the solution" do
  describe "#part_one" do
    let(:input) { File.open('05sample1.txt').read } 
    subject { part_one(input)}

    it {is_expected.to eq(143)} 
  end

  describe "#part_two" do
    let(:input) { File.open('05sample1.txt').read } 
    subject { part_two(input)}

    it {is_expected.to eq(123)} 

    it "will do the simple thing" do
      input = "1|2\n2|3\n\n1,3,2\n"

      expect(part_two(input)).to eq(2)
    end
  end
end





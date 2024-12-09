require_relative "./shared"

RSpec.describe Grid do
  let(:input_array) { [['.','.','.'],['.','#','.'],['.','#','.']] }
  let(:grid) { described_class.new(input_array, space_factory) }
  let(:space_factory) { double "TestSpaceFactory" }

  before do
    allow(space_factory).to receive(:for_marker).with("."){"period"}
    allow(space_factory).to receive(:for_marker).with("#"){"hash"}
    allow(space_factory).to receive(:out_of_bounds)
  end

  describe "#fetch" do
    it "returns the value in a space" do
      point = Point.new(1,1)

      expect(grid.fetch(point)).to eq("hash")
    end

    it "uses the space factory to handle out of bounds" do
      point = Point.new(-1,-1)

      grid.fetch(point)

      expect(space_factory).to have_received(:out_of_bounds)
    end
  end

  describe "#select" do
    it "returns the spaces which evaluate the block as true for its value" do
      grid = described_class.new(input_array, space_factory)

      expect(grid.select { _1 == "hash" }.count).to eq 2
    end
  end

  describe "#set" do
    it "adds a point to the grid for the given marker" do
      grid = described_class.new(input_array, space_factory)

    end
  end
end 

RSpec.describe Point do
  describe "#+" do
    subject(:point) { described_class.new(2,2) }
    it "adds each coordinate" do
      other_point = Point.new(5, -3)

      expect(point + other_point).to have_attributes(x: 7, y: -1) 
    end
  end

  describe "#-" do
    subject(:point) { described_class.new(2,2) }
    it "subtracts each coordinate" do
       other_point = Point.new(5, -3)

       expect(point - other_point).to have_attributes(x: -3, y: 5) 
    end
  end
end


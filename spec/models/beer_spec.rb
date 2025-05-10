require 'rails_helper'

RSpec.describe Beer, type: :model do
  describe "is saved correctly" do
    let(:test_brewery) { Brewery.new name: "panimo", year: 2000 }
    let(:beer) { Beer.create name: "testibisse", style: "tyyli", brewery: test_brewery }

    it "with a proper name" do
      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end
    it "with a proper style" do
      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end
    it "with a proper brewery" do
      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end
  end

  it "is not saved without a name" do
    test_brewery = Brewery.new name: "panimo", year: 2000
    beer = Beer.create style: "tyyli", brewery: test_brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    test_brewery = Brewery.new name: "panimo", year: 2000
    beer = Beer.create name: "testibisse", brewery: test_brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end

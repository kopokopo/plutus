require 'spec_helper'

module Plutus
  describe Amount do
    let(:amount) { FactoryBot.build(:amount) }

    it "is not valid" do
      expect(amount).to be_invalid
    end
  end
end

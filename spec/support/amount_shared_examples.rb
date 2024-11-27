shared_examples_for 'a Plutus::Amount subtype' do |elements|
  let(:amount) { FactoryBot.build(elements[:kind]) }

  it "is valid" do
    expect(amount).to be_valid
  end
  
  it "should require an amount" do
    amount.amount = nil
    expect(amount).to be_invalid
  end

  it "should require a entry" do
    amount.entry = nil
    expect(amount).to be_invalid
  end
  
  it "should require an account" do
    amount.account = nil
    expect(amount).to be_invalid
  end
end

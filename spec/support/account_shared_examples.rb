shared_examples_for 'a Plutus::Account subtype' do |elements|
  let(:contra) { false }
  let(:account) { FactoryBot.create(elements[:kind], contra: contra) }

  describe "class methods" do
    it "has a balance that is a BigDecimal" do
      expect(account.class.balance).to be_kind_of(BigDecimal)
    end

    describe "trial_balance" do
      it "should raise NoMethodError" do
        expect { account.trial_balance }.to raise_error(NoMethodError)
      end
    end
  end

  describe "instance methods" do
    it "has a balance that is a BigDecimal" do
      expect(account.balance).to be_kind_of(BigDecimal)
    end

    it "responds to credit_entries" do
      expect(account).to respond_to(:credit_entries)
    end
    it "responds to credit_entries" do
      expect(account).to respond_to(:debit_entries)
    end
  end

  it "requires a name" do
    account.name = nil
    expect(account).to be_invalid
  end

  # Figure out which way credits and debits should apply
  if elements[:normal_balance] == :debit
    debit_condition = :>
    credit_condition = :<
  else
    credit_condition = :>
    debit_condition = :<
  end

  describe "when given a debit" do
    before { FactoryBot.create(:debit_amount, account: account) }
    it "has a balance that satisfies the debit condition" do
      expect(account.balance.send(debit_condition, 0)).to be true
    end

    describe "on a contra account" do
      let(:contra) { true }
      it "has a balance that satisfies the credit condition" do
        expect(account.balance.send(credit_condition, 0)).to be true
      end
    end
  end

  describe "when given a credit" do
    before { FactoryBot.create(:credit_amount, account: account) }
    it "has a balance that satisfies the credit condition" do
      expect(account.balance.send(credit_condition, 0)).to be true
    end

    describe "on a contra account" do
      let(:contra) { true }
      it "has a balance that satisfies the debit condition" do
        expect(account.balance.send(debit_condition, 0)).to be true
      end
    end
  end
end
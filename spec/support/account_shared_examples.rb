shared_examples_for 'a PlutusAccount subtype' do |elements|
  let(:contra) { false }
  let(:plutus_account) { FactoryGirl.create(elements[:kind], contra: contra)}
  subject { plutus_account }

  describe "class methods" do
    subject { plutus_account.class }
    its(:balance) { should be_kind_of(BigDecimal) }
    describe "trial_balance" do
      it "should raise NoMethodError" do
        lambda { subject.trial_balance }.should raise_error NoMethodError
      end
    end
  end

  describe "instance methods" do
    its(:balance) { should be_kind_of(BigDecimal) }

    it { should respond_to(:credit_transactions) }
    it { should respond_to(:debit_transactions) }
  end

  it "requires a name" do
    plutus_account.name = nil
    plutus_account.should_not be_valid
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
    before { FactoryGirl.create(:debit_amount, plutus_account: plutus_account) }
    its(:balance) { should be.send(debit_condition, 0) }

    describe "on a contra account" do
      let(:contra) { true }
      its(:balance) { should be.send(credit_condition, 0) }
    end
  end

  describe "when given a credit" do
    before { FactoryGirl.create(:credit_amount, plutus_account: plutus_account) }
    its(:balance) { should be.send(credit_condition, 0) }

    describe "on a contra account" do
      let(:contra) { true }
      its(:balance) { should be.send(debit_condition, 0) }
    end
  end
end

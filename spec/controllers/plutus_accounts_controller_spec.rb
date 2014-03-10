require 'spec_helper'

describe PlutusAccountsController do

  def mock_account(stubs={})
    @mock_account ||= mock_model(PlutusAccount, stubs)
  end

  describe "GET index" do
    it "assigns all plutus_accounts as @plutus_accounts" do
      ac = FactoryGirl.create(:liability)
      get :index
      assigns(:plutus_accounts).should == [ac]
    end
  end

  describe "GET show" do
    it "assigns the requested account as @account" do
      PlutusAccount.stub(:find).with("37").and_return(mock_account)
      get :show, :id => "37"
      assigns[:plutus_account].should equal(mock_account)
    end
  end
end

require 'spec_helper'

describe PlutusAccountsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/plutus_accounts" }.should route_to(:controller => "plutus_accounts", :action => "index")
    end

    it "recognizes and generates #show" do
      { :get => "/plutus_accounts/1" }.should route_to(:controller => "plutus_accounts", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/plutus_accounts/1/edit" }.should_not be_routable
    end

    it "recognizes and generates #create" do
      { :post => "/plutus_accounts" }.should_not be_routable
    end

    it "recognizes and generates #update" do
      { :put => "/plutus_accounts/1" }.should_not be_routable
    end

    it "recognizes and generates #destroy" do
      { :delete => "/plutus_accounts/1" }.should_not be_routable
    end
  end
end

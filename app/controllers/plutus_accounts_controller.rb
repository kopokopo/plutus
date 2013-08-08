# This controller provides restful route handling for Accounts.
#
# The controller supports ActiveResource, and provides for
# HMTL, XML, and JSON presentation.
#
# == Security:
# Only GET requests are supported. You should ensure that your application
# controller enforces its own authentication and authorization, which this 
# controller will inherit.
# 
# @author Michael Bulat
class PlutusAccountsController < ApplicationController
  unloadable
  
  # @example
  #   GET /plutus_accounts
  #   GET /plutus_accounts.xml
  #   GET /plutus_accounts.json
  def index
    @accounts = PlutusAccount.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
      format.json  { render :json => @accounts }
    end
  end
  
  # @example
  #   GET /plutus_accounts/1
  #   GET /plutus_accounts/1.xml
  #   GET /plutus_accounts/1.json
  def show
    @account = PlutusAccount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
      format.json  { render :json => @account }
    end
  end  
  
end

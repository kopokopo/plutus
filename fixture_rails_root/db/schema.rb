# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140310041921) do

  create_table "amounts", :force => true do |t|
    t.string   "type"
    t.integer  "plutus_account_id"
    t.integer  "transaction_id"
    t.decimal  "amount",            :precision => 20, :scale => 10
    t.string   "time_period"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "amounts", ["plutus_account_id", "transaction_id"], :name => "index_amounts_on_plutus_account_id_and_transaction_id"
  add_index "amounts", ["transaction_id", "plutus_account_id"], :name => "index_amounts_on_transaction_id_and_plutus_account_id"
  add_index "amounts", ["type"], :name => "index_amounts_on_type"

  create_table "plutus_accounts", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.boolean  "contra"
    t.integer  "company_id"
    t.integer  "external_entity_id"
    t.integer  "account_id"
    t.string   "plutus_account_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plutus_accounts", ["name", "type"], :name => "index_plutus_accounts_on_name_and_type"

  create_table "transactions", :force => true do |t|
    t.string   "description"
    t.integer  "commercial_document_id"
    t.string   "commercial_document_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["commercial_document_id", "commercial_document_type"], :name => "index_transactions_on_commercial_doc"

end

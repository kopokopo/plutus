class CreatePlutusTables < ActiveRecord::Migration
  def self.up
    create_table :plutus_accounts do |t|
      t.string :name
      t.string :type
      t.boolean :contra

      t.timestamps
    end

    add_index :plutus_accounts, [:name, :type]

    create_table :transactions do |t|
      t.string :description
      t.integer :commercial_document_id
      t.string :commercial_document_type

      t.timestamps
    end
    add_index :transactions, [:commercial_document_id, :commercial_document_type], :name => "index_transactions_on_commercial_doc"


    create_table :amounts do |t|
      t.string :type
      t.references :plutus_account
      t.references :transaction
      t.decimal :amount, :precision => 20, :scale => 10
      t.string :time_period
      t.timestamps
    end
    add_index :amounts, :type
    add_index :amounts, [:plutus_account_id, :transaction_id]
    add_index :amounts, [:transaction_id, :plutus_account_id]
  end

  def self.down
    drop_table :plutus_accounts
    drop_table :transactions
    drop_table :amounts
  end
end

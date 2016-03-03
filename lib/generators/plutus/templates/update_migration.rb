class UpdatePlutusTables < ActiveRecord::Migration
  def change
    add_column :plutus_accounts, :ownable_type, :string
    add_column :plutus_accounts, :ownable_id, :integer
  end
end
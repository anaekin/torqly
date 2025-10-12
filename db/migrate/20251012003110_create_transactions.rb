# db/migrate/xxxx_create_transactions.rb
class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :booking, null: false, foreign_key: true

      t.integer :amount, null: false

      t.string  :payment_type, null: false, default: "card"
      t.string  :status,       null: false, default: "pending"

      t.string  :provider
      t.string  :payment_ref

      t.timestamps
    end

    add_index :transactions, :status
    add_index :transactions, :payment_type

    add_check_constraint :transactions,
      "status IN ('pending','succeeded','failed','refunded')",
      name: "transactions_status_check"

    add_check_constraint :transactions,
      "payment_type IN ('card','bank_transfer','cash','other')",
      name: "transactions_payment_type_check"
  end
end

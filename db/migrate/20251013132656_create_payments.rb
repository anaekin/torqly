class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :booking, null: false, foreign_key: true

      t.integer :amount, null: false

      t.string  :payment_type, null: false, default: "card"
      t.string  :status, null: false, default: "pending"

      t.string  :provider
      t.string  :payment_ref

      t.timestamps
    end

    add_index :payments, :status
    add_index :payments, :payment_type

    add_check_constraint :payments,
      "status IN ('pending','succeeded','failed','refunded')",
      name: "payments_status_check"

    add_check_constraint :payments,
      "payment_type IN ('card','bank_transfer','cash','other')",
      name: "payments_payment_type_check"
  end
end

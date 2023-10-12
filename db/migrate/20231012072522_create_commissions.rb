class CreateCommissions < ActiveRecord::Migration[7.0]
  def change
    create_table :commissions do |t|
      t.references :buyer, null: false, foreign_key: true
      t.references :seller, null: false, foreign_key: true
      t.references :commission_type, null: false, foreign_key: true
      t.decimal :price
      t.string :stage
      t.string :description

      t.timestamps
    end
  end
end

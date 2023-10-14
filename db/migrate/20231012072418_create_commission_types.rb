class CreateCommissionTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :commission_types do |t|
      t.string :title
      t.decimal :price
      t.references :seller, null: false, foreign_key: true

      t.timestamps
    end
  end
end

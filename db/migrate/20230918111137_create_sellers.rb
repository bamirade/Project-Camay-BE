class CreateSellers < ActiveRecord::Migration[7.0]
  def change
    create_table :sellers do |t|
      t.text :bio
      t.text :portfolio
      t.float :seller_rating
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.belongs_to :employee
      t.belongs_to :big_deal
      t.column :description, :string

      t.timestamps
    end
  end
end

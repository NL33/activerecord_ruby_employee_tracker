class CreateBigDeals < ActiveRecord::Migration
  def change
    create_table :big_deals do |t|
    	t.column :name, :string
	    t.timestamps 
    end
  end
end

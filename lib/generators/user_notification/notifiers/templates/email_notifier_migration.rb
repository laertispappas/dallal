class Create<%= notifications_table_name.camelize %> < ActiveRecord::Migration
  def change
    create_table :<%= notifications_table_name %> do |t|
      t.timestamps
    end
  end
end

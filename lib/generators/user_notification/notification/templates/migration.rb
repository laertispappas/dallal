class Create<%= notifications_table_name.camelize %> < ActiveRecord::Migration
  def change
    create_table :<%= notifications_table_name %> do |t|
      t.references :<%= user_model_name %>, index: true, foreign_key: true, null: false
      t.timestamp :sent_at
      t.timestamp :deliver_at
      t.timestamps
    end
  end
end

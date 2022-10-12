class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :number, index: true
      t.integer :application_id, index: true
      t.integer :messages_count
      t.timestamps
    end
  end
end

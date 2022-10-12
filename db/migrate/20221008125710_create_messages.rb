class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string :body, index: true
      t.integer :chat_id, index: true
      t.integer :number, index: true
      t.timestamps
    end
  end
end

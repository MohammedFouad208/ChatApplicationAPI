class AddChatCountColumnToApplication < ActiveRecord::Migration[5.2]
  def change
    add_column :applications, :chats_count, :integer, :default => 0
  end
end

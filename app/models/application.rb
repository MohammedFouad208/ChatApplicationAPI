class Application < ApplicationRecord
    has_many :chats, class_name: "Chat"
end

require 'elasticsearch/model'

class Message < ApplicationRecord
    belongs_to :chat, class_name: "Chat", foreign_key: "chat_id"
    include Elasticsearch::Model
end

class ChatMQ < MQService
    def initialize
        begin
          create_connection
          create_channel
          create_queue("ChatQueue")
        rescue StandardError
          sleep 1
          retry
        end
    end
    def add_chat (chat) 
        @queue.publish(chat.to_json, persistent: true)
        close_connection
        return true
    end
end
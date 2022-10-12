class MessageMQ < MQService
    def initialize
        begin
          create_connection
          create_channel
          create_queue("MessageQueue")
        rescue StandardError
          sleep 1
          retry
        end
    end
    def add_message (message) 
        @queue.publish(message.to_json, persistent: true)
        close_connection
        return true
    end
end
require 'bunny'

class MQService

    def create_connection
        @connection = Bunny.new(hostname: 'rabbitmq')
        @connection.start
    end
    
    def create_channel
        @channel = @connection.create_channel
    end

    def create_queue (queue_name)
        @queue = @channel.queue(queue_name)
    end

    def close_connection
        @connection.close
    end
end
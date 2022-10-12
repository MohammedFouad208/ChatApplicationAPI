require 'message_service.rb'

class MessageWorker < MQService
  include Sidekiq::Worker
  def perform
    sleep 10
    non_present_message_list = []
    begin
      create_connection
      create_channel
      create_queue("MessageQueue")
    rescue StandardError
      sleep 1
      retry
    end
    @queue.subscribe(block: true) do |_delivery_info, _properties, body|
      message = ActiveSupport::JSON.decode body
      puts "message is #{message}"
      message_service = MessageService.new
      if !message_service.create_message_in_database(message)
        non_present_message_list.push(body)
      end
    end
    non_present_message_list.each {|obj| @queue.publish(obj, persistent: true)}
    close_connection
  end
end
require 'chat_service.rb'

class ChatWorker < MQService
  include Sidekiq::Worker
  def perform
    sleep 10
    non_present_chat_list = []
    begin
      create_connection
      create_channel
      create_queue("ChatQueue")
    rescue StandardError
      sleep 1
      retry
    end
    @queue.subscribe(block: true) do |_delivery_info, _properties, body|
      chat = ActiveSupport::JSON.decode body
      puts "chat is #{chat}"
      chat_service = ChatService.new
      if !chat_service.create_chat_in_database(chat)
        non_present_chat_list.push(body)
      end
    end
    non_present_chat_list.each {|obj| @queue.publish(obj, persistent: true)}
    close_connection
  end
end
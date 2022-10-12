require 'application.rb'
require 'chat.rb'
require 'message.rb'
require 'elasticsearch'

class MessageService
    def get_all
        Message.all.select(
            :number,
            :body,
            :created_at,
            :updated_at
        )
    end

    def search(application_token, chat_number, value)
        begin
            es_url = "http://elasticsearch:9200"
            client ||= Elasticsearch::Client.new url: es_url, log: true
            chat = Chat.joins(:application).where(applications: {token: application_token}, chats: {number: chat_number}).first
            result = client.search(index: 'messages', body: { body: value, chat_id: chat.id })
            result.records

            rescue StandardError
                sleep 2
                retry
        end
        
        
    end

    def get_last_message_number(chat_id)
        message = Message.where(chat_id: chat_id).order('number desc').first
        if message.present?
            return message.number
        else
            return 0
        end
    end
    def create_message_in_queue(message)
        chat = Chat.joins(:application).where(applications: {token: message['application_token']}, chats: {number: message['chat_number']}).first
        puts "chat is #{chat}"
        if !chat.present?
            return -1
        end

        messages_in_chat = get_last_message_number(chat.id)
    
        message_new = Message.new(chat_id: chat.id, number: messages_in_chat + 1, body: message['body'])
        message_mq = MessageMQ.new
        if message_mq.add_message(message_new)
            return message_new.number
        else
            return -1
        end
    end

    def create_message_in_database(message)
        puts "Start..."
        chat = Chat.find(message['chat_id'])

        if !chat.present?
            return false
        end
        messages_in_chat = get_last_message_number(chat.id)
        new_message = Message.new(number: messages_in_chat + 1, chat_id: message['chat_id'], body: message['body'])
        if new_message.save
            puts "Message saved successfully"
            chat.update({messages_count: messages_in_chat + 1})
            return true
        end
    end

    def delete_message (application_token, chat_number, message_number)
        chat = Chat.joins(:application).where(applications: {token: application_token}, chats: {number: chat_number}).first
        if !chat.present?
            return {Msg: "Chat Not Found", isSuccess: false}
        end
        message = Message.where(chat_id: chat.id, number: message_number).first
        if !message.present?
            return {Msg: "Message Not Found", isSuccess: false}
        end
        chat.update({messages_count: chat.messages_count - 1})
        message.destroy

        return {Msg: "Message Removed Successfully", isSuccess: true}
    end
end
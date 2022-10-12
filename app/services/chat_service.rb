require 'application.rb'
require 'chat.rb'

class ChatService
    def get_all
        Chat.all.select(
            :number,
            :messages_count,
            :created_at,
            :updated_at
        )
    end

    def get_chat_messages(application_token, chat_number)
        result = []
        chat = Chat.joins(:application).where(applications: {token: application_token}, chats: {number: chat_number}).first
        if chat.present?
            result = Message.joins(:chat).where(chats: {id: chat.id}).select(
                :number,
                :body,
                :created_at,
                :updated_at
            )
        end
        return result
    end

    def get_last_chat_number(application_id)
        chat = Chat.where(application_id: application_id).order('number desc').first
        if chat.present?
            return chat.number
        else
            return 0
        end
    end

    def create_chat_in_queue(application_token)
        application = Application.where(token: application_token).first
        chats_in_application = get_last_chat_number(application.id)
    
        chat = Chat.new(application_id: application.id, number: chats_in_application + 1)
        chat_mq = ChatMQ.new
        if chat_mq.add_chat(chat)
            return chat.number
        else
            return -1
        end
    end

    def create_chat_in_database (chat)
        puts "Start..."
        application = Application.find(chat['application_id'])
        if !application.present?
            return false
        end

        chats_in_application = get_last_chat_number(application.id)
        new_chat = Chat.new(number: chats_in_application + 1, application_id: chat['application_id'], messages_count: 0)
        if new_chat.save
            puts "chat saved successfully"
            application.update({chats_count: chats_in_application + 1})
            return true
        end
    end   

    def delete_chat (application_token, chat_number)
        application = Application.where(token: application_token).first
        chat = Chat.where(application_id: application.id, number: chat_number).first
        if !chat.present?
            return {Msg: "Chat Not Found", isSuccess: false}
        else
            application.update({chats_count: application.chats_count - 1})
            messages_in_chat = Message.where(chat_id: chat.id)
            messages_in_chat.each {|obj| obj.destroy}
            chat.destroy
            return {Msg: "Chat Removed Successfully", isSuccess: true}
        end
    end
end
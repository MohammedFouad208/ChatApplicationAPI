require "securerandom"

class ApplicationService
    def get_all
        Application.all.select(:token, :name, :chats_count, :created_at, :updated_at)
    end

    def get_application (token)
        Application.where(token: token).first
    end

    def get_application_chats (token)
        Chat.joins(:application).where(applications: {token: token}).select(
            :number,
            :messages_count,
            :created_at, 
            :updated_at
        )

    end

    def create_application (application)
        application.token = SecureRandom.uuid
        application.save
    end

    def update_application (application, application_params)
        application.update(application_params)
    end

    def delete_application (application)
        if !application.present?
            return {Msg: "Application Not Found", isSuccess: false}
        elsif application.chats_count > 0
            return {Msg: "Error: can't delete application has chats", isSuccess: false}
        else
            application.destroy
            return {Msg: "Application Removed Successfully", isSuccess: true}
        end
    end
end
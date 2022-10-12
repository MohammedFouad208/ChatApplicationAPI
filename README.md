# Chat Application README

- You Must install docker desktop to run the application

# Instructions to Run Application

- open cmd
- run command to build and create images and containers: 
  docker-compose up
  
- run command to migrate database: 
  docker-compose run --rm app rake db:migrate
  
- run command: 
  docker-compose up
  
 ----------------------------------------------------------------------------------------------------------------------------------
 
 # Application end points
 
 - Get all applications: GET '/applications'
 - Get application: GET '/applications/{token}'
 - Get application's chats: GET '/applications/{application_token}/chats'
 - Create new application: POST '/applications'
   with body : {
    "application": {
        "name" : "Application Name"
    }
   }

-  Update application: PUT '/applications/{token}'
   with body : {
    "application": {
        "name" : "Application Name"
    }
   }
- Delete application: DELETE '/applications/{token}'

------------------------------------------------------------------------------------------------------------------------------------
# Chat end points

 - Get all chats: GET '/chats'
 - Get chat's messages: GET '/chats/{application_token}/{chat_number}/messages'
 - Create new chat: POST '/chats/{application_token}'
 - Delete chat: DELETE '/chats/{application_token}/{chat_number}'
------------------------------------------------------------------------------------------------------------------------------------
# Message end points

 - Get all messages: GET '/messages'
 - Search in messages by text: GET '/messages/{application_token}/{chat_number}/{text}/search'
 - Create new message: POST '/messages'
   with body : {
    "message": {
        "application_token": "token",
        "chat_number": 1,
        "body": "message"
    }
   }
 - Delete message: DELETE '/messages/application_token/chat_number/message_number'

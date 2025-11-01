class Api::V1::AiChatsController < ApplicationController
  def create
    prompt = params[:message]
    response = OpenaiChatService.new(prompt).call
    render json: {reply: response}
  end
end

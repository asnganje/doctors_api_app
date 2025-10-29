class AiChatsController < ApplicationController
  def create
    prompt = params[:prompt]
    response = OpenaiChatService.new(prompt).call
    render json: {reply: prompt}
  end
end

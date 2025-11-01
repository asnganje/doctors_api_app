class Api::V1::AiChatsController < ApplicationController
  def create
    prompt = params[:message]
    Rails.logger.info "Nganje #{prompt.inspect}"
    response = OpenaiChatService.new(prompt).call
    render json: {reply: response}
  end
end

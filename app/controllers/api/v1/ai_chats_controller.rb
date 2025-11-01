class Api::V1::AiChatsController < ApplicationController
  def create
    prompt = params[:message]
    response = OpenaiChatService.new(prompt).call
    Rails.logger.info "NGANJE #{prompt} ---- #{response}"
    render json: {reply: response}
  end
end

# require "openai"
# key = ENV["OPENAI_API_KEY"] ||Rails.application.credentials.openai&.[](:api_key)
# raise "❌ Missing OpenAI API key in credentials" if key.blank?
# OPENAI_CLIENT = OpenAI::Client.new(access_token: key, log_errors: true)
# # require "openai"

# # if ENV["OPENAI_API_KEY"].blank?
# #   Rails.logger.warn("OPENAI_API_KEY is not set")
# # end
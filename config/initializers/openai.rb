require "openai"
key = Rails.application.credentials.openai&.[](:api_key)
raise "❌ Missing OpenAI API key in credentials" if key.blank?

OPENAI_CLIENT = OpenAI::Client.new(access_token: key)
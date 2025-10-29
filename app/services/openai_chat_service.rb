require "openai"

class OpenaiChatService
  def initialize(prompt)
    @prompt = prompt
    @client = OpenAI::Client.new(access_token: Rails.application.credentials[:OPEN_AI_API_KEY])    
  end
  def call
    response = @client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [
          {role: "system", 
          content: "You are a helpful virtual health assistant. Provide general medical guidance, but do not give exact diagnoses or prescriptions."
          },
          {
            role: "user",
            content: @prompt
          }
        ],
        max_tokens: 70,
        temperature: 0.7
      }
    )
    response.dig("choices", 0, "message", "content")
  end
end

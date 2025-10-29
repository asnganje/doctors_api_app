require "openai"

class OpenaiChatService
  def initialize(prompt)
    @prompt = prompt
    @client = OpenAI::Client.new(access_token: ENV['OPEN_AI_API_KEY'])    
  end
  def call
    response = @client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [
          {role: "System", 
          content: "You are a helpful virtual health assistant. Provide general medical guidance, but do not give exact diagnoses or prescriptions."
          },
          {
            role: "User",
            content: @prompt
          }
        ],
        temperature: 0.7
      }
    )
    response.dig("choices", 0, "message", "content")
  end
end

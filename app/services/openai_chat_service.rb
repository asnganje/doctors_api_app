require "openai"

class OpenaiChatService
  def initialize(prompt)
    @prompt = prompt
    @client = OPENAI_CLIENT
  end
  def call
    response = @client.chat.completions(
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
        max_completion_tokens: 70,
        temperature: 0.7
      }
    )
    puts "nganje #{response}"
    response.dig("choices", 0, "message", "content")
  end
end

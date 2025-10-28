require "httparty"

class SupabaseService
  include HTTParty
  
  base_uri "#{ENV['SUPABASE_URL']}/storage/v1"
  def self.upload_file(bucket, file)
    file_name = "#{SecureRandom.uuid}_#{file.original_filename}"
    file_path = "doctors/#{file_name}"

    response = HTTParty.post(
      "#{base_uri}/object/#{bucket}/#{file_path}",
      headers:{
        "apiKey"=> ENV["SUPABASE_SERVICE_ROLE_KEY"],
        "Authorization" => "Bearer #{ENV["SUPABASE_SERVICE_ROLE_KEY"]}",
        "Content-Type" => file.content_type
      },
      body: file.read
    )
    if response.success?
      "#{ENV["SUPABASE_URL"]}/storage/v1/object/public/#{bucket}/#{file_path}"
    else
      raise "Supabase upload failed: #{response.body}"
    end
  end
end

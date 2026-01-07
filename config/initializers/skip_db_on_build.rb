if Rails.env.production? && ENV['DATABASE_URL'].blank?
  module ActiveRecord
    class Railtie < Rails::Railtie
      rake_tasks do
        Rake::Task['db:prepare'].clear
      end
    end
  end
end
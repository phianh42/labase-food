# config/initializers/solid_queue.rb
if Rails.env.production?
  Rails.application.configure do
    # Force solid_queue to use main database connection
    config.solid_queue.connects_to = { database: { writing: :primary } }
  end
end
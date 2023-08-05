require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WebhookDemo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    config.x.endpoints = {
      endpoint1: 'https://amazon.com/endpoint1',
      endpoint2: 'https://flipkart.com/endpoint2'
    }
    
    config.x.events = {
      endpoint1: {
        create: :notify_api1_on_create,
        update: :notify_api1_on_update
      },

      endpoint2: {
        create: :notify_api2_on_create
      }
    }
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end

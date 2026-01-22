require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Livehub
  class Application < Rails::Application
    config.load_defaults 6.1
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.yml").to_s]

  end
end

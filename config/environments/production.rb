  require "active_support/core_ext/integer/time"
  require "ipaddr"
  Rails.application.configure do

    config.hosts.clear

    config.hosts << IPAddr.new("172.16.0.0/12")
    config.hosts << IPAddr.new("10.0.0.0/8")
    config.hosts << IPAddr.new("192.168.0.0/16")

    config.cache_classes = true

    config.eager_load = true

    config.consider_all_requests_local       = false
    config.action_controller.perform_caching = true


    config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?


    config.assets.compile = false



    config.active_storage.service = :local



    config.log_level = :info

    config.log_tags = [ :request_id ]



    config.action_mailer.perform_caching = false


    config.i18n.fallbacks = true

    config.active_support.deprecation = :notify

    config.active_support.disallowed_deprecation = :log

    config.active_support.disallowed_deprecation_warnings = []

    config.log_formatter = Logger::Formatter.new


    if ENV["RAILS_LOG_TO_STDOUT"].present?
      logger           = ActiveSupport::Logger.new(STDOUT)
      logger.formatter = config.log_formatter
      config.logger    = ActiveSupport::TaggedLogging.new(logger)
    end


    config.active_record.dump_schema_after_migration = false

  end

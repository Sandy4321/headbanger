require_relative 'boot'

require 'rails/all'
require 'neo4j/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Headbanger
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.api = YAML.load_file(Rails.root.join('config', 'api.yml'))[Rails.env]
    config.mailer = YAML.load_file(Rails.root.join('config', 'mailer.yml'))[Rails.env]
    config.action_mailer.default_url_options = {
        :host => config.mailer['default_host_url'].split.first,
        :port => config.mailer['default_host_url'].split.last
    }

    # Add bower_components to asset path
    config.assets.paths << Rails.root.join('vendor','assets','bower_components')
    config.assets.precompile << %r(.*.(?:eot|svg|ttf|woff|woff2)$)

    # Neo4j configuration
    config.neo4j.module_handling = :demodulize

    config.autoload_paths += %W(#{config.root}/lib)

    # Angular templates
    # config.angular_templates.module_name    = 'templates'
    # config.angular_templates.ignore_prefix  = %w(templates/)
    # config.angular_templates.inside_paths   = ['app/assets']
    # config.angular_templates.markups        = %w(erb)
    # config.angular_templates.extension      = 'html'

    # Grape Token Auth
    config.middleware.insert_after ActionDispatch::Flash, Warden::Manager do |manager|
      manager.failure_app = GrapeTokenAuth::UnauthorizedMiddleware
      manager.default_scope = :user
    end
  end
end

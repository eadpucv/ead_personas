# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Verificando identidd.
Rails.application.config.assets.precompile += %w( personas.css )
Rails.application.config.assets.precompile += %w( transition.js )
Rails.application.config.assets.precompile += %w( modal.js )
Rails.application.config.assets.precompile += %w( tab.js )
Rails.application.config.assets.precompile += %w( dropdown.js )
Rails.application.config.assets.precompile += %w( collapse.js )
Rails.application.config.assets.precompile += %w( tooltip.js )

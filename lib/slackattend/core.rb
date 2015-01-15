module Slackattend
  module Core
    def config
      @config ||= YAML.load_file(File.expand_path('../../../config.yml', __FILE__))
    end
  end

  extend Core
end 

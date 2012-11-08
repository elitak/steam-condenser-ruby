# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2012, Sebastian Staudt

require 'multi_json'

require 'steam/community/cacheable'
require 'steam/community/game_achievement'
require 'steam/community/game_stats_value'
require 'steam/community/web_api'

class GameStatsSchema

  include Cacheable
  cacheable_with_ids :app_id

  # @return [Array<GameAchievement>]
  attr_reader :achievements

  attr_reader :app_id

  attr_reader :app_name

  attr_reader :app_version

  attr_reader :stats_values

  # @macro cacheable
  def initialize(app_id)
    @app_id = app_id
  end

  def fetch
    params = { :appid => @app_id }
    json_data = WebApi.json 'ISteamUserStats', 'GetSchemaForGame', 2, params
    schema = MultiJson.load(json_data, { :symbolize_keys => true })[:game]

    @app_name    = schema[:gameName]
    @app_version = schema[:gameVersion].to_i

    @stats_values = schema[:availableGameStats][:stats].map do |data|
      GameStatsValue.new self, data
    end

    @achievements = schema[:availableGameStats][:achievements].map do |data|
      GameAchievement.new self, data
    end
  end

  def inspect
    "#<#{self.class}:#@app_id \"#@app_name\" (#@app_version)>"
  end

end

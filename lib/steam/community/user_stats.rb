# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2012, Sebastian Staudt

require 'multi_json'

require 'steam/community/cacheable'
require 'steam/community/game_stats_schema'
require 'steam/community/web_api'

class UserStats

  include Cacheable
  cacheable_with_ids [ :app_id, :steam_id64 ]

  def initialize(app_id, steam_id64)
    @app_id     = app_id
    @steam_id64 = steam_id64

    params = { :appid => app_id, :steamid => steam_id64 }
    json_data = WebApi.json 'ISteamUserStats', 'GetUserStatsForGame', 2, params
    stats = MultiJson.load(json_data, { :symbolize_keys => true })[:playerstats]

    @game_schema = GameStatsSchema.new app_id

    @locked_achievements = Hash[@game_schema.achievements.map { |achievement|
      [ achievement.api_name, achievement ]
    }]
    @unlocked_achievements = []
    stats[:achievements].each do |achievement|
      if achievement[:achieved] == 1
        @unlocked_achievements << @locked_achievements.delete(achievement[:name])
      end
    end
  end

  def inspect
    "#<#{self.class}:#@steam_id64 \"#{@game_schema.app_name}\" #{@unlocked_achievements.size}/#{@locked_achievements.size + @unlocked_achievements.size} achievements>"
  end

end

# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2008-2012, Sebastian Staudt

require 'multi_json'

require 'steam/community/web_api'

# The GameAchievement class represents a specific achievement for a single game
# and for a single user
#
# It also provides the ability to load the global unlock percentages of all
# achievements of a specific game.
#
# @author Sebastian Staudt
class GameAchievement

  # Returns the symbolic API name of this achievement
  #
  # @return [String] The API name of this achievement
  attr_reader :api_name

  # Returns the description of this achievement
  #
  # @return [String] The description of this achievement
  attr_reader :description

  # Return the game this achievement belongs to
  #
  # @return [Steam] The game this achievement belongs to
  attr_reader :game_schema

  attr_reader :hidden

  # Returns the url for the closed icon of this achievement
  #
  # @return [String] The url of the closed achievement icon
  attr_reader :icon_closed_url

  # Returns the url for the open icon of this achievement
  #
  # @return [String] The url of the open achievement icon
  attr_reader :icon_open_url

  # Returns the name of this achievement
  #
  # @return [String] The name of this achievement
  attr_reader :name

  # Loads the global unlock percentages of all achievements for the game with
  # the given Steam Application ID
  #
  # @param [Fixnum] app_id The unique Steam Application ID of the game (e.g.
  #        `440` for Team Fortress 2). See
  #         http://developer.valvesoftware.com/wiki/Steam_Application_IDs for
  #         all application IDs
  # @raise [WebApiError] if the request to Steam's Web API fails
  # @return [Hash<Symbol, Float>] The symbolic achievement names with their
  #         corresponding unlock percentages
  def self.global_percentages(app_id)
    percentages = {}

    params = { :gameid => app_id }
    data = WebApi.json 'ISteamUserStats', 'GetGlobalAchievementPercentagesForApp', 2, params
    MultiJson.load(data, { :symbolize_keys => true })[:achievementpercentages][:achievements].each do |percentage|
      percentages[percentage[:name].to_sym] = percentage[:percent]
    end

    percentages
  end

  # Creates the achievement with the given name for the given user and game
  # and achievement data
  #
  # @param [GameStatsSchema] game_schema The game this achievement belongs to
  # @param [Hash<String, Object>] data The achievement data extracted from the
  #        game schema
  def initialize(game_schema, data)
    @api_name        = data[:name]
    @description     = data[:description]
    @game_schema     = game_schema
    @hidden          = data[:hidden] == 1
    @icon_closed_url = data[:icon]
    @icon_open_url   = data[:icongray]
    @name            = data[:displayName]
  end

  def inspect
    "#<#{self.class}:#@api_name>"
  end

end

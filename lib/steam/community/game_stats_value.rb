# This code is free software; you can redistribute it and/or modify it under
# the terms of the new BSD License.
#
# Copyright (c) 2012, Sebastian Staudt

require 'steam/community/game_stats_schema'

class GameStatsValue

  attr_reader :api_name

  attr_reader :default_value

  attr_reader :game_schema

  attr_reader :name

  # @param [GameStatsSchema] game_schema
  # @param [Hash<Symbol, Object>] data
  def initialize(game_schema, data)
    @api_name      = data[:name]
    @default_value = data[:defaultvalue]
    @game_schema   = game_schema
    @name          = data[:displayName]
  end

  def inspect
    "#<#{self.class}:#@api_name (#@default_value)>"
  end

end

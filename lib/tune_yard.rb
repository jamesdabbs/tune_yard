require "tune_yard/version"
require "tune_yard/player"

module TuneYard
  Player = DefaultPlayer.new

  at_exit { Player.stop }

  def self.play opts={}, &block
    Player.run &block
    if opts[:for]
      sleep opts[:for]
      stop
    end
  end

  def self.stop
    Player.stop
  end
end

require 'sourcify'

# `rugged` is vendored in SonicPi, but not required relative, so the require may fail to find it
require 'rugged'

# Load bundled Sonic Pi files
$LOAD_PATH.unshift '/Applications/Sonic Pi.app/app/server'
require 'core.rb'
%w{ studio spider spiderapi server util oscencode }.each do |m|
  require "sonicpi/lib/sonicpi/#{m}"
end
$LOAD_PATH.shift

# TODO: seems like we shouldn't need this included globally ...
include SonicPi::Util

module TuneYard
  class BasePlayer < SonicPi::Spider
    include SonicPi::SpiderAPI
    include SonicPi::Mods::Sound

    def run &block
      # TODO: there's a definite race condition here
      @_outer_binding = block.binding

      code = <<-CODE
        use_arg_checks true
        use_debug true
        #{block.to_source strip_enclosure: true}
      CODE
      __spider_eval code, workspace: __FILE__
    end

    def stop
      __stop_jobs
    end

    def method_missing name, *args
      if @_outer_binding.local_variable_defined? name
        @_outer_binding.local_variable_get name
      else
        @_outer_binding.send name, *args
      end
    end
  end

  class DefaultPlayer < BasePlayer
    def initialize
      super "localhost", 4555, Queue.new, 5, Module.new
    end
  end
end

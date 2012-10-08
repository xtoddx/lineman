require 'test/unit/ui/statistics/base_runner'


module Test::Unit # :nodoc:
  class << self
    def require_statistics_runners # :nodoc:
      stat_dir = File.expand_path('../ui/statistics/runners',
                                  File.dirname(__FILE__))
      Dir["#{stat_dir}/*.rb"].each do |f|
        require_relative "../ui/statistics/runners/#{File.basename(f)}"
      end
    end
  end

  require_statistics_runners
  Test::Unit::UI::Statistics::BaseRunner.each_subclass do |subclass|
    AutoRunner.register_runner(subclass.name) do |_auto_runner|
      subclass
    end
  end
end

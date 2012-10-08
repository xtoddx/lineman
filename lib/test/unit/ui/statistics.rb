module Test::Unit::UI::Statistics
  class CaseStatistics
    attr_accessor :pass
    attr_accessor :fail
    attr_accessor :errs
    attr_accessor :pend
    attr_accessor :omit
    attr_accessor :note

    def initialize results
      self.pass = 0
      self.fail = 0
      self.errs = 0
      self.pend = 0
      self.omit = 0
      self.note = 0
      @start_time = Time.now
      @end_time = nil
    end

    def elapsed_time
      end_time - @start_time
    end

    def end_time
      @end_time ? @end_time : Time.now
    end

    def complete
      @end_time = Time.now
    end
  end


  class SuiteStatistics
    attr_reader :test_suite
    attr_accessor :forward_class

    def initialize test_suite
      @test_suite = test_suite
      @aggregate_statistics = []
    end

    def add_test_case_statistics stats
      @aggregate_statistics << stats
    end

    def aggregate sym
      @aggregate_statistics.inject(0) {|a,v| a + v.send(sym) }
    end

    def method_missing sym, *args
      if respond_to?(sym)
        aggregate(sym)
      else
        super
      end
    end

    def respond_to? sym
      Test::Unit::TestResult.instance_methods.include?(sym) or
          CaseStatistics.instance_methods.include?(sym)
    end
  end
end

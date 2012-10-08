require 'test/unit/ui/testrunner'
require 'test/unit/ui/testrunnermediator'
require_relative '../statistics'

module Test::Unit::UI::Statistics # :nodoc:

  # Inherit from this class to create a runner that has access to statistics.
  #
  # Implement any/all of the following callbacks in your subclass:
  # * reset
  # * started
  # * finished
  # * suite_started
  # * suite_finished
  # * case_started
  # * case_finished
  # * assertion
  # * error
  # * failure
  # * pending
  # * omission
  # * notification
  # * fault
  #
  class BaseRunner < Test::Unit::UI::TestRunner # :nodoc:

    attr_accessor :result

    # Case Statistics
    def cstat
      @method_metrics
    end

    # Suite Statistics
    def sstat
      @suite_stack.last
    end

    def self.inherited kls #:nodoc:
      (@@subclasses ||= []) << kls
    end

    def self.each_subclass #:nodoc:
      @@subclasses.each {|kls| yield kls }
    end

    def initialize suite, options={} #:nodoc:
      super
      @suite_stack = []
      @output = options[:output] || STDOUT
    end

    # Inherited from TestRunner, sets up callbacks via i-var.
    def attach_to_mediator #:nodoc:
      @mediator.add_listener(Test::Unit::UI::TestRunnerMediator::RESET,
                             &callback(:reset))
      @mediator.add_listener(Test::Unit::UI::TestRunnerMediator::STARTED,
                             &callback(:stats_started, :started))
      @mediator.add_listener(Test::Unit::UI::TestRunnerMediator::FINISHED,
                             &callback(:finished))
      @mediator.add_listener(Test::Unit::TestSuite::STARTED_OBJECT,
                             &callback(:stats_suite_started, :suite_started))
      @mediator.add_listener(Test::Unit::TestSuite::FINISHED_OBJECT,
                             &callback(:suite_finished, :stats_suite_finished))
      @mediator.add_listener(Test::Unit::TestCase::STARTED,
                             &callback(:stats_case_started, :case_started))
      @mediator.add_listener(Test::Unit::TestCase::FINISHED,
                             &callback(:stats_case_finished, :case_finished))
      @mediator.add_listener(Test::Unit::TestResult::PASS_ASSERTION,
                             &callback(:stats_assertion, :assertion))
      @mediator.add_listener(Test::Unit::TestResult::FAULT,
                             &callback(:stats_fault, :fault))
    end

    # Forward to methods (in-order) that we might respond to.
    def callback *types #:nodoc:
      ->(*args) { types.select{|t| respond_to?(t) }.each{|t| send(t, *args) }}
    end

    def stats_started result #:nodoc:
      @result = result
    end

    def stats_suite_started testsuite #:nodoc:
      @suite_stack << SuiteStatistics.new(testsuite)
    end

    def stats_suite_finished testsuite #:nodoc:
      @suite_stack.pop
    end

    def stats_case_started name #:nodoc:
      @method_metrics = CaseStatistics.new(@result)
    end

    def stats_case_finished name #:nodoc:
      @method_metrics.complete
      update_suites_with_case_statistics
    end

    def stats_assertion testresult #:nodoc:
      @method_metrics.pass += 1
    end

    def stats_fault fault #:nodoc:
      base_type = fault.class.name.split('::').last.downcase
      stat_method_name = "stats_handle_#{base_type}".to_sym
      method_name = "#{base_type}".to_sym
      send(stat_method_name, fault)
      if respond_to?(method_name)
        send(method_name, fault)
      end
    end

    def stats_handle_error fault #:nodoc:
      # Don't count errors before setup (i.e. in startup).
      return unless @method_metrics
      @method_metrics.errs += 1
    end

    def stats_handle_failure fault #:nodoc:
      # The PASS_ASSERTION message just means it was run, we handle failures
      @method_metrics.fail += 1
      @method_metrics.pass -= 1
    end

    def stats_handle_pending fault #:nodoc:
      @method_metrics.pend += 1
    end

    def stats_handle_omission fault #:nodoc:
      @method_metrics.omit += 1
    end

    def stats_handle_notification fault #:nodoc:
      @method_metrics.note += 1
    end

    def update_suites_with_case_statistics #:nodoc:
      @suite_stack.each do |suite|
        suite.add_test_case_statistics @method_metrics
      end
    end

  end
end

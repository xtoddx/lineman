require_relative '../base_runner'
#require 'test/unit/color-scheme'
#require 'test/unit/code-snippet-fetcher'
#require 'test/unit/diff'


module Test::Unit::UI::Statistics::Lineman # :nodoc:
  class TestRunner < Test::Unit::UI::Statistics::BaseRunner # :nodoc:

    def self.name
      'lineman'
    end

    # callback
    def reset size
      puts "Preparing to run #{size} tests"
    end

    # callback
    def finished time
      show_faults
      puts "Finished in #{time.inspect}"
      puts result.to_s
    end

    # callback
    def suite_started testcase
      puts "%-0.80s" % testcase
    end

    # callback
    def suite_finished testcase
      two_point_time = ("%.2f" % sstat.elapsed_time)
      extended_actions = ''
      extended_actions += (sstat.errs.nonzero? ? 'E' : ' ')
      extended_actions += (sstat.pend.nonzero? ? 'P' : ' ')
      extended_actions += (sstat.omit.nonzero? ? 'O' : ' ')
      extended_actions += (sstat.note.nonzero? ? 'N' : ' ')
      puts "%-50.50s %4.4s:%-4.4s %6.6s %s" % [testcase,
                                              sstat.pass,
                                              sstat.fail,
                                              two_point_time,
                                              extended_actions]
    end

    # callback
    def case_started test_name
      output_name = test_name.gsub(/\(#{sstat.test_suite.to_s}\)$/, '')
      print "    %-46.46s " % output_name
    end

    # callback
    def case_finished test_name
      two_point_time = ("%.2f" % cstat.elapsed_time)
      if cstat.errs.nonzero?
        err_or_pass_fail = 'ERROR'
      else
        err_or_pass_fail = '%4.4s:%-4.4s' % [cstat.pass,
                                             cstat.fail]
      end
      extended_actions = ''
      extended_actions += (cstat.pend.nonzero? ? 'P' : ' ')
      extended_actions += (cstat.omit.nonzero? ? 'O' : ' ')
      extended_actions += (cstat.note.nonzero? ? 'N' : ' ')
      puts "%9.9s %6.6s  %s" % [err_or_pass_fail, two_point_time,
                                extended_actions]
    end

    def show_faults
      puts "\n"
      order = [Test::Unit::Error, Test::Unit::Failure, Test::Unit::Omission,
               Test::Unit::Pending, Test::Unit::Notification]
      order.each do |type|
        faults = result.faults.select {|f| f.is_a?(type) }
        if faults.length.nonzero?
          type_str = "#{type.to_s.split('::').last}s"
          puts "=" * type_str.length
          puts type_str
          puts "=" * type_str.length
          puts ''
          max_width = faults.length.to_s.length
          faults.each_with_index do |f,i|
            puts "  %#{max_width}i) %s\n" % [i+1, f.long_display]
            puts ''
          end
          puts ''
        end
      end
      puts "\n"
    end

    def fault_header_line num, fault
      "  %#{@exception_max_width}i) %s:" % [num, fault.label]
    end

    def fault_location_line fault
      "#{fault.test_name} #{fault.location}:"
    end

    def fault_message fault
      fault.message
    end

    def exception_backtrace fault
      "    " + fault.backtrace.join("\n    ")
    end

  end
end

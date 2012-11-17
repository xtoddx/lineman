`lineman` is a test runner for
[test-unit](https://github.com/test-unit/test-unit) that prints a line per test,
with statistics about its performance.

Example output:

    NPCRobotTest
        test: should have a cool nickname                 0:1      0.01    N
        test: should have big birthday party              1:1      0.00     
        test: should have pizzas for party                0:0      0.00   ON
        test: should not dance                            0:0      0.00  P  
    NPCRobotTest                                          1:2      0.01  PON
    test/npc_robot_test                                   1:2      0.01  PON

    ========
    Failures
    ========

      1) Failure:
    test: should have a cool nickname(NPCRobotTest) [test/npc_robot_test.rb:30]:
    <"claptrap"> expected but was
    <"Claptrap">.

    diff:
    - claptrap
    ? ^
    + Claptrap
    ? ^

      2) Failure:
    test: should have big birthday party(NPCRobotTest) [test/npc_robot_test.rb:14]:
    Pending block should not be passed: acquaintances != friends.


    =========
    Omissions
    =========

      1) Omission: I am not sure what a pizza is
    test: should have pizzas for party(NPCRobotTest)
    test/npc_robot_test.rb:43:in `block in <class:NPCRobotTest>'


    ========
    Pendings
    ========

      1) Pending: pended.
    test: should not dance(NPCRobotTest)
    test/npc_robot_test.rb:23:in `block in <class:NPCRobotTest>'


    =============
    Notifications
    =============

      1) Notification: Claptrap
    test: should have a cool nickname(NPCRobotTest)
    test/npc_robot_test.rb:29:in `block in <class:NPCRobotTest>'

      2) Notification: NPCRobotTest#test: should have pizzas for party was redefined
    test: should have pizzas for party(NPCRobotTest)
    test/npc_robot_test.rb:42:in `<class:NPCRobotTest>'
    test/npc_robot_test.rb:10:in `<main>'



    Finished in 0.013893
    4 tests, 3 assertions, 2 failures, 0 errors, 1 pendings, 1 omissions, 2 notifications

The characters P, O, and N that are reported in the last column map to calls to
`pend`, `omit`, and `notify` inside of the test.  (These are part of test-unit).

Usage:

* put lineman in you bundle or otherwise install the gem
* require 'test/unit/ui/statistics'
* `Test::Unit::AutoRunner.default_runner = 'lineman'`
* You could also specify --runner on the command line or your test-unit.yml
* Run your tests!

Make pull requests and be friendly.


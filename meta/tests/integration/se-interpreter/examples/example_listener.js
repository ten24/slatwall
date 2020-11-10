var util = require('util');

/** An example interpreter listener factory with all listener functions implemented. */
exports.getInterpreterListener = function(testRun) {
  return {
    'startTestRun': function(testRun, info) {
      console.log("Listener: test run starting!");
      console.log("Listener: success: " + info.success);
      console.log("Listener: error: " + util.inspect(info.error));
    },
    'endTestRun': function(testRun, info) {
      console.log("Listener: test run ending!");
      console.log("Listener: success: " + info.success);
      console.log("Listener: error: " + util.inspect(info.error));
    },
    'startStep': function(testRun, step) {
      console.log("Listener: step starting!");
      console.log("Listener: " + JSON.stringify(step));
    },
    'endStep': function(testRun, step, info) {
      console.log("Listener: step ending!");
      console.log("Listener: " + JSON.stringify(step));
      console.log("Listener: success: " + info.success);
      console.log("Listener: error: " + util.inspect(info.error));
    },
    'endAllRuns': function(num_runs, successes) {
      console.log("Listener: all runs ended!");
      console.log("Listener: number of runs was " + num_runs);
      console.log("Listener: number of successful runs was " + successes);
    }
  };
};

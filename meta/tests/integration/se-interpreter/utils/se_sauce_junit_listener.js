/**
A listener that reports test success/failure to Sauce OnDemand.
Also this listener outputs jUnit style xml

Listener is based on 2 examples:
For JUnit: https://github.com/davidlinse/se-interpreter/blob/integration/listener/junit-listener.js
For Sauce: https://github.com/Zarkonnen/se-interpreter/blob/master/utils/sauce_listener.js

Example usage:
  node interpreter.js --browser-browserName=firefox \
                      --listener ./reporter/junit-reporter.js \
                      --listener-path ./reports/result.xml \
                      examples/tests/get.json

  Uses the value of "testRun.browserOptions.browserName" as "package" value.

  You can also use --listener-silent=true to prevent the default listener
  output from happening, just like the --silent command.
*/

var https = require('https');
var util = require('util');
var builder = require('xmlbuilder');
var fs      = require('fs');
var pathLib = require('path');
var ensure  = require('ensureDir');

function Listener(testRun, params, interpreter_module) {
  // Sauce
  this.testRun = testRun;
  this.originalListener = interpreter_module.getInterpreterListener(testRun, params, interpreter_module);

  // Junit
  Listener.instances = (this._uid = Listener.instances + 1);

  var reportFileName = 'junit-' + testRun.name /* +'-'+ this._uid */ +'.xml';

  this._params      = JSON.parse(JSON.stringify(params));
  this._params.path = params.path ?
                      pathLib.join(params.path, reportFileName) :
                      pathLib.join(process.cwd(), reportFileName);

  this._suite = null;
  this._step  = null;
  this._runnr = interpreter_module;

  this._name = '['+ testRun.name +'] ';
};

// Junit
Listener.instances = 0;

Listener.prototype.startTestRun = function(testRun, info) {
  // Sauce
  this.sessionID = testRun.wd.sessionID;
  this.username = testRun.browserOptions.username;
  this.accessKey = testRun.browserOptions.accessKey;

  // jUnit
  if (!info.success) {
    console.log('[ERROR] '+ this._name +' - Could not start: '+ util.inspect(info));
    return;
  }
  this._suite = getSuite(testRun);
  
  // Snapshot reset
  console.log('DB Snapshot Reset Started');
  var sys = require('sys')
  var exec = require('child_process').exec;
  
  function puts(error, stdout, stderr) { 
  	sys.puts(stdout) 
  	console.log('DB Snapshot Reset Complete');
	if (this.originalListener) { this.originalListener.startTestRun(testRun, info); }
	}
  console.log("sudo lxc-attach -n '$(docker inspect --format '{{.Id}}' slatwallci_slatwalldb_1)' -- mysql --user=root --password=CiPassword Slatwall < /home/ubuntu/slatwall/slatwall_test_starting_point_snapshot.sql");
  exec("sudo lxc-attach -n '$(docker inspect --format '{{.Id}}' slatwallci_slatwalldb_1)' -- mysql --user=root --password=CiPassword Slatwall < /home/ubuntu/slatwall/slatwall_test_starting_point_snapshot.sql && echo OK || echo Failed", puts);
  
  // Base
};

Listener.prototype.endTestRun = function(testRun, info) {
  // Sauce
  var data = null;
  if (info.error) {
    data = JSON.stringify({'passed': info.success, 'custom-data': {'interpreter-error': util.inspect(info.error)}});
  } else {
    data = JSON.stringify({'passed': info.success});
  }

  var options = {
    'hostname': 'saucelabs.com',
    'port': 443,
    'path': '/rest/v1/' + this.username + '/jobs/' + this.sessionID,
    'method': 'PUT',
    'auth': this.username + ':' + this.accessKey,
    'headers': { 'Content-Type': 'application/json', 'Content-Length': data.length }
  };

  var req = https.request(options);

  req.on('error', function(e) {
    console.error(e);
  });

  req.write(data);
  req.end();

  // jUnit
  var report = generateReport(this._suite, testRun);
  if (!info.success) {
    console.log('[ERROR] '+ this._name +' '+ util.inspect(info));
  }
  writeReport(this._name, sanitize(this._params.path), report);

  // Base
  if (this.originalListener) { this.originalListener.endTestRun(testRun, info); }
};

Listener.prototype.startStep = function(testRun, step) {
  // jUnit
  this._step = getStep(step);
  this._step.name = step.name || testRun.name || '';

  // Base
  if (this.originalListener) { this.originalListener.startStep(testRun, step); }
};

Listener.prototype.endStep = function(testRun, step, info) {
  // jUnit
  logOnError(this._name, info, step);
  updateStep(this._step, info, step);
  updateSuite(this._suite, info, step);
  if (step.noreport === undefined) {
    this._suite.steps.push(this._step);
  }
  this._step = null;

  // Base
  if (this.originalListener) { this.originalListener.endStep(testRun, step, info); }
};

Listener.prototype.endAllRuns = function(num_runs, successes) {
  if (this.originalListener) { this.originalListener.endAllRuns(num_runs, successes); }
};

exports.getInterpreterListener = function(testRun, options, interpreter_module) {
  return new Listener(testRun, options, interpreter_module);
};

// JUnit Helper Functions

var updateTime = function updateTime (/* step or suite */ subject) {
  subject.time = new Date() - subject.time;
};

var updateAssertions = function updateAssertions (subject, type) {
  subject.assertions += Number(/(assert|verify)/.test(type));
};

var formatTime = function formatTime (subject) {
  subject.time = parseFloat(subject.time / 1000, 10).toFixed(3);
};

var getSuite = function getSuite (testRun) {
  return {
    package: testRun.browserOptions.browserName || '',
    name: sanitize(testRun.name),
    tests: 0,
    errors: 0,
    failures: 0,
    assertions: 0,
    skipped: 0,
    time: new Date().getTime(),
    steps: []
  };
};

var getStep = function getStep (step) {
  return {
    classname: step.name || step.type,
    name: step.name || '',
    assertions: 0,
    time: new Date(),
    failure: {
      type: null,
      text: null
    }
  };
};

var updateSuite = function updateSuite (suite, info, step) {
  if (!!step.noreport && step.noreport === 'true') {
    return;
  }

  if (!info.success) {
    suite.failures += 1;
  }

  suite.tests += 1;
  updateAssertions(suite, step.type);
};

var updateStep = function updateStep (_step, info, step) {
  updateTime(_step);
  updateFailures(_step, info, step);
};

var updateFailures = function updateFailures (_step, info, step) {
  if (!info.success) {
    _step.failure.type = step.type;
    _step.failure['#text'] = step.name || step.type;
  }
};

var addAttributes = function add (node, data) {
  Object.keys(data).forEach(function (key) {
    node.att(key, data[key]);
  });
};

var generateReport = function generateReport (suite) {

  var xml = builder.create('testsuite', null, {
    version: '1.0',
    encoding: 'UTF-8',
    standalone: true
  });

  updateTime(suite);
  formatTime(suite);

  suite.steps.forEach(function (testCase) {
    formatTime(testCase);
    var node = xml.ele('testcase');

    if (!!testCase.failure.type) {
      node.ele('failure', {'type': testCase.failure.type}, testCase.failure.text);
    }
    delete testCase.failure;
    addAttributes(node, testCase);
  });

  delete suite.steps;
  addAttributes(xml, suite);

  return xml;
};

var writeReport = function writeReport (name, path, /* xmlbuilder*/ data) {

  var dirname  = pathLib.dirname(path);

  ensure(dirname, 0777, function ensureDirCB (err) {
    if (err) {
      console.log('[Error] '+ util.inspect(err));
      return;
    }

    fs.writeFileSync(path, data.toString({pretty:true}));
    // console.log(name + ' - Report saved to %s', path);
  });
};

var sanitize = function sanizite(reportName){
  return reportName.replace(/,/g, '').replace(/\s+/g, '_');
};

var log = function log (name, status, step, /*null*/ message) {
  if (step.noreport) { return; }
  message = (status.success ? '[PASS] ' : '[FAIL] ') + step.name || '';
  console.log(name +' - '+ message);
};

var logOnError = function logOnError (name, status, step, /*null*/ message) {
  if (status.success === true) { return; }
  message = '[FAIL] ' + (name || '') + (' ' + (step.step || '')) + ' '+ step.name;
  console.log(message);
};

se-interpreter [![Build Status](https://api.travis-ci.org/Zarkonnen/se-interpreter.png)](http://travis-ci.org/Zarkonnen/se-interpreter)
==============

This is a command-line tool for interpreting [Selenium Builder](http://www.sebuilder.com) JSON script files, based on [node](http://nodejs.org/) and the [wd](https://github.com/admc/wd) Javascript client driver for [Selenium 2](http://seleniumhq.org/). There is also a [Java-based counterpart](https://github.com/sebuilder/se-builder/wiki/Se-Interpreter).

Using Selenium Builder, [GitHub for Selenium Builder](http://zarkonnen.github.com/sb-github-integration/), se-interpreter, [Travis](http://travis-ci.org/), and [Sauce OnDemand](http://saucelabs.com/), you can set up a completely, er, cloud-based continuous integration UI testing system for your website.

se-interpreter is developed by [David Stark](mailto:david.stark@zarkonnen.com) at the behest of [Sauce Labs](http://saucelabs.com/), and licensed under the Apache License, Version 2.0:

    Copyright 2013 Sauce Labs

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

# Documentation

## Installation
Install se-interpreter through [npm](https://npmjs.org/) by invoking

    sudo npm install -g se-interpreter

## Basic usage
First, make sure you have a local [Selenium Server](http://seleniumhq.org/download/) running. Then, invoke se-interpreter:

    se-interpreter examples/tests/get.json

This should start up an instance of Firefox, navigate to [the Selenium Builder site](http://sebuilder.github.com/se-builder/), and then exit successfully.

You can specify multiple commands:

    se-interpreter examples/tests/get.json examples/tests/assertTitle.json

The second one of these tests is intended to fail.

And you can use glob syntax to specify whole directories:

    se-interpreter examples/tests/a_directory/*

Again, the second test is intended to fail.

## Suites

You can also specify paths to suites, which will execute all scripts in them.

## Command-line options
* `--quiet` Disables printing of information about each step and script. Only print step outputs and the final result are reported.
* `--noPrint` Disables print step output.
* `--silent` Disables all non-fatal-error text output.
* `--parallel=`_n_ Runs _n_ tests in parallel. The default is no parallel execution.
* `--driver-`_x_`=`_y_ Passes _y_ as the webdriver parameter _x_. Example: `--driver-host=mywebdriver.mycompany.com`.
* `--browser-`_x_`=`_y_ Passes _y_ as the browser parameter _x_. Example: `--browser-browserName=chrome`.

You can specify multiple `--browser-browserName` arguments, and the tests will be played back on each browser specified.

## Playing back tests on Sauce OnDemand
To run your tests on Sauce OnDemand, use the following parameters, with your Sauce username and access key:

    --driver-host=ondemand.saucelabs.com --driver-port=80 --browser-username=[?] --browser-accessKey=[?]

You can run multiple tests in parallel on OnDemand, but note that if `--parallel` is set to more than the maximum number of parallel tests for your account, __the interpreter will hang indefinitely__. For a free account, this maximum number is two.

## Configuration files
Instead of specifying the scripts/suites and configuration on the command-line, you can use JSON-based configuration files. An example:

    {
      "type": "interpreter-config",
      "configurations": [
        {
          "settings": [
            {
              "browserOptions": {
                "browserName": "firefox"
              }
            },
            {
              "browserOptions": {
                "browserName": "chrome"
              }
            }
          ],
          "scripts": [
            "examples/tests/printTitle.json",
            "examples/tests/a_directory/*"
          ]
        }
      ]
    }

This configuration file runs `printTitle.json` and the two tests in `a_directory/`, on both Firefox and Chrome. The format works as follows:

* The root object contains two properties: `"type": "interpreter-config"`, and `"configurations"`, which is a list of configurations.
* Each configuration is an independent set of tests to run. It also contains two properties: `"settings"`, which is a list of settings and `"scripts"`, which is a list of paths for the scripts to execute.
* Each settings object may contain `"browserOptions"`, which are treated like `--browser` command line arguments, and `"driverOptions"`, which are treated like `--driver` command line arguments.
* All scripts within a configuration are run with all settings in that configuration.
* `${ENV_VAR_NAME}` expressions are substituted for the value of the specified environment variable.

The following configuration file runs the same three tests on Sauce OnDemand, assuming you have set the `SAUCE_USERNAME` and `SAUCE_ACCESS_KEY` environment variables.

    {
      "type": "interpreter-config",
      "configurations": [
        {
          "settings": [
            {
              "driverOptions": {
                "host": "ondemand.saucelabs.com",
                "port": 80
              },
              "browserOptions": {
                "browserName": "firefox",
                "username": "${SAUCE_USERNAME}",
                "accessKey": "${SAUCE_ACCESS_KEY}"
              }
            }
          ],
          "scripts": [
            "examples/tests/printTitle.json",
            "examples/tests/a_directory/*"
          ]
        }
      ]
    }

## Travis integration
se-interpreter integrates with [Travis](https://travis-ci.org/) really easily. The [interpreter-travis-example](https://github.com/Zarkonnen/interpreter-travis-example) repo is an example setup you can fork. The details:

To set up a repository to run its Builder tests on Travis, add a `.travis.yml` file to the repository root that looks something like this:

    language: node_js
    before_script:
        - "npm install -g se-interpreter"
    script:
        - "se-interpreter my_interpreter_config.json"
    env:
        global:
            - SAUCE_USERNAME=<username>
            - secure: <encrypted SAUCE_ACCESS_KEY>

For `my_travis_config.json` use a config file like the second example above. If you are setting up a web server on Travis and using Sauce Connect from Travis to Sauce Labs, then your driverOptions host must be 'localhost' and your port must be '4445'. Note that this configuration uses [Travis' support for encrypting environment variables](http://about.travis-ci.org/docs/user/encryption-keys/) to prevent having to put your access key into a publicly visible place.

## Listeners
Using `--listener=`_path-to-listener_, you can specify a module that provides listeners that se-interpreter will attach to each script being run. An example listener module implementation is provided in `examples/example_listener.js`. A listener module should export a function called `getInterpreterListener` that returns an object that may define any of the following functions:

* `startTestRun(testRun, info)` Called when a test run has started.
* `endTestRun(testRun, info)` Called when a test has completed.
* `startStep(testRun, step)` Called when a step is about to start.
* `endStep(testRun, step, info)` Called when a step has completed.
* `endAllRuns(num_runs, successes)` Called when all tests have completed.

The `info` objects have two keys: `success`, which is `true` or `false`, and `error`, which may contain an exception if `success` is false. The `interpreter` module itself contains a listener implementation which is used as the default listener if `--quiet` or `--silent` is not specified.

## Data sources
You can specify additional data source modules to support custom data-driven testing sources using `--dataSource=`_path-to-datasource_. An example data source module implementation is provided in `examples/example_datasource.js`.

## Adding extra step types
There are two ways of adding support for extra step types to se-interpreter.

First, you can add extra files into the `step_types` directory in the module. See the contents of this directory for examples. The directory contains both files like `get.json`, which implements the `get` step, and `Title.json`, which implements a way to get at the current title, and is used by generic assert/verify/store/waitFor implementations.

Second, you can specify a `--executorFactory=`_path-to-factory_ command line argument. The executor factory is a module that should export a function called `get(stepType)`, returning either an step type implementation/getter, or null if the module can't supply an implementation for playing back a step called `stepType`. See `examples/example_factory.js` for a simple example.

## Using a proxy
You can specify a proxy for the browser to use by putting a [proxy object](https://code.google.com/p/selenium/wiki/DesiredCapabilities) into the browser settings. Example using a proxy at localhost:

    {
      "type": "interpreter-config",
      "configurations": [
        {
          "settings": [
            {
              "browserOptions": {
                "browserName": "firefox",
                "proxy": {
                  "proxyType": "manual",
                  "httpProxy": "localhost:8085"
                }
              }
            }
          ],
          "scripts": [
            "examples/tests/get.json"
          ]
        }
      ]
    }

## Using se-interpreter as a module
It's also possible to use se-interpreter as a module in other node code, using `require('se-interpreter')`. To try this out, install se-interpreter locally as a node module:

    npm install se-interpreter

Then, start up a Selenium Server, enter `node` and drive a simple interpreter session from the command line:

    var si = require('se-interpreter');
    var tr = new si.TestRun({"steps": [{"type":"get", "url":"http://www.google.com"}]}, "Go to Google");
    tr.listener = si.getInterpreterListener(tr);
    tr.start();
    tr.next();
    tr.end();

## Getting help
Feel free to mail me at david.stark@zarkonnen.com with questions (including "How do I get this to work?), suggestions, and feedback. You can also [report issues on GitHub](https://github.com/Zarkonnen/se-interpreter/issues). For issues with Sauce OnDemand, [contact the Sauce help desk](http://support.saucelabs.com/home).

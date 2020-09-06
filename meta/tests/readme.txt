SETUP
-----

In order for the tests inside of this folder to work you will need to have MXUnit Installed on your machine with a mapping inside of your CFIDE.
In addition, if you would like to have the tests inside of the "functional" folder to work, you will need to have CFSelenium installed on your machine again with a mapping to it inside of your CFIDE.

The easiest way to run this test suite is to open this project inside of Eclipse (or CFBuilder).  You will want to install the MXUnit plugin for eclipse that can be found at http://mxunit.org/.
Once it is installed you will want to right click on your project in Eclipse


OVERVIEW OF TESTS
-----------------

/Coverage - This is a series of tests that are designed to make sure there is at least a minimal level of testing in place when new components / files get added to the project
	/core - Tests some of the more low level aspects of the application
	/entity - Test the entities inside of Slatwall, the default settings, logical methods, and other functions
	/service - Intented to test the functions inside of the Slatwall services
	/dao - Test the Data Access Layer methods
  
/Unit - This folder holds all of the unit tests that cover the core of the Slatwall model, and some of the other framework / application level aspects

/Functional - These tests are designed to execute as an automated browser against the finished functionality of the application.



GUIDELINES
----------

-- New code should be accompanied by tests

-- Tests should live in a file named after the Component Under Test
  - eg, do not name a test case "Bug105Test" in a file named "BugTests.cfc"
  - if Bug105 manifests in the OrderPayment component, then the test belongs in OrderPaymentTest and should be named meaningfully, i.e. "orderPaymentShouldNotCompleteWhenInvalid()"
  
-- Meaningful assertions are key to a solid regression test suite
  - http://wiki.mxunit.org/display/default/What+to+put+in+your+tests+%28Assertion+Patterns%29
  - For example, rather than assert something isn't null, or that it's a simple value, assert exactly what it should be
  
-- If tests require certain state in order to be meaningful, guard against that condition
  - For example, if a test requires at least 2 orders in the system:
    assert(smartList.getRecordsCount() >= 2, "Not enough data present to adequately test. Failing...");
      
-- Do not access external scopes (session, request, etc) in tests.  

-- Tests should be self contained
  - Never rely on state from another test
    
-- Use DataProviders to test multiple inputs to the same method under test
  - http://wiki.mxunit.org/display/default/Data+driven+testing+with+MXUnit+dataproviders  
  
-- Mutation test test your components! 
  - http://en.wikipedia.org/wiki/Mutation_testing
  - For example, in the component under test, IF statements and LOOPs are great candidates
    - Change IF statements (reverse the operator, change the condition from true to false, etc) and run tests... ensure failures occur
    - Change LOOPs by modifying the loop condition and run tests... ensure failures occur
    - If failures do not occur, that means that logic is untested
    - When tests are written to verify the logic, return the component under test to its valid state, and the tests should pass


-- Perform cleanup in setup/teardown or beforetests/aftertests, not in tests themselves

 "If I can create the object without any dependencies and test it, it's probably unit testable". -- Greg Moser

PRODUCTIVITY
------------

  - assertEquals() is particularly helpful compared with assert() (see SmartListTest)
    - Enables "Comparison View" in Eclipse Plugin
  - MXUnitAssertionExtensions provides some assertion helpers, such as assertIsEmptyArray(), which can save some typing.
    - uses assertEquals under the hood so you get that benefit as well
  - use debug() and request.debug()	
    - http://wiki.mxunit.org/display/default/Using+request.debug%28%29
  - Use custom assertions for assertion reuse: http://wiki.mxunit.org/display/default/Writing+Custom+Assertions
  - Use the Eclipse snippets in the mxunit/eclipse/snippets directory
  - Get cozy with the Eclipse Plugin: http://wiki.mxunit.org/display/default/Using+the+Eclipse+Plugin
  - Use injectMethod() for simple mocking: http://wiki.mxunit.org/display/default/Using+injectMethod+for+simple+mocking
  - Use Decorators for extending MXUnit itself: http://blog.bittersweetryan.com/2012/01/using-new-orderedtestdecorator-in.html
    
 FUNCTIONAL TEST GUIDELINES
 --------------------------   
 
 **Running Tests**
 
 - First, copy meta/tests/conf/sample into a file named after your computer
   - eg if your computer name is "sparta", name the file "sparta.conf"
   - Modify that file to contain the base URL you're testing, usernames/passwords, etc
 - If you're running tests frequently, it's much faster to keep the selenium server running rather than have the tests
   stop and start it:
   
   $ java -jar ""c:\dev\projects\wwwroot\cfselenium\Selenium-RC\selenium-server-standalone-2.42.1.jar""
 
 **Writing Tests**
 
 -- Selenium docs at http://release.openqa.org/selenium-remote-control/0.9.0/doc/java/
 -- Follow the Page Object Model (POM)
   - Selenium commands to drive the browser belong in Page Objects
   - Assertions belong in tests
     - limited use of selenium commands in tests, eg getText(), getTitle(), etc
   - Steven Erat has a great presentation 
     - http://www.slideshare.net/stevenerat/automated-system-testing-by-steven-erat-13122937
     - sample code: https://www.dropbox.com/s/3sdet2yfqn8uyi7/UITests.zip
 -- Page Objects (PO) needn't represent an entire page
   - a PO might represent a sidebar, or a navigation bar, or some other widget that's part of a screen
 -- If additional configuration is required, use the .conf file rather than hard-coding config in the tests
 -- DataProviders are just as useful in Browser tests as they are in unit tests
   - See LoginPageTest.cfc for example
   - Use can even use spreadsheets as dataproviders, so non-devs can contribute
   - Particularly useful for Fuzz Testing
     - Throw many different payloads at form fields for XSS testing, for example
 -- Learning about "locators" is critical: http://release.openqa.org/selenium-remote-control/0.9.0/doc/java/
 -- Element IDs and NAMEs simplify "locators" considerably, compared with CSS or XPATH
 -- Element presence and visibility will eventually cause problems... especially with ajax where elements are loaded async
   - cfselenium's "waitForElementPresent", "waitForElementVisible", and "waitForElementNotVisible" are quite helpful here
 -- Take advantage of beforeTests()
   - eg ensure new login before each TestCase
 -- sometimes, Selenium is faster than what the browser can handle. Use selenium.setSpeed() to slow down selenium in these cases
   - always be sure to set it back to 0
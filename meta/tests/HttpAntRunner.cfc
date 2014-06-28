component extends="mxunit.runner.HttpAntRunner" {
	
	remote function run() {
		// Setup Components
		var slatwallApplication = createObject("component", "Slatwall.Application");
		var testUtility = createObject("component", "Slatwall.meta.tests.TestUtility").init( slatwallApplication );
		
		// Reload Slatwall
		slatwallApplication.reloadApplication();
		
		// Make sure all the test data is up to date
		testUtility.updateTestData();
		
		super.run();
	}
	
} 
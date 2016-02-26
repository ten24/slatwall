<cfcomponent extends="mxunit.runner.HttpAntRunner">

	<cfsetting requesttimeout="1800">

	<cfscript>
		remote function run() {
			// Create slatwall application
			var slatwallApplication = createObject("component", "Slatwall.Application");

			// Reload Slatwall
			slatwallApplication.reloadApplication();
			slatwallApplication.bootstrap();

			// Create test utility
			var testUtility = createObject("component", "Slatwall.meta.tests.ConfigureTestUtility").init( slatwallApplication );

			// Make sure all the test data is up to date
			//testUtility.updateTestData();

			super.run(argumentCollection=arguments);
		}
	</cfscript>

</cfcomponent>

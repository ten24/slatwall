<cfcomponent extends="mxunit.runner.HttpAntRunner">

	<cfsetting requesttimeout="1800">

	<cfscript>
		remote function run() {
			// Create slatwall application
			var slatwallApplication = createObject("component", "Slatwall.Application");

			// Reload Slatwall
			slatwallApplication.reloadApplication();
			slatwallApplication.bootstrap();

			super.run(argumentCollection=arguments);
		}
	</cfscript>

</cfcomponent>

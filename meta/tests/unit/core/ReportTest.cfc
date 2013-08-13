component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {
	
	// @hint put things in here that you want to run befor EACH test
	public void function setUp() {
		super.setup();
		
		variables.hibachiReport = request.slatwallScope.getTransient( "HibachiReport" ).init();
	}
	
	
}
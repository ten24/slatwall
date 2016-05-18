
component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {
	public void function setUp() {
		super.setup();
		
		variables.service = request.slatwallScope.getService("hibachiRBService");
	}
	
	public void function getRBKeyTest() {

		var found=true;
		var rbkey = variables.service.getRBKey('admin.entity.createloyaltyterm');
		if(right(rbkey,8) == '_missing') {
				found = false;
			request.debug(rbkey);	
		}
		assert(found);
	}
public void function getAggregateResourceBundle() 
{
	var aggregateBundle= variables.service.getAggregateResourceBundle(locale="en_gb");
	
	assert(StructKeyExists(aggregateBundle,"admin.entity.createmanualoutadjustment"));
}
}
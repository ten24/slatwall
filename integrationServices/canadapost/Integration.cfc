component accessors="true" output="false" displayname="Canada Post" extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface" {
	
	public any function init() {
		return this;
	}
	
	public string function getIntegrationTypes() {
		return "shipping";
	}
		
	public string function getDisplayName() {
		return "Canada Post";
	}
}
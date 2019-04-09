component accessors="true" output="false" extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface" {

	public string function getIntegrationTypes() {
		return "data";
	}

	public string function getDisplayName() {
		return "Monat";
	}
    
    public struct function getSettings() {
		return {};
	}
}

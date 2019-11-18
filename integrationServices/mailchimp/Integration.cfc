component accessors="true" output="false" extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface" {

	public string function getIntegrationTypes() {
		return "fw1";
	}

	public string function getDisplayName() {
		return "Mailchimp API";
	}
    
    public struct function getSettings() {
		return {
	        mailChimpAPIKey = {fieldType="password", encryptValue=true},
	        mailChimpListID = {fieldType="text", encryptValue=false},
	        mailChimpDataCenter = {fieldType="text", encryptValue=false},
			prosperworksAPIKey = {fieldType="password", encryptValue=true},
			prosperworksAPIEmail = {fieldType="text"}
		};
		// productAvailabilityNotification={fieldType="select"}
	}

}

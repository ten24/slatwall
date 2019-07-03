component accessors="true" output="false" extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface" {

    public any function init() {
        return this;
    }

    public string function getDisplayName() {
        return "Monat";
    }

    public string function getIntegrationTypes() {
        return "fw1,data";
    }

    public struct function getSettings() {
        return {
			siteDaysAfterMarketPartnerEnrollmentFlexshipCreate = {fieldtype="text", defaultValue=0, validate={dataType="numeric", required=true, minValue=0}},
		};
    }
    
    public array function getMenuItems(){
        return [];
    }

	public array function getEventHandlers() {
		return [];
	}
}

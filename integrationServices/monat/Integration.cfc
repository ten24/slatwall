component accessors="true" output="false" extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface" {

    public any function init() {
        return this;
    }

    public string function getDisplayName() {
        return "Monat";
    }

    public string function getIntegrationTypes() {
        return "fw1";
    }

    public struct function getSettings() {
        return {
		};
    }
    
    public array function getMenuItems(){
        return [];
    }

	public array function getEventHandlers() {
		return [];
	}
}

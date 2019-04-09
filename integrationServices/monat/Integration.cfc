component accessors="true" output="false" extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface" {

<<<<<<< HEAD
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
=======
	public string function getIntegrationTypes() {
		return "data";
	}

	public string function getDisplayName() {
		return "Monat";
	}
    
    public struct function getSettings() {
		return {};
>>>>>>> 1537e333fc... WIP promoz
	}
}

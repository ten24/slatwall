component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="orderReturn";
	
	// Data Properties
	property name="locationID" hb_formFieldType="select" hb_rbKey="entity.location";
	property name="packingSlipNumber" hb_rbKey="entity.stockReceiver.packingSlipNumber";
	property name="boxCount" hb_rbKey="entity.stockReceiver.boxCount";
	property name="orderReturnItems" type="array" hb_populateArray="true";
	
	public any function getLocationIDOptions() {
		if(!structKeyExists(variables, "locationIDOptions")) {
			sl = getService("locationService").getLocationSmartList();
			sl.addSelect('locationName', 'name');
			sl.addSelect('locationID', 'value');
			variables.locationIDOptions = sl.getRecords();
		}
		return variables.locationIDOptions;
	}
	
}
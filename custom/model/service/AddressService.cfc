component extends="Slatwall.model.service.AddressService" accessors="true" output="false" {
	
	public any function getStateOptionsByCountryCode( required string countryCode ) {
		var stateCodeList = getService('AddressService').getStateCollectionList();
		stateCodeList.addFilter( 'country.countryCode', countryCode );
		stateCodeList.setDisplayProperties('stateName|name,stateCode|value');
		
		return stateCodeList.getRecords();
	}

}

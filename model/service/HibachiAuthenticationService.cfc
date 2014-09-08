component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiAuthenticationService" {
	
	property name="integrationService" type="any";
	
	public array function getAuthenticationSubsystemNamesArray() {
		
		var snarr = listToArray(getApplicationValue("hibachiConfig").authenticationSubsystems);
		
		var integrationSmartlist = this.getIntegrationSmartList();
		integrationSmartlist.addFilter('installedFlag', '1');
		integrationSmartlist.addLikeFilter('integrationTypeList', '%fw1%');
		integrationSmartlist.addSelect('integrationPackage', 'subsystem');
		
		for(var record in integrationSmartlist.getRecords()) {
			arrayAppend(snarr, record['subsystem']);
		}
		
		return snarr; 
	}
}

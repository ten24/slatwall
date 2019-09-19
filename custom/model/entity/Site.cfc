component {
    property name="siteAvailableLocales" persistent="false";
    
    public string function getSiteAvailableLocales() {
    	if ( ! structKeyExists( variables, 'siteAvailableLocales' ) ) {
    		variables.siteAvailableLocales = getHibachiScope().setting('siteAvailableLocales');
    	}
    	return variables.siteAvailableLocales;
    }
    
    public any function getDefaultCollectionPropertiesList(){
		return "siteID,siteName,siteCode,resetSettingCache,flagImageFilename,domainNames,allowAdminAccessFlag";
	}
	
	public any function getDefaultCollectionProperties(){
		var includesList = this.getDefaultCollectionPropertiesList();
		return super.getDefaultCollectionProperties( includesList, '' );
	}
}

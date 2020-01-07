component {
	property name="siteAvailableLocales" persistent="false";
	property name="ownerAccount" persistent="false";
	
	
	public any function getOwnerAccount() {
		if(structKeyExists(variables, 'ownerAccount')) {
			return variables.ownerAccount;
		}
		

		var accountCode = getHibachiScope().getSubdomain();
		if(len(accountCode)){
			var account = getService('accountService').getAccountByAccountCode(accountCode);
			
			if(!isNull(account)){
				variables.ownerAccount = account;
				return variables.ownerAccount;
			}
		}
	
	}
	
	public string function getSiteAvailableLocales() {
		if ( ! structKeyExists( variables, 'siteAvailableLocales' ) ) {
			variables.siteAvailableLocales = setting('siteAvailableLocales');
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

component {
	property name="siteAvailableLocales" persistent="false";
	property name="ownerAccount" persistent="false";
	
	
	public any function getOwnerAccount() {
		if(structKeyExists(variables, 'ownerAccount')) {
			return variables.ownerAccount;
		}
		

		var domain = getHibachiScope().getCurrentDomain();
		var regex = '^([^.]+)\.[a-z]+\.(com|local|ten24dev\.com)$';
		/*
		Matches:
			username.monat.local
			username.monatglobal.com
			username.mymonat.com
			username.monat.ten24dev.com
		*/
		
		if(reFindNoCase(regex, domain)){
			var accountCode = reReplaceNoCase(domain, regex, '\1');
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

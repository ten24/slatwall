component output="false" accessors="true" extends="Slatwall.model.transient.HibachiScope" {
	
	public any function getCurrentRequestSite() {
		
		if(!structKeyExists(variables,'currentRequestSite')){
			
			if ( len( getContextRoot() ) ) {
				var cgiScriptName = replace( CGI.SCRIPT_NAME, getContextRoot(), '' );
				var pathInfo = replace( CGI.PATH_INFO, getContextRoot(), '' );
			} else {
				var cgiScriptName = CGI.SCRIPT_NAME;
				var pathInfo = CGI.PATH_INFO;
			}
			
			if ( len( pathInfo ) > len( cgiScriptName ) && left( pathInfo, len( cgiScriptName ) ) == cgiScriptName ) {
				// canonicalize for IIS:
				pathInfo = right( pathInfo, len( pathInfo ) - len( cgiScriptName ) );
			} else if ( len( pathInfo ) > 0 && pathInfo == left( cgiScriptName, len( pathInfo ) ) ) {
				// pathInfo is bogus so ignore it:
				pathInfo = '';
			}
			
			//take path and  parse it
			var pathArray = listToArray(pathInfo,'/');

			if(arrayLen(pathArray)){
				variables.currentRequestSite = getService('siteService').getSiteBySiteCode('mura-'&pathArray[1]);
			}else if( !structKeyExists(request, 'cfcbase') || request.cfcbase != 'Slatwall'){
				variables.currentRequestSite = getService('siteService').getSiteBySiteCode('mura-default');
			}
				
			if(isNull(variables.currentRequestSite)){
				var domain = getCurrentDomain();
				variables.currentRequestSite = getService('siteService').getSiteByDomainName(domain);
				setCurrentRequestSitePathType('domain');	
			}else{
				setCurrentRequestSitePathType('sitecode');
			}
		}
		
		if(!isNull(variables.currentRequestSite)){
			return variables.currentRequestSite;
		}
	}
	
	public any function getSubdomain() {
		var domain = getCurrentDomain();

		var regex = '^([^.]+)\.[a-z]+\.(com|local|ten24dev\.com|ten24\.io)$';
		var subdomain = '';
		/*
		Matches:
			username.monat.local
			username.monatglobal.com
			username.mymonat.com
			username.monat.ten24dev.com
			username.monat.ten24.io
		*/
		if(reFindNoCase(regex, domain)){
			var subdomain = reReplaceNoCase(domain, regex, '\1');
		}
		return subdomain;
	}
	
	
	
	public any function getAvailableAccountPropertyList() {
		return ReReplace("accountID,firstName,lastName,company,remoteID,primaryPhoneNumber.accountPhoneNumberID,primaryPhoneNumber.phoneNumber,primaryEmailAddress.accountEmailAddressID,primaryEmailAddress.emailAddress,
			accountEmailAddresses.accountEmailAddressID, accountEmailAddresses.emailAddress,
			accountPhoneNumbers.accountPhoneNumberID, accountPhoneNumbers.phoneNumber,
			primaryAddress.accountAddressID,
			accountAddresses.accountAddressName,accountAddresses.accountAddressID,
			accountAddresses.address.addressID,accountAddresses.address.countryCode,accountAddresses.address.firstName,accountAddresses.address.lastName
			,accountAddresses.address.emailAddress,accountAddresses.address.streetAddress,accountAddresses.address.street2Address,
			accountAddresses.address.city,accountAddresses.address.stateCode,accountAddresses.address.postalCode,accountAddresses.address.countrycode,accountAddresses.address.name,
			accountAddresses.address.company,accountAddresses.accountAddressName,accountAddresses.address.phoneNumber,accountPaymentMethods.accountPaymentMethodID,accountPaymentMethods.creditCardLastFour,
			accountPaymentMethods.moMoneyWallet,birthDate,accountStatusType.systemCode,
			accountPaymentMethods.creditCardType,accountPaymentMethods.nameOnCreditCard,accountPaymentMethods.expirationMonth,primaryShippingAddress.address.streetAddress,primaryShippingAddress.address.street2Address,
			primaryShippingAddress.address.city,primaryShippingAddress.address.stateCode,primaryShippingAddress.address.postalCode,primaryShippingAddress.address.countrycode,accountPaymentMethods.expirationYear,primaryPaymentMethod.accountPaymentMethodID,
			accountPaymentMethods.accountPaymentMethodName,primaryShippingAddress.accountAddressID,primaryPaymentMethod.paymentMethodID,accountPaymentMethods.activeFlag,ownerAccount.firstName,primaryAddress.address.streetAddress,primaryAddress.address.street2Address,
			primaryAddress.address.city,primaryAddress.address.stateCode,primaryAddress.address.postalCode,ownerAccount.lastName,ownerAccount.createdDateTime,ownerAccount.primaryAddress.address.city,ownerAccount.primaryAddress.address.stateCode,ownerAccount.primaryAddress.address.postalCode,
			ownerAccount.primaryPhoneNumber.phoneNumber,ownerAccount.primaryEmailAddress.emailAddress,userName,languagePreference,primaryAddress.address.countrycode,ownerAccount.accountNumber","[[:space:]]","","all");
	}
	
	public any function getAvailableCartPropertyList(string cartDataOptions="full") {
		var values = super.getAvailableCartPropertyList(arguments.cartDataOptions);
		if(arguments.cartDataOptions == 'full'){
			values &=",purchasePlusTotal"
		}
		return values;
	}
	
	
	public any function getNexioFingerprintUrl() {
		var paymentIntegration = getService('integrationService').getIntegrationByIntegrationPackage('nexio');
		var responseData = paymentIntegration.getIntegrationCFC("Payment").getFingerprintToken();
		
		if(structKeyExists(responseData, 'token')){
			setSessionValue('kount-token', responseData['token']);
			return responseData['fraudUrl'];
		}
		
		return '';
	}
	
	
	/**
	 * Helper functions to handle the current-flexship, currentOwner/Account..., 
	 * to keep logic abstracted from Session/Cookie
	*/ 
	public any function getCurrentFlexship(){
		if(this.hasCookieValue('currentFlexshipID')){
			return this.getService('orderService')
						.getOrderTemplate( this.getCookieValue('currentFlexshipID') );
		}
	}
	
	public any function hasCurrentFlexship(){
		return this.hasCookieValue('currentFlexshipID');
	}
	
	public any function getCurrentFlexshipID(){
		return this.getCookieValue('currentFlexshipID');
	}
	
	public any function setCurrentFlexship(any orderTemplate){
		
		if(!IsNull(arguments.orderTemplate)){
			this.setCookieValue('currentFlexshipID', arguments.orderTemplate.getOrderTemplateID());
		} else {
			this.removeCurrentFlexship();
		}
	}
	
	public any function clearCurrentFlexship(){
		this.clearCookieValue('currentFlexshipID');
	}
	
	public struct function getHibachiConfig(){
		
		var currentRequestSite = getCurrentRequestSite();
		
		var hibachiConfig = {
			'action' : 'slatAction'
			,'basePartialsPath' : '/Slatwall/org/Hibachi/client/src/'
			,'baseURL' : '/Slatwall/'
			,'rbLocale' : getRBLocale()
			,'siteCode' : currentRequestSite.getSiteCode()
			,'currencyCode' : currentRequestSite.getCurrencyCode()
			,'countryCode' : getService('SiteService').getCountryCodeBySite(currentRequestSite) ?: 'US'
			,'contentID' : getContent().getContentID()
			,'accountID' : getAccount().getAccountID()
			,'siteOwner' : isNull(currentRequestSite.getOwnerAccount()) ? '' : currentRequestSite.getOwnerAccount().getAccountNumber() 
			,'instantiationKey' : getApplicationValue("instantiationKey")
			,'attributeCacheKey' : getService("hibachiService").getAttributeCacheKey()
			,'missingImagePath' : currentRequestSite.setting('siteMissingImagePath')
			,'currencies' : getService("currencyService").getAllActiveCurrencies(detailFlag=true)
		};
		
		
		return hibachiConfig;
	}
	
	
	
	public function getRedirectSiteCode(){
        
        	//No GEOIP checks if this is the users site. 
		if(!isNull(getAccount().getAccountCreatedSite()) && getAccount().getAccountCreatedSite().getCmsSiteID() == getCurrentRequestSite().getCmsSiteID()){
			return '';	
		}
	
		if(!structKeyExists(variables, 'redirectCountriesSiteMapping')){
			variables.redirectCountriesSiteMapping = {
				'GB' : 'uk',
				'PL' : 'pl',
				'IE' : 'ie',
				'AU' : 'au',
				'CA' : 'ca'
			};
		}
	
		var requestCountryOrigin = getSession().getCountryCode();
		
		//Land user on US site for IP's outside of recognized countries
		if(!listFindNoCase('GB,PL,IE,AU,CA,US', requestCountryOrigin) && getCurrentRequestSite().getCmsSiteID() != 'default' ){
			return 'default';
		}
		
		//Land user on recognized Country Site based on User's IP
		if(structKeyExists(variables.redirectCountriesSiteMapping, requestCountryOrigin) && getCurrentRequestSite().getCmsSiteID() != variables.redirectCountriesSiteMapping[requestCountryOrigin]){
			return variables.redirectCountriesSiteMapping[requestCountryOrigin];
		}
		
		return '';	
	}
	
}

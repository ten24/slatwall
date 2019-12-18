component output="false" accessors="true" extends="Slatwall.model.transient.HibachiScope" {
	
	property name="currentRequestSiteOwner";
	
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
				variables.currentRequestSiteOwner = getService('siteService').getSiteBySiteCode(pathArray[1]);
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
	
	public any function getAvailableAccountPropertyList() {
		return ReReplace("accountID,firstName,lastName,company,remoteID,primaryPhoneNumber.accountPhoneNumberID,primaryPhoneNumber.phoneNumber,primaryPhoneNumber.accountPhoneType,primaryEmailAddress.accountEmailAddressID,primaryEmailAddress.emailAddress,
			accountEmailAddresses.accountEmailAddressID, accountEmailAddresses.emailAddress,
			accountPhoneNumbers.accountPhoneNumberID, accountPhoneNumbers.phoneNumber,
			primaryAddress.accountAddressID,
			accountAddresses.accountAddressName,accountAddresses.accountAddressID,
			accountAddresses.address.addressID,accountAddresses.address.countryCode,accountAddresses.address.firstName,accountAddresses.address.lastName
			,accountAddresses.address.emailAddress,accountAddresses.address.streetAddress,accountAddresses.address.street2Address,
			accountAddresses.address.city,accountAddresses.address.stateCode,accountAddresses.address.postalCode,accountAddresses.address.countrycode,accountAddresses.address.name,
			accountAddresses.address.company,accountAddresses.accountAddressName,accountAddresses.address.phoneNumber,accountPaymentMethods.accountPaymentMethodID,accountPaymentMethods.creditCardLastFour,
			accountPaymentMethods.moMoneyWallet,
			accountPaymentMethods.creditCardType,accountPaymentMethods.nameOnCreditCard,accountPaymentMethods.expirationMonth,primaryShippingAddress.address.streetAddress,primaryShippingAddress.address.street2Address,
			primaryShippingAddress.address.city,primaryShippingAddress.address.stateCode,primaryShippingAddress.address.postalCode,primaryShippingAddress.address.countrycode,accountPaymentMethods.expirationYear,primaryPaymentMethod.accountPaymentMethodID,
			accountPaymentMethods.accountPaymentMethodName,primaryShippingAddress.accountAddressID,primaryPaymentMethod.paymentMethodID,accountPaymentMethods.activeFlag,ownerAccount.firstName,primaryAddress.address.streetAddress,primaryAddress.address.street2Address,
			primaryAddress.address.city,primaryAddress.address.stateCode,primaryAddress.address.postalCode,ownerAccount.lastName,ownerAccount.createdDateTime,ownerAccount.primaryAddress.address.city,ownerAccount.primaryAddress.address.stateCode,ownerAccount.primaryAddress.address.postalCode,
			ownerAccount.primaryPhoneNumber.phoneNumber,ownerAccount.primaryEmailAddress.emailAddress,userName,languagePreference,primaryAddress.address.countrycode","[[:space:]]","","all");

	}
}

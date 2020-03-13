
component output="false" accessors="true" extends="Slatwall.model.process.OrderTemplate_UpdateShipping" {
	
	//Validate on Shipping Address Country
    public boolean function hasSameCountryAsSite(){ 
		var siteCountryCode = getService('siteService').getCountryCodeBySite( getOrderTemplate().getSite() );
		
		//check if selected account adress has correct country code
		if( 
		    !isNull(getShippingAccountAddress()) && StructKeyExists(getShippingAccountAddress(),'value') &&
		    getService("accountService").getAccountAddress(getShippingAccountAddress().value).getAddress().getCountryCode() != siteCountryCode
		) {
			return false;
		} else if( 
		    !isNull(getNewAccountAddress()) && StructKeyExists(getNewAccountAddress(),'address') &&
		    StructKeyExists(getNewAccountAddress().address,'countryCode') &&
		    getNewAccountAddress().address.countryCode != siteCountryCode
		) { //check if entered account address has correct country code
		    return false;
		}
		
		return true;
	}

}

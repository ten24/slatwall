component {
	
	public boolean function validateGovernmentIdentificationNumber() {
		var governmentID = this.getGovernmentIdentificationNumber();
		var siteCreatedCountry = this.getAccount().getAccountCreatedSite().getRemoteID();
		
		if ( 'USA' == siteCreatedCountry ) {
			return ( 9 == len( governmentID ) );
		} else if ( 'CAN' == siteCreatedCountry ) {
			return ( 10 == len( governmentID ) );
		}
		
		return true;
	}

}
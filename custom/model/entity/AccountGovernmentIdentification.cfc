component {
	
	property name="governmentIdentificationNumberHashed" ormtype="string" hb_auditable="false" column="governmentIdNumberHashed" hint="Using this for unique gov-ID validation";

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
	
	public boolean function validateGovernmentIdIsUniquePerCountry() {
		return getDAO("accountDAO").getGovernmentIdNotInUseFlag(
				this.getGovernmentIdentificationNumberHashed(),
				this.getAccount().getAccountCreatedSite().getSiteID()
			);
	}
	

}

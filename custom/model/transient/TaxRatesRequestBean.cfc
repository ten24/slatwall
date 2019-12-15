component output="false" accessors="true" extends="Slatwall.model.transient.tax.TaxRatesRequestBean" {
	public string function getAccountShortReferenceID(createNewFlag=false){
		// https://ten24.teamwork.com/index.cfm#/tasks/26446941
		var distributorID = this.getAccount().getAccountNumber();
		if(!isNull(distributorID) && len(distributorID)){
			return distributorID;
		}
		
		return this.getAccount().getShortReferenceID(arguments.createNewFlag);
	}
}
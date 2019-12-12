component output="false" accessors="true" extends="Slatwall.model.transient.tax.TaxRateRequestBean" {
	public string function getAccountShortReferenceID(){
		return this.getAccount().getDistributorID();
	}
}
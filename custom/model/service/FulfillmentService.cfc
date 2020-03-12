component extends="Slatwall.model.service.FulfillmentService" accessors="true" output="false" {
	public string function getCustomAvailableProperties() {
		return 'orderFulfillment.shippingAddress';
	}
	
}

component output="false" accessors="true" extends="Slatwall.model.transient.tax.TaxRateItemRequestBean" {
    
    
    //overrides the populate method to use the custom price fields for taxes.
	public void function populateWithOrderItem(required any orderItem) {
		// Set reference object and type
		setOrderItem(arguments.orderItem);
		setReferenceObjectType('OrderItem');
		
		// Populate with orderItem quantities, price, and orderItemID fields
		setOrderItemID(arguments.orderItem.getOrderItemID());
		setQuantity(arguments.orderItem.getQuantity());
		setCurrencyCode(arguments.orderItem.getCurrencyCode());
		
		
		if(!isNull(arguments.orderItem.getTaxableAmount())) {
			setPrice(arguments.orderItem.getTaxableAmount());
		}
		
		if(!isNull(arguments.orderItem.getExtendedTaxableAmount())) {
			setExtendedPrice(arguments.orderItem.getExtendedTaxableAmount());
		}

		if(!isNull(arguments.orderItem.getDiscountAmount())) {
			setDiscountAmount(arguments.orderItem.getDiscountAmount(forceCalculationFlag=true));
		}

		if(!isNull(arguments.orderItem.getExtendedTaxAmountAfterDiscount())) {
			setExtendedPriceAfterDiscount(arguments.orderItem.getExtendedTaxAmountAfterDiscount());
		}
	}
}
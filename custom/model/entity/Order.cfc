component {
    property name="commissionPeriodStartDateTime" ormtype="timestamp" hb_formatType="dateTime" hb_nullRBKey="define.forever";
    property name="commissionPeriodEndDateTime" ormtype="timestamp" hb_formatType="dateTime" hb_nullRBKey="define.forever";
    property name="secondaryReturnReasonType" cfc="Type" fieldtype="many-to-one" fkcolumn="secondaryReturnReasonTypeID"; // Intended to be used by Ops accounts
    
    property name="personalVolumeSubtotal" persistent="false";
    property name="taxableAmountSubtotal" persistent="false";
    property name="commissionableVolumeSubtotal" persistent="false";
    property name="retailCommissionSubtotal" persistent="false";
    property name="productPackVolumeSubtotal" persistent="false";
    property name="retailValueVolumeSubtotal" persistent="false";
    property name="personalVolumeSubtotalAfterItemDiscounts" persistent="false";
    property name="taxableAmountSubtotalAfterItemDiscounts" persistent="false";
    property name="commissionableVolumeSubtotalAfterItemDiscounts" persistent="false";
    property name="retailCommissionSubtotalAfterItemDiscounts" persistent="false";
    property name="productPackVolumeSubtotalAfterItemDiscounts" persistent="false";
    property name="retailValueVolumeSubtotalAfterItemDiscounts" persistent="false";
    property name="personalVolumeDiscountTotal" persistent="false";
    property name="taxableAmountDiscountTotal" persistent="false";
    property name="commissionableVolumeDiscountTotal" persistent="false";
    property name="retailCommissionDiscountTotal" persistent="false";
    property name="productPackVolumeDiscountTotal" persistent="false";
    property name="retailValueVolumeDiscountTotal" persistent="false";
    property name="personalVolumeTotal" persistent="false";
    property name="taxableAmountTotal" persistent="false";
    property name="commissionableVolumeTotal" persistent="false";
    property name="retailCommissionTotal" persistent="false";
    property name="productPackVolumeTotal" persistent="false";
    property name="retailValueVolumeTotal" persistent="false";
    property name="vipEnrollmentOrderFlag" persistent="false";
    property name="marketPartnerEnrollmentOrderDateTime" persistent="false";
    property name="marketPartnerEnrollmentOrderID" persistent="false";
    
    property name="calculatedVipEnrollmentOrderFlag" ormtype="boolean";
    property name="calculatedPersonalVolumeSubtotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedTaxableAmountSubtotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedCommissionableVolumeSubtotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedRetailCommissionSubtotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedProductPackVolumeSubtotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedRetailValueVolumeSubtotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedPersonalVolumeSubtotalAfterItemDiscounts" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedTaxableAmountSubtotalAfterItemDiscounts" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedCommissionableVolumeSubtotalAfterItemDiscounts" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedRetailCommissionSubtotalAfterItemDiscounts" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedProductPackVolumeSubtotalAfterItemDiscounts" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedRetailValueVolumeSubtotalAfterItemDiscounts" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedPersonalVolumeTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedTaxableAmountTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedCommissionableVolumeTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedRetailCommissionTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedProductPackVolumeTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedRetailValueVolumeTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedPersonalVolumeDiscountTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedTaxableAmountDiscountTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedCommissionableVolumeDiscountTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedRetailCommissionDiscountTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedProductPackVolumeDiscountTotal" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedRetailValueVolumeDiscountTotal" ormtype="big_decimal" hb_formatType="none";
    property name="accountType" ormtype="string";
    property name="accountPriceGroup" ormtype="string";

    property name="shipMethodCode" ormtype="string";
    property name="iceRecordNumber" ormtype="string";
    property name="lastSyncedDateTime" ormtype="timestamp";
    property name="calculatedPaymentAmountDue" ormtype="big_decimal";
    property name="priceGroup" cfc="PriceGroup" fieldtype="many-to-one" fkcolumn="priceGroupID";
    property name="upgradeFlag" ormtype="boolean" default="0";

    public numeric function getPersonalVolumeSubtotal(){
        return getCustomPriceFieldSubtotal('personalVolume');
    }
    public numeric function getTaxableAmountSubtotal(){
        return getCustomPriceFieldSubtotal('taxableAmount');
    }
    public numeric function getCommissionableVolumeSubtotal(){
        return getCustomPriceFieldSubtotal('commissionableVolume');
    }
    public numeric function getRetailCommissionSubtotal(){
        return getCustomPriceFieldSubtotal('retailCommission');
    }
    public numeric function getProductPackVolumeSubtotal(){
        return getCustomPriceFieldSubtotal('productPackVolume');
    }
    public numeric function getRetailValueVolumeSubtotal(){
        return getCustomPriceFieldSubtotal('retailValueVolume');
    }
    public numeric function getPersonalVolumeSubtotalAfterItemDiscounts(){
        return getCustomPriceFieldSubtotalAfterItemDiscounts('personalVolume');
    }
    public numeric function getTaxableAmountSubtotalAfterItemDiscounts(){
        return getCustomPriceFieldSubtotalAfterItemDiscounts('taxableAmount');
    }
    public numeric function getCommissionableVolumeSubtotalAfterItemDiscounts(){
        return getCustomPriceFieldSubtotalAfterItemDiscounts('commissionableVolume');
    }
    public numeric function getRetailCommissionSubtotalAfterItemDiscounts(){
        return getCustomPriceFieldSubtotalAfterItemDiscounts('retailCommission');
    }
    public numeric function getProductPackVolumeSubtotalAfterItemDiscounts(){
        return getCustomPriceFieldSubtotalAfterItemDiscounts('productPackVolume');
    }
    public numeric function getRetailValueVolumeSubtotalAfterItemDiscounts(){
        return getCustomPriceFieldSubtotalAfterItemDiscounts('retailValueVolume');
    }
    public numeric function getPersonalVolumeTotal(){
        return getCustomPriceFieldTotal('personalVolume');
    }
    public numeric function getTaxableAmountTotal(){
        return getCustomPriceFieldTotal('taxableAmount');
    }
    public numeric function getCommissionableVolumeTotal(){
        return getCustomPriceFieldTotal('commissionableVolume');
    }
    public numeric function getRetailCommissionTotal(){
        return getCustomPriceFieldTotal('retailCommission');
    }
    public numeric function getProductPackVolumeTotal(){
        return getCustomPriceFieldTotal('productPackVolume');
    }
    public numeric function getRetailValueVolumeTotal(){
        return getCustomPriceFieldTotal('retailValueVolume');
    }
    public numeric function getPersonalVolumeDiscountTotal(){
        return getCustomDiscountTotal('personalVolume');
    }
    public numeric function getTaxableAmountDiscountTotal(){
        return getCustomDiscountTotal('taxableAmount');
    }
    public numeric function getCommissionableVolumeDiscountTotal(){
        return getCustomDiscountTotal('commissionableVolume');
    }
    public numeric function getRetailCommissionDiscountTotal(){
        return getCustomDiscountTotal('retailCommission');
    }
    public numeric function getProductPackVolumeDiscountTotal(){
        return getCustomDiscountTotal('productPackVolume');
    }
    public numeric function getRetailValueVolumeDiscountTotal(){
        return getCustomDiscountTotal('retailValueVolume');
    }
    
    public numeric function getCustomPriceFieldSubtotal(required string customPriceField){
        var subtotal = 0;
		var orderItems = this.getRootOrderItems();
		var orderItemsCount = arrayLen(orderItems);
		for(var i=1; i<=orderItemsCount; i++) {
			if( listFindNoCase("oitSale,oitDeposit,oitReplacement",orderItems[i].getTypeCode()) ) {
				subtotal = getService('HibachiUtilityService').precisionCalculate(subtotal + orderItems[i].getCustomExtendedPrice(customPriceField));
			} else if ( orderItems[i].getTypeCode() == "oitReturn" ) {
				subtotal = getService('HibachiUtilityService').precisionCalculate(subtotal - orderItems[i].getCustomExtendedPrice(customPriceField));
			} else {
				throw("there was an issue calculating the subtotal because of a orderItemType associated with one of the items");
			}
		}
		return subtotal;
    }
	
	public numeric function getCustomPriceFieldSubtotalAfterItemDiscounts(customPriceField) {
		return getService('HibachiUtilityService').precisionCalculate(getCustomPriceFieldSubtotal(customPriceField) - getItemCustomDiscountAmountTotal(customPriceField));
	}
    
    public numeric function getItemCustomDiscountAmountTotal(required string customPriceField) {
		var discountTotal = 0;
		var orderItems = getRootOrderItems(); 
		for(var i=1; i<=arrayLen(orderItems); i++) {
			if( listFindNoCase("oitSale,oitDeposit,oitReplacement",orderItems[i].getTypeCode()) ) {
				discountTotal = getService('HibachiUtilityService').precisionCalculate(discountTotal + orderItems[i].getCustomDiscountAmount(customPriceField));
			} else if ( orderItems[i].getTypeCode() == "oitReturn" ) {
				discountTotal = getService('HibachiUtilityService').precisionCalculate(discountTotal - orderItems[i].getCustomDiscountAmount(customPriceField));
			} else {
				throw("there was an issue calculating the itemDiscountAmountTotal because of a orderItemType associated with one of the items");
			}
		}
		return discountTotal;
	}
    
    public numeric function getCustomDiscountTotal(customPriceField) {
		return getService('HibachiUtilityService').precisionCalculate(getItemCustomDiscountAmountTotal(customPriceField) + getOrderCustomDiscountAmountTotal(customPriceField));
	}
	
	public numeric function getOrderCustomDiscountAmountTotal(customPriceField) {
		var discountAmount = 0;

		for(var i=1; i<=arrayLen(getAppliedPromotions()); i++) {
			discountAmount = getService('HibachiUtilityService').precisionCalculate(discountAmount + getAppliedPromotions()[i].getCustomDiscountAmount(customPriceField));
		}

		return discountAmount;
	}
	
	public numeric function getCustomPriceFieldTotal(customPriceField) {
		return val(getService('HibachiUtilityService').precisionCalculate(getCustomPriceFieldSubtotal(customPriceField)  - getCustomDiscountTotal(customPriceField)));
	}
	
	public boolean function isNotPaid() {
		return getPaymentAmountDue() > 0;
	}
	
	public boolean function getVipEnrollmentOrderFlag(){
	    var orderItemCollectionList = getService("OrderService").getOrderItemCollectionList();
	    orderItemCollectionList.addFilter("order.orderID",this.getOrderID());
	    //Product code for the VIP registration fee
	    orderItemCollectionList.addFilter("sku.product.productType.urlTitle","enrollment-fee-vip");
	    orderItemCollectionList.setDisplayProperties("orderItemID");
	    return orderItemCollectionList.getRecordsCount() > 0;
	}
	
	public any function getMarketPartnerEnrollmentOrderDateTime(){
	    
	    if (!structKeyExists(variables, "marketPartnerEnrollmentOrderDateTime")){
    	    var orderItemCollectionList = getService("OrderService").getOrderItemCollectionList();
    	    orderItemCollectionList.addFilter("order.orderStatusType.systemCode", "ostNotPlaced", "!=");
    	    orderItemCollectionList.addFilter("order.account.accountID", "#getAccount().getAccountID()#");
    	    orderItemCollectionList.addFilter("order.monatOrderType.typeCode","motMPEnrollment");
    	    orderItemCollectionList.setDisplayProperties("order.orderOpenDateTime");// Date placed 
    	    var records = orderItemCollectionList.getRecords();
    	    if (arrayLen(records)){
    	        variables.marketPartnerEnrollmentOrderDateTime = records[1]['order_orderOpenDateTime'];
    	        return records[1]['order_orderOpenDateTime'];
    	    }
	    }
	    
	    if (!isNull(variables.marketPartnerEnrollmentOrderDateTime)){
	    	return variables.marketPartnerEnrollmentOrderDateTime;
	    }
	}
	
	public any function getMarketPartnerEnrollmentOrderID(){
	    if (!structKeyExists(variables, "marketPartnerEnrollmentOrderID")){
    	    var orderItemCollectionList = getService("OrderService").getOrderItemCollectionList();
    	    orderItemCollectionList.addFilter("order.account.accountID", "#getAccount().getAccountID()#");
    	    orderItemCollectionList.addFilter("order.orderStatusType.systemCode", "ostNotPlaced", "!=");
    	    orderItemCollectionList.addFilter("order.monatOrderType.typeCode","motMPEnrollment");
    	    orderItemCollectionList.setDisplayProperties("order.orderID");// Date placed 
    	    var records = orderItemCollectionList.getRecords();
    	    if (arrayLen(records)){
    	        variables.marketPartnerEnrollmentOrderID = records[1]['order_orderID'];
    	        return records[1]['order_orderID'];
    	    }
	    }
	    
	    if (!isNull(variables.marketPartnerEnrollmentOrderID)){
	    	return variables.marketPartnerEnrollmentOrderID;
	    }
	}
	
	public any function getAccountType() {
	    
	    if (!structKeyExists(variables, "accountType") || !isNull(variables.accountType)) {
	    	variable.accountType = "";
	    	if (!isNull(this.getAccount()) && !isNull(this.getAccount().getAccountType()) && len(this.getAccount().getAccountType())){
		        variables.accountType = this.getAccount().getAccountType();
	    	}
	    }
	    return variables.accountType;
	}
	
	public any function getAccountPriceGroup() {
	    if (structKeyExists(variables, "accountPriceGroup")){
	        return variables.accountPriceGroup;
	    }
	    
	    if (!isNull(getAccount()) && !isNull(getAccount().getPriceGroups())){
	        var priceGroups = getAccount().getPriceGroups();
    	    if (arraylen(priceGroups)){
    	        //there should only be 1 max.
    	        variables.accountPriceGroup = priceGroups[1].getPriceGroupCode();
    	        return variables.accountPriceGroup;
    	    }
	    }
	   
	}
	
	public struct function getListingSearchConfig() {
	   	param name = "arguments.selectedSearchFilterCode" default="lastTwoMonths"; //limiting listingdisplays to show only last 3 months of record by default
	    param name = "arguments.wildCardPosition" default = "exact";
	    return super.getListingSearchConfig(argumentCollection = arguments);
	}
	
	public boolean function hasMPRenewalFee() {
	    if(!structKeyExists(variables,'orderHasMPRenewalFee')){
            variables.orderHasMPRenewalFee = getService('orderService').orderHasMPRenewalFee(this.getOrderID());
		}
		return variables.orderHasMPRenewalFee;
	}
	
	public boolean function hasProductPack() {
	    if(!structKeyExists(variables,'orderHasProductPack')){
            variables.orderHasProductPack = getService('orderService').orderHasProductPack(this.getOrderID());
		}
		return variables.orderHasProductPack;
	}
	
	public boolean function subtotalWithinAllowedPercentage(){
	    var referencedOrder = this.getReferencedOrder();
	    if(isNull(referencedOrder)){
	        return true;
	    }
	    var dateDiff = 0;
	    if(!isNull(referencedOrder.getOrderCloseDateTime())){
    	         dateDiff = dateDiff('d',referencedOrder.getOrderCloseDateTime(),now());
	    }
	    if(dateDiff <= 30){
	        return true;
	    }else if(dateDiff > 365){
	        return false;
	    }else{
	        var originalSubtotal = referencedOrder.getSubTotal();
	        
	        var returnSubtotal = 0;
	        
	        var originalOrderReturnCollectionList = getService('OrderService').getOrderCollectionList();
	        originalOrderReturnCollectionList.setDisplayProperties('orderID,calculatedSubTotal');
	        originalOrderReturnCollectionList.addFilter('referencedOrder.orderID',referencedOrder.getOrderID());
	        originalOrderReturnCollectionList.addFilter("orderType.systemCode","otReturnOrder,otRefundOrder","in");
	        originalOrderReturnCollectionList.addFilter("orderID", "#getOrderID()#","!=");
	        originalOrderReturnCollectionList.addFilter("orderStatusType.systemCode","ostNew,ostClosed,ostProcessing","IN");
	        var originalOrderReturns = originalOrderReturnCollectionList.getRecords(formatRecords=false);
	        
	        for(var order in originalOrderReturns){
	            returnSubtotal += order['calculatedSubTotal'];
	        }

	        return abs(originalSubtotal * 0.9) - abs(returnSubtotal) >= abs(getSubTotal());
	    }
        return true;
	}
	
	public boolean function hasProductPackOrderItem(){
        var orderItemCollectionList = getService('orderService').getOrderItemCollectionList();
        orderItemCollectionList.addFilter('order.orderID',getOrderID());
        orderItemCollectionList.addFilter('sku.product.productType.urlTitle','productPack,starter-kit','in');
        return orderItemCollectionList.getRecordsCount() > 0;
	}
	
	/**
	 * This validates that the orders site matches the accounts created site
	 * if the order has an account already.
	 **/
	public boolean function orderCreatedSiteMatchesAccountCreatedSite(){
        if (!isNull(this.getAccount()) && !isNull(this.getAccount().getAccountCreatedSite())){
            if (this.getOrderCreatedSite().getSiteID() != this.getAccount().getAccountCreatedSite().getSiteID()){
                return false;
            }
        }
        return true;
	}
	
	
	/**
	 * 1. If orderCreatedSite.SiteCode is UK and order.accountType is MP 
	 * max 200 pound TOTAL including VAT and Shipping Feed on days 1-7 
	 * from ordering the enrollment kit.
	 * This only work if the max orders validation also works because this only checks the current order
	 * for total instead of all orders.
	 * 
	 **/
	 public boolean function MarketPartnerValidationMaxOrderAmount(){
	 	
	 	
	    var initialEnrollmentPeriodForMarketPartner = this.getOrderCreatedSite().setting("siteInitialEnrollmentPeriodForMarketPartner");//7
        var maxAmountAllowedToSpendDuringInitialEnrollmentPeriod = this.getOrderCreatedSite().setting("siteMaxAmountAllowedToSpendInInitialEnrollmentPeriod");//200
        
        //If a UK MP is within the first 7 days of enrollment, check that they have not already placed more than 1 order.
		if (!isNull(getAccount()) && getAccount().getAccountType() == "marketPartner" 
			&& this.getOrderCreatedSite().getSiteCode() == "mura-uk"
			&& !isNull(getMarketPartnerEnrollmentOrderDateTime())
			&& dateDiff("d", getMarketPartnerEnrollmentOrderDateTime(), now()) <= initialEnrollmentPeriodForMarketPartner){
			
			//If this order is more than 200 pounds, fails.  
			if (this.getTotal() > maxAmountAllowedToSpendDuringInitialEnrollmentPeriod){
			    return false; // they already have too much.
			}
	    }
	    return true;
	 }
	 
	 /**
	  * 2. If Site is UK and account is MP Max Order 1 placed in first 7 days 
	  * after enrollment order.
	  **/
	 public boolean function MarketPartnerValidationMaxOrdersPlaced(){
	 	
	    // If they've never enrolled, they can enroll.
	    if (!isNull(getAccount()) && getAccount().getAccountType() == "marketPartner" 
			&& this.getOrderCreatedSite().getSiteCode() == "mura-uk"){
			    var hasEnrollmentOrder = getMarketPartnerEnrollmentOrderID();
			    if (isNull(hasEnrollmentOrder)){
			        return true;
			    }
		}
	    
        var initialEnrollmentPeriodForMarketPartner = this.getOrderCreatedSite().setting("siteInitialEnrollmentPeriodForMarketPartner");
        
        //If a UK MP is within the first 7 days of enrollment, check that they have not already placed more than 1 order.
		if (!isNull(initialEnrollmentPeriodForMarketPartner) && !isNull(getAccount()) && getAccount().getAccountType() == "marketPartner" 
			&& this.getOrderCreatedSite().getSiteCode() == "mura-uk"
			&& !isNull(getMarketPartnerEnrollmentOrderDateTime())
			&& !isNull(getMarketPartnerEnrollmentOrderID())
			&& dateDiff("d", getMarketPartnerEnrollmentOrderDateTime(), now()) <= initialEnrollmentPeriodForMarketPartner){
		
			//This order is 1, so if they have any previous that is not the enrollment order,
			//they can't place this one.
			var previouslyOrdered = getService("OrderService").getOrderCollectionList();

			//Find if they have placed more than the initial enrollment order already.
			previouslyOrdered.addFilter("orderID", getMarketPartnerEnrollmentOrderID(),"!=");
			previouslyOrdered.addFilter("account.accountID", getAccount().getAccountID());
			previouslyOrdered.addFilter("orderStatusType.systemCode", "ostNotPlaced", "!=");
			previouslyOrdered.addFilter("orderType.systemCode", "otSalesOrder");
			
			
			if (previouslyOrdered.getRecordsCount() > 0){
				return false; //they can not purchase this because they already have purchased it.
			}
		} 
		return true;
	 }
	 
	 /**
	  * 3. MP (Any site) can't purchase one past 30 days from account creation.
	  **/
	 public boolean function MarketPartnerValidationMaxProductPacksPurchased(){
	    
	    var maxDaysAfterAccountCreate = this.getOrderCreatedSite().setting("siteMaxDaysAfterAccountCreate");
	    
	    //Check if this is MP account AND created MORE THAN 30 days AND is trying to add a product pack.
		if (!isNull(maxDaysAfterAccountCreate) && !isNull(getAccount()) && getAccount().getAccountType() == "marketPartner" 
			&& !isNull(getAccount().getCreatedDateTime()) 
			&& dateDiff("d", getAccount().getCreatedDateTime(), now()) > maxDaysAfterAccountCreate
			&& this.hasProductPackOrderItem()){
		
			return false; //they can not purchase this because they already have purchased it.
		
		//Check if they have previously purchased a product pack, then they also can't purchase a new one.
		} else if (!isNull(maxDaysAfterAccountCreate) && !isNull(getAccount()) && getAccount().getAccountType() == "marketPartner" 
				&& !isNull(getAccount().getCreatedDateTime()) 
				&& dateDiff("d", getAccount().getCreatedDateTime(), now()) <= maxDaysAfterAccountCreate
				&& this.hasProductPackOrderItem()){

			var previouslyPurchasedProductPacks = getService("OrderService").getOrderItemCollectionList();

			//Find all valid previous placed sales orders for this account with a product pack on them.
			previouslyPurchasedProductPacks.addFilter("order.account.accountID", getAccount().getAccountID());
			previouslyPurchasedProductPacks.addFilter("order.orderStatusType.systemCode", "ostNotPlaced", "!=");
			previouslyPurchasedProductPacks.addFilter("order.orderType.systemCode", "otSalesOrder");
			previouslyPurchasedProductPacks.addFilter("sku.product.productType.productTypeName", "Product Pack");

			if (previouslyPurchasedProductPacks.getRecordsCount() > 0){
				return false; //they can not purchase this because they already have purchased it.
			}
		}
		return true;
	 }
}

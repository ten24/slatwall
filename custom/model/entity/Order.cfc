component {
    property name="commissionPeriodStartDateTime" ormtype="timestamp" hb_formatType="dateTime" hb_nullRBKey="define.forever";
    property name="commissionPeriodEndDateTime" ormtype="timestamp" hb_formatType="dateTime" hb_nullRBKey="define.forever";
    property name="secondaryReturnReasonType" cfc="Type" fieldtype="many-to-one" fkcolumn="secondaryReturnReasonTypeID"; // Intended to be used by Ops accounts
     property name="monatOrderType" cfc="Type" fieldtype="many-to-one" fkcolumn="monatOrderTypeID" hb_optionsSmartListData="f:parentType.typeID=2c9280846deeca0b016deef94a090038";
    property name="dropSkuRemovedFlag" ormtype="boolean" default=0;
	property name="incompleteReturnFlag" ormtype="boolean";
	property name="sharedByAccount" cfc="Account" fieldType="many-to-one" fkcolumn="sharedByAccountID";
	
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
    property name="marketPartnerEnrollmentOrderID" persistent="false";
    property name="creditCardLastFour" persistent="false";
    
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
	property name="calculatedPurchasePlusTotal" ormtype="big_decimal" hb_formatType="none";

    property name="accountType" ormtype="string";
    property name="accountPriceGroup" ormtype="string";
	
    property name="shipMethodCode" ormtype="string";
    property name="iceRecordNumber" ormtype="string";
    property name="commissionPeriodCode" ormtype="string";
    property name="lastSyncedDateTime" ormtype="timestamp";
    property name="calculatedPaymentAmountDue" ormtype="big_decimal";
    property name="priceGroup" cfc="PriceGroup" fieldtype="many-to-one" fkcolumn="priceGroupID";
    property name="upgradeFlag" ormtype="boolean" default="0";
    
    property name="sendEmailNotificationsFlag" ormtype="boolean" default="true"; //Used on orders imported with the Batch Order Import functionality

    property name="isLockedInProcessingFlag" persistent="false";
    property name="isLockedInProcessingOneFlag" persistent="false";
    property name="isLockedInProcessingTwoFlag" persistent="false";
	property name="purchasePlusTotal" persistent="false";
	property name="upgradeOrEnrollmentOrderFlag" persistent="false";
	
	
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
				subtotal = getService('HibachiUtilityService').precisionCalculate(subtotal + orderItems[i].getCustomExtendedPrice(arguments.customPriceField));
			} else if ( orderItems[i].getTypeCode() == "oitReturn" ) {
				subtotal = getService('HibachiUtilityService').precisionCalculate(subtotal - orderItems[i].getCustomExtendedPrice(arguments.customPriceField));
			} else {
				throw("there was an issue calculating the subtotal because of a orderItemType associated with one of the items");
			}
		}
		return subtotal;
    }
	
	public numeric function getCustomPriceFieldSubtotalAfterItemDiscounts(customPriceField) {
		return getService('HibachiUtilityService').precisionCalculate(getCustomPriceFieldSubtotal(arguments.customPriceField) - getItemCustomDiscountAmountTotal(arguments.customPriceField));
	}
    
    public numeric function getItemCustomDiscountAmountTotal(required string customPriceField) {
		var discountTotal = 0;
		var orderItems = getRootOrderItems(); 
		for(var i=1; i<=arrayLen(orderItems); i++) {
			if( listFindNoCase("oitSale,oitDeposit,oitReplacement",orderItems[i].getTypeCode()) ) {
				discountTotal = getService('HibachiUtilityService').precisionCalculate(discountTotal + orderItems[i].getCustomDiscountAmount(arguments.customPriceField));
			} else if ( orderItems[i].getTypeCode() == "oitReturn" ) {
				discountTotal = getService('HibachiUtilityService').precisionCalculate(discountTotal - orderItems[i].getCustomDiscountAmount(arguments.customPriceField));
			} else {
				throw("there was an issue calculating the itemDiscountAmountTotal because of a orderItemType associated with one of the items");
			}
		}
		return discountTotal;
	}
    
    public numeric function getCustomDiscountTotal(customPriceField) {
		return getService('HibachiUtilityService').precisionCalculate(getItemCustomDiscountAmountTotal(arguments.customPriceField) + getOrderCustomDiscountAmountTotal(arguments.customPriceField));
	}
	
	public numeric function getOrderCustomDiscountAmountTotal(customPriceField) {
		var discountAmount = 0;

		for(var i=1; i<=arrayLen(getAppliedPromotions()); i++) {
			discountAmount = getService('HibachiUtilityService').precisionCalculate(discountAmount + getAppliedPromotions()[i].getCustomDiscountAmount(arguments.customPriceField));
		}

		return discountAmount;
	}
	
	public numeric function getCustomPriceFieldTotal(customPriceField) {
		return val(getService('HibachiUtilityService').precisionCalculate(getCustomPriceFieldSubtotal(arguments.customPriceField)  - getCustomDiscountTotal(arguments.customPriceField)));
	}
	
	public boolean function isNotPaid() {
		return getPaymentAmountDue() > 0;
	}
	
	public boolean function getVipEnrollmentOrderFlag(){
	    var orderItemCollectionList = getService("OrderService").getOrderItemCollectionList();
	    orderItemCollectionList.addFilter("order.orderID",this.getOrderID());
	    //Product code for the VIP registration fee
	    orderItemCollectionList.addFilter("sku.product.productType.urlTitle","vpn-customer-registr");
	    orderItemCollectionList.setDisplayProperties("orderItemID");
	    return orderItemCollectionList.getRecordsCount() > 0;
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
	    
	    if (structKeyExists(variables, "accountType")){
	        return variables.accountType;
	    }

	    if (!isNull(getAccount()) && !isNull(getAccount().getAccountType()) && len(getAccount().getAccountType())){
	        variables.accountType = getAccount().getAccountType();
	    }else{
	        variables.accountType = "";
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
	
	public boolean function returnDatePercentagesApply(){
		var referencedOrder = this.getReferencedOrder();
	    if(isNull(referencedOrder)){
	        return true;
	    }
	    var dateDiff = 0;
	    if(!isNull(referencedOrder.getOrderCloseDateTime())){
    	         dateDiff = dateDiff('d',referencedOrder.getOrderCloseDateTime(),now());
	    }
	    if(dateDiff >= 30){
	        return true;
	    }
	    return false;
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
	
	public string function getCreditCardLastFour(){
		if(!structKeyExists(variables,'creditCardLastFour')){
			var creditCardLastFour = '';
			
			var orderPaymentCollection = getService('OrderService').getOrderPaymentCollectionList();
			orderPaymentCollection.addFilter('orderPaymentStatusType.systemCode','opstActive');
			orderPaymentCollection.addFilter('paymentMethod.paymentMethodType','creditCard');
			orderPaymentCollection.addOrderBy('createdDateTime|desc');
			orderPaymentCollection.setDisplayProperties('creditCardLastFour');
			orderPaymentCollection.setPageRecordsShow(1);
			var orderPayments = orderPaymentCollection.getPageRecords();
			if(arraylen(orderPayments)){
				creditCardLastFour = orderPayments[1].creditCardLastFour;
			}
			
			variables.creditCardLastFour = creditCardLastFour;
		}
		return variables.creditCardLastFour;
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
	  * 2. If Site is UK and account is MP Max Order 1 placed in first 7 days 
	  * after enrollment order.
	  **/
	 public boolean function marketPartnerValidationMaxOrdersPlaced(){
	     
	    if( isNull( this.getAccount() ) 
	        || this.getAccount().getAccountType() != "marketPartner" 
	        || this.getOrderCreatedSite().getSiteCode() != "mura-uk" 
	        || isNull( this.getMarketPartnerEnrollmentOrderID() ) // If they've never enrolled, they can enroll.
	    ){
	        return true;
	    }

        var initialEnrollmentPeriodForMarketPartner = this.getOrderCreatedSite().setting("siteInitialEnrollmentPeriodForMarketPartner");
        
        if( isNull(initialEnrollmentPeriodForMarketPartner) ){
            return true;
        }
        if( isNull( this.getAccount().getEnrollmentDate() ) ){
            return true;
        }
        
        //If a UK MP is within the first 7 days of enrollment, check that they have not already placed more than 1 order.
		if ( dateDiff("d", this.getAccount().getEnrollmentDate(), now() ) <= initialEnrollmentPeriodForMarketPartner ){
		
			//This order is 1, so if they have any previous that is not the enrollment order,
			//they can't place this one.
			var previouslyOrdered = getService("orderService").getOrderCollectionList();

			//Find if they have placed more than the initial enrollment order already.
			previouslyOrdered.addFilter("orderID", getMarketPartnerEnrollmentOrderID(), "!=");
			previouslyOrdered.addFilter("account.accountID", getAccount().getAccountID());
			previouslyOrdered.addFilter("orderStatusType.systemCode", "ostNotPlaced", "!=");
			previouslyOrdered.addFilter("orderType.systemCode", "otSalesOrder");
			
			if ( previouslyOrdered.getRecordsCount() > 0 ){
				return false; //they can not purchase this because they already have purchased it.
			}
		}
		
		return true;
	 }
	 
	 /**
	  * 3. MP (Any site) can't purchase one past 30 days from account creation.
	  **/
	 public boolean function marketPartnerValidationMaxProductPacksPurchased(){
	 	
	 	if(this.getOrderStatusType().getSystemCode() != 'ostNotPlaced'){
	 		return true;
	 	}
	    
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
	 
	public any function getDefaultStockLocation(){
	 	if(!structKeyExists(variables,'defaultStockLocation')){
	 		if(!isNull(getOrderCreatedSite())){
	 			var locations = getOrderCreatedSite().getLocations();
	 			if(!isNull(locations) && arrayLen(locations)){
	 				variables.defaultStockLocation = locations[1];
	 			}
	 		}
	 	}
	 	if(structKeyExists(variables,'defaultStockLocation')){
	 		return variables.defaultStockLocation;
	 	}
	}
	 
	public boolean function getIsLockedInProcessingOneFlag(){
		return getOrderStatusType().getSystemCode() == "ostProcessing" && getOrderStatusType().getTypeCode() == "processing1";
	}
	
	public boolean function getIsLockedInProcessingTwoFlag(){
		return getOrderStatusType().getSystemCode() == "ostProcessing" && getOrderStatusType().getTypeCode() == "processing2";
	}
	
	public boolean function getIsLockedInProcessingFlag(){
	
		return  (
					getOrderStatusType().getSystemCode() == "ostProcessing" 
					&& 
					(
						getOrderStatusType().getTypeCode() == "processing1"
						||
						getOrderStatusType().getTypeCode() == "processing2"
					)
				);
	}
	
	public numeric function getPurchasePlusTotal(){
	
		var purchasePlusRecords = getService('orderService').getPurchasePlusInformationForOrderItems(this.getOrderID());
		var total = 0;

		if(!isArray(purchasePlusRecords)){
			purchasePlusRecords = purchasePlusRecords.getRecords();
			for (var item in purchasePlusRecords){
				total +=  item.discountAmount;
			}
		}
		variables.purchasePlusTotal = total;

		
		return variables.purchasePlusTotal;
	}
	
	public boolean function orderPriceGroupMatchesAccount(){
		//first check account, account price groups should both not be null and have a length  
		//then we check if the order has a price group, if it does it should match the price group on the account - inverses are checked as to avoid nested logic
		return (isNull(this.getAccount().getPriceGroups()) || !arrayLen(this.getAccount().getPriceGroups()) 
				|| (!isNull(this.getPriceGroup().getPriceGroupCode()) && this.getPriceGroup().getPriceGroupCode() != this.getAccount().getPriceGroups()[1].getPriceGroupCode()) ) ? false : true;
	}
	
	public any function getCurrencyCode(){
		if(
			isNull(variables.currencyCode) 
			|| (
				!isNull(getOrderCreatedSite()) 
				&& !isNull(getOrderCreatedSite().getCurrencyCode())
				&& getOrderCreatedSite().getCurrencyCode() != variables.currencyCode
			)
		){
			variables.currencyCode = getOrderCreatedSite().getCurrencyCode()
		}
		return variables.currencyCode;
	}
	
	public boolean function marketPartnerValidationMaxOrderAmount(){
	 	
	 	var site = this.getOrderCreatedSite();
	 	if(isNull(site) || site.getSiteCode() != 'mura-uk'){
	 	    return true; 
	 	} 
	 	
	 	var accountType = this.getAccountType();
	 	if(isNull(accountType) || accountType != 'marketPartner'){
	 		return true;
	 	}
	 	
	    var initialEnrollmentPeriodForMarketPartner = site.setting("siteInitialEnrollmentPeriodForMarketPartner"); // 7-days
	    
        var enforceEnrollmentPeriod = isNull(this.getAccount()) || isNull(this.getAccount().getEnrollmentDate() ) || dateDiff( "d", this.getAccount().getEnrollmentDate(), now() ) <= initialEnrollmentPeriodForMarketPartner;

        var enforceUpgradePeriod = false;
        if( !isNull(this.getAccount()) ){
            var mpUpgradeDateTime = this.getAccount().getMpUpgradeDateTime();
            enforceUpgradePeriod = this.getUpgradeFlag() || ( !isNull(mpUpgradeDateTime) && dateDiff( "d", mpUpgradeDateTime, now() ) <= initialEnrollmentPeriodForMarketPartner );
        }

        //If a UK MP is within the first 7 days of enrollment/upgrade, check that they have not already placed more than 1 order.
		if ( enforceEnrollmentPeriod || enforceUpgradePeriod  ){
			var total = 0;
			
			if(!isNull(this.getAccount())){
				var orderCollectionList = account.getOrdersCollectionList();
				orderCollectionList.setDisplayProperties('calculatedTotal');
				orderCollectionList.addFilter('accountType','marketPartner');
				orderCollectionList.addFilter('orderStatusType.systemCode', 'ostNew,ostProcessing,ostClosed', 'IN');
				orderCollectionList.addFilter('orderID',this.getOrderID(),'!=')
				var orders = orderCollectionList.getRecords();
				for(var order in orders){
					total+=order.calculatedTotal;
				}
			}

			total += this.getTotal();

            var maxAmountAllowedToSpendDuringInitialEnrollmentPeriod = site.setting("siteMaxAmountAllowedToSpendInInitialEnrollmentPeriod");//200
			//If adding the order item will increase the order to over 200 EU return false  
			if (total > maxAmountAllowedToSpendDuringInitialEnrollmentPeriod){
			    return false; // they already have too much.
			}
	    }
	    return true;
	 }
	 
	 public boolean function getUpgradeOrEnrollmentOrderFlag(){
	 	 
		if (this.getUpgradeFlag()) {
			return true;
		}
		
		if( 
			this.hasMonatOrderType() && 
			ListFindNoCase("motMpEnrollment,motVipEnrollment", this.getMonatOrderType().getTypeCode()) 
		){
			return true;
		}
		
		return false;
	}
	
	//Returns an array of one shipping fulfillment if there is a shipping fulfillment on the order, otherwise it returns an empty array
	public array function getFirstShippingFulfillment(){
		
		if(isNull(variables.firstShippingFulfillmentArray)){
			var shippingFulfillmentArray = [];
			var fulfillments = this.getOrderFulfillments() ?:[];
			for(var fulfillment in fulfillments){
				if(!isNull(fulfillment.getFulfillmentMethod()) && fulfillment.getFulfillmentMethod().getFulfillmentMethodType() =='shipping'){
					arrayAppend(shippingFulfillmentArray, fulfillment);
					break;
				}
			}
			variables.firstShippingFulfillmentArray = shippingFulfillmentArray;
		}
		
		return variables.firstShippingFulfillmentArray;
	}
	
	public boolean function validateActiveStatus(){
		var isValidOrder = false;
		if(
			!isNull(this.getAccount())
			&& (
				this.getAccount().getActiveFlag()
				||	(
						!this.getAccount().getActiveFlag() 
						&& this.getUpgradeOrEnrollmentOrderFlag()
						&& !isNull(this.getAccount().getAccountStatusType())
						&& this.getAccount().getAccountStatusType().getSystemCode() == 'astEnrollmentPending'
					)
				)
			)
		{
			isValidOrder = true;
		}
		
		return isValidOrder;
	}
	
	public boolean function isOrderPartiallyDelivered(){
		return getQuantityUndelivered() != 0 && getQuantityDelivered() != 0;
	}
	
	public boolean function hasCBDProduct(){
	 	if(!structKeyExists(variables,'CBDProduct')){
	 		variables.CBDProduct = false;
			var cbdcollectionList = getService('orderService').getOrderItemCollectionList();
    		cbdcollectionList.addFilter('order.orderID',this.getOrderID() );
    		cbdcollectionList.addFilter('sku.cbdFlag', true);
			variables.CBDProduct = cbdcollectionList.getRecordsCount() > 0;
	 	}
	 	return variables.CBDProduct
	}
}

component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="subscriptionUsage";
	
	// Lazy Objects
	property name="order";

	// Data Properties
	property name="renewalStartType" hb_formFieldType="select";
	property name="proratedPrice" hb_rbKey="entity.sku.renewalPrice" hb_formatType="currency";
	property name="extendExpirationDate" hb_formatType="date";
	property name="prorateExpirationDate" hb_formatType="date";
	
	property name="renewalPaymentType" hb_formFieldType="select";
	
	property name="accountPaymentMethod" cfc="AccountPaymentMethod" fieldType="many-to-one" persistent="false" fkcolumn="accountPaymentMethodID" hb_rbKey="entity.accountPaymentMethod";
	property name="orderPayment" cfc="OrderPayment" fieldType="many-to-one" persistent="false" fkcolumn="orderPaymentID" hb_rbKey="entity.orderPayment";
	property name="newOrderPayment" cfc="OrderPayment" fieldType="many-to-one" persistent="false" fkcolumn="orderPaymentID";
	
	property name="saveAccountPaymentMethodFlag" hb_formFieldType="yesno";
	property name="saveAccountPaymentMethodName" hb_formFieldType="yesno";
	property name="updateSubscriptionUsageAccountPaymentMethodFlag" hb_formFieldType="yesno";
	
	public boolean function getSaveAccountPaymentMethodFlag() {
		if(!structKeyExists(variables, "saveAccountPaymentMethodFlag")) {
			variables.saveAccountPaymentMethodFlag = 0;
		}
		return variables.saveAccountPaymentMethodFlag;
	}
	
	public boolean function getUpdateSubscriptionUsageAccountPaymentMethodFlag() {
		if(!structKeyExists(variables, "updateSubscriptionUsageAccountPaymentMethodFlag")) {
			variables.updateSubscriptionUsageAccountPaymentMethodFlag = 0;
		}
		return variables.updateSubscriptionUsageAccountPaymentMethodFlag;
	}
	
	public any function getNewOrderPayment() {
		if(!structKeyExists(variables, "newOrderPayment")) {
			variables.newOrderPayment = getService('orderService').newOrderPayment();
		}
		return variables.newOrderPayment;
	}
	
	public any function getOrder() {
		if(!structKeyExists(variables, "order")) {
			for(var subscriptionOrderItem in getSubscriptionUsage().getSubscriptionOrderItems()) {
				if(subscriptionOrderItem.getSubscriptionOrderItemType().getSystemCode() == 'soitRenewal' && subscriptionOrderItem.getOrderItem().getOrder().getOrderStatusType().getSystemCode() != 'ostClosed') {
					variables.order = subscriptionOrderItem.getOrderItem().getOrder();
				}
			}
			if(!structKeyExists(variables, "order")) {
				variables.order = getService("orderService").newOrder();
			}
		}
		return variables.order;
	}
	
	public string function getExtendExpirationDate() {
		return getSubscriptionUsage().getSubscriptionOrderItems()[1].getOrderItem().getSku().getSubscriptionTerm().getRenewalTerm().getEndDate( getSubscriptionUsage().getExpirationDate() );
	}
	
	public string function getProrateExpirationDate() {
		return getSubscriptionUsage().getSubscriptionOrderItems()[1].getOrderItem().getSku().getSubscriptionTerm().getRenewalTerm().getEndDate( now() );
	}
	
	public numeric function getProratedPrice() {
		var extendDurationFromNow = dateDiff("d", getSubscriptionUsage().getExpirationDate(), getExtendExpirationDate() );
		var prorateDurationFromNow = dateDiff("d", getSubscriptionUsage().getExpirationDate(), getProrateExpirationDate() );
		var proratePercentage = prorateDurationFromNow / extendDurationFromNow * 100;
		
		return round(getSubscriptionUsage().getRenewalPrice() * proratePercentage)/100;
	}
	
	public string function getRenewalStartType() {
		if(!structKeyExists(variables, "renewalStartType")) {
			variables.renewalStartType = 'extend';
		}
		
		return variables.renewalStartType;
	}
	
	public array function getRenewalStartTypeOptions() {
		return [
			{name="Extend Current Expiration", value='extend'},
			{name="Prorate & Extend From Today", value='prorate'}
		];
	}
	
	public string function getRenewalPaymentType() {
		if(!structKeyExists(variables, "renewalPaymentType")) {
			if(arrayLen(getAccountPaymentMethodOptions())) {
				variables.renewalPaymentType = 'accountPaymentMethod';
			} else if(arrayLen(getOrderPaymentOptions())) {
				variables.renewalPaymentType = 'orderPayment';	
			} else {
				variables.renewalPaymentType = 'new';
			}
		}
		
		return variables.renewalPaymentType;
	}
	
	public array function getRenewalPaymentTypeOptions() {
		var options = [];
		
		if(arrayLen(getAccountPaymentMethodOptions())) {
			arrayAppend(options, {name=rbKey('processObject.SubscriptionUsage_Renew.renewalPaymentType.accountPaymentMethod'), value='accountPaymentMethod'});
		}
		if(arrayLen(getOrderPaymentOptions())) {
			arrayAppend(options, {name=rbKey('processObject.SubscriptionUsage_Renew.renewalPaymentType.orderPayment'), value='orderPayment'});
		}
		arrayAppend(options, {name=rbKey('processObject.SubscriptionUsage_Renew.renewalPaymentType.new'), value='new'});
		
		return options;
	}
	
	public array function getOrderPaymentOptions() {
		if(!structKeyExists(variables, "orderPaymentOptions")) {
			variables.orderPaymentOptions = [];
			var previousOrderPayments = getSubscriptionUsage().getUniquePreviousSubscriptionOrderPayments();
			for(var orderPayment in previousOrderPayments) {
				arrayAppend(variables.orderPaymentOptions, {name=orderPayment.getSimpleRepresentation(), value=orderPayment.getOrderPaymentID()});	
			}
		}
		return variables.orderPaymentOptions;
	}
	
	public any function getAccountPaymentMethodOptions() {
		if(!structKeyExists(variables, "accountPaymentMethodOptions")) {
			variables.accountPaymentMethodOptions = [];
			var smartList = getService("accountService").getAccountPaymentMethodSmartList();
			smartList.addFilter(propertyIdentifier="account.accountID", value=getSubscriptionUsage().getAccount().getAccountID());
			smartList.addOrder("accountPaymentMethodName|ASC");
			for(var apm in smartList.getRecords()) {
				arrayAppend(variables.accountPaymentMethodOptions,{name=apm.getSimpleRepresentation(),value=apm.getAccountPaymentMethodID()});
			}
		}
		return variables.accountPaymentMethodOptions;
    }
	
}
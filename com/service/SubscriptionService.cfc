/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component extends="BaseService" persistent="false" accessors="true" output="false" {
	property name="accessService" type="any";
	property name="orderService" type="any";
	property name="paymentService" type="any";
	property name="emailService" type="any";
	property name="utilityEmailService" type="any";
	
	public boolean function createSubscriptionUsageBenefitAccountByAccess(required any access, required any account) {
		var subscriptionUsageBenefitAccountCreated = false;
		if(!isNull(arguments.access.getSubscriptionUsageBenefitAccount()) && isNull(arguments.access.getSubscriptionUsageBenefitAccount().getAccount())) {
			arguments.access.getSubscriptionUsageBenefitAccount().setAccount(arguments.account);
			subscriptionUsageBenefitAccountCreated = true;
		} else if(!isNull(arguments.access.getSubscriptionUsageBenefit())) {
			var subscriptionUsageBenefitAccount = createSubscriptionUsageBenefitAccountBySubscriptionUsageBenefit(arguments.access.getSubscriptionUsageBenefit(), arguments.account);
			if(!isNull(subscriptionUsageBenefitAccount)) {
				subscriptionUsageBenefitAccountCreated = true;
			}
		} else if(!isNull(arguments.access.getSubscriptionUsage())) {
			var subscriptionUsageBenefitAccountArray = createSubscriptionUsageBenefitAccountBySubscriptionUsage(arguments.access.getSubscriptionUsage(), arguments.account);
			if(arrayLen(subscriptionUsageBenefitAccountArray)) {
				subscriptionUsageBenefitAccountCreated = true;
			}
		}
		return subscriptionUsageBenefitAccountCreated;
	}
	
	// Create subscriptionUsageBenefitAccount by subscription usage, returns array of all subscriptionUsageBenefitAccountArray created
	public any function createSubscriptionUsageBenefitAccountBySubscriptionUsage(required any subscriptionUsage, any account) {
		var subscriptionUsageBenefitAccountArray = [];
		for(var subscriptionUsageBenefit in arguments.subscriptionUsage.getSubscriptionUsageBenefits()) {
			var data.subscriptionUsageBenefit = subscriptionUsageBenefit;
			// if account is passed then set the account to this benefit else create an access record to be used for account creation
			if(structKeyExists(arguments,"account")) {
				data.account = arguments.account;
			}
			var subscriptionUsageBenefitAccount = createSubscriptionUsageBenefitAccountBySubscriptionUsageBenefit(argumentCollection=data);
			if(!isNull(subscriptionUsageBenefitAccount)) {
				arrayAppend(subscriptionUsageBenefitAccountArray,subscriptionUsageBenefitAccount);
			}
		}
		return subscriptionUsageBenefitAccountArray;
	}
	
	public any function createSubscriptionUsageBenefitAccountBySubscriptionUsageBenefit(required any subscriptionUsageBenefit, any account) {
		if(arguments.subscriptionUsageBenefit.getAvailableUseCount() GT 0) {
			// if account is passed then get this benefit account else create a new benefit account
			if(structKeyExists(arguments,"account")) {
				var subscriptionUsageBenefitAccount = this.getSubscriptionUsageBenefitAccount({subscriptionUsageBenefit=arguments.subscriptionUsageBenefit,account=arguments.account},true);
			} else {
				var subscriptionUsageBenefitAccount = this.newSubscriptionUsageBenefitAccount();
			}
			if(subscriptionUsageBenefitAccount.isNew()) {
				subscriptionUsageBenefitAccount.setSubscriptionUsageBenefit(arguments.subscriptionUsageBenefit);
				this.saveSubscriptionUsageBenefitAccount(subscriptionUsageBenefitAccount);
				// if account is passed then set the account to this benefit else create an access record to be used for account creation
				if(structKeyExists(arguments,"account")) {
					subscriptionUsageBenefitAccount.setAccount(arguments.account);
				} else {
					var access = getAccessService().newAccess();
					access.setSubscriptionUsageBenefitAccount(subscriptionUsageBenefitAccount);
					getAccessService().saveAccess(access);
				}
			}
			return subscriptionUsageBenefitAccount;
		}
	}
	
	public void function setupSubscriptionOrderItem(required any orderItem) {
		if(!isNull(arguments.orderItem.getSku().getSubscriptionTerm())) {
			// check if orderItem is assigned to a subscriptionOrderItem
			var subscriptionOrderItem = this.getSubscriptionOrderItem({orderItem=arguments.orderItem});
			if(isNull(subscriptionOrderItem)) {
				// new orderItem, setup subscription
				setupInitialSubscriptionOrderItem(arguments.orderItem);
			} else {
				// orderItem already exists in subscription, just setup access and expiration date
				if(isNull(subscriptionOrderItem.getSubscriptionUsage().getExpirationDate())) {
					var startDate = now();
				} else {
					var startDate = subscriptionOrderItem.getSubscriptionUsage().getExpirationDate();
				}
				subscriptionOrderItem.getSubscriptionUsage().setExpirationDate(subscriptionOrderItem.getSubscriptionUsage().getRenewalTerm().getEndDate(startDate));
				updateSubscriptionUsageStatus(subscriptionOrderItem.getSubscriptionUsage());
				// set renewal benefit if needed
				setupRenewalSubscriptionBenefitAccess(subscriptionOrderItem.getSubscriptionUsage());
			}
		}
	}
	
	// setup Initial SubscriptionOrderItem
	private void function setupInitialSubscriptionOrderItem(required any orderItem) {
		var subscriptionOrderItemType = "soitInitial";
		var subscriptionUsage = this.newSubscriptionUsage();
		
		//copy all the info from order items to subscription usage if it's initial order item
		subscriptionUsage.copyOrderItemInfo(arguments.orderItem);
		
		// set account
		subscriptionUsage.setAccount(arguments.orderItem.getOrder().getAccount());
		
		// set payment method is there was only 1 payment method for the order
		// if there are multiple orderPayment, logic needs to get added for user to defined the paymentMethod for renewals
		if(arrayLen(arguments.orderItem.getOrder().getOrderPayments()) == 1) {
			subscriptionUsage.setAccountPaymentMethod(arguments.orderItem.getOrder().getOrderPayments()[1].getAccountPaymentMethod());
		}
		
		// set next bill date
		subscriptionUsage.setNextBillDate(arguments.orderItem.getSku().getSubscriptionTerm().getInitialTerm().getEndDate());
		
		// Force Next Bill Date to day of the month specified in Subscription Term
		if(isnumeric(arguments.orderItem.getSku().getSubscriptionTerm().getForceBillingOnDay())){
			subscriptionUsage.setNextBillDate(getForceNextBillDate(arguments.orderItem.getSku().getSubscriptionTerm().getForceBillingOnDay(), arguments.orderItem.getSku().getSubscriptionTerm().getInitialTerm().getTermMonths(), arguments.orderItem.getSku().getSubscriptionTerm().getInitialTerm().getTermYears(), subscriptionUsage.getNextBillDate()));
		}
		
		// set expiration date
		subscriptionUsage.setExpirationDate(subscriptionUsage.getNextBillDate());
		
		// set next reminder date to now, it will get updated when the reminder gets sent
		subscriptionUsage.setNextReminderEmailDate(now());
		
		// add active status to subscription usage
		setSubscriptionUsageStatus(subscriptionUsage, 'sstActive');
		
		// create new subscription orderItem
		var subscriptionOrderItem = this.newSubscriptionOrderItem();
		subscriptionOrderItem.setOrderItem(arguments.orderItem);
		subscriptionOrderItem.setSubscriptionOrderItemType(this.getTypeBySystemCode(subscriptionOrderItemType));
		subscriptionOrderItem.setSubscriptionUsage(subscriptionUsage);
		
		// call save on this entity to make it persistent so we can use it for further lookup
		this.saveSubscriptionUsage(subscriptionUsage);

		// copy all the subscription benefits
		for(var subscriptionBenefit in arguments.orderItem.getSku().getSubscriptionBenefits()) {
			var subscriptionUsageBenefit = this.getSubscriptionUsageBenefitBySubscriptionBenefitANDSubscriptionUsage([subscriptionBenefit,subscriptionUsage],true);
			subscriptionUsageBenefit.copyFromSubscriptionBenefit(subscriptionBenefit);
			subscriptionUsage.addSubscriptionUsageBenefit(subscriptionUsageBenefit);

			// call save on this entity to make it persistent so we can use it for further lookup
			this.saveSubscriptionUsageBenefit(subscriptionUsageBenefit);

			// create subscriptionUsageBenefitAccount for this account
			var subscriptionUsageBenefitAccount = this.getSubscriptionUsageBenefitAccountBySubscriptionUsageBenefit(subscriptionUsageBenefit,true);
			subscriptionUsageBenefitAccount.setSubscriptionUsageBenefit(subscriptionUsageBenefit);
			subscriptionUsageBenefitAccount.setAccount(arguments.orderItem.getOrder().getAccount());
			this.saveSubscriptionUsageBenefitAccount(subscriptionUsageBenefitAccount);

			// setup benefits
			setupSubscriptionBenefitAccess(subscriptionUsageBenefit);
		}
		
		// copy all the subscription benefits for renewal
		for(var subscriptionBenefit in arguments.orderItem.getSku().getRenewalSubscriptionBenefits()) {
			var subscriptionUsageBenefit = this.getSubscriptionUsageBenefitBySubscriptionBenefitANDSubscriptionUsage([subscriptionBenefit,subscriptionUsage],true);
			subscriptionUsageBenefit.copyFromSubscriptionBenefit(subscriptionBenefit);
			subscriptionUsage.addRenewalSubscriptionUsageBenefit(subscriptionUsageBenefit);
			this.saveSubscriptionUsageBenefit(subscriptionUsageBenefit);
		}
		
		this.saveSubscriptionOrderItem(subscriptionOrderItem);
	}
	
	// setup subscription benefits for use by accounts
	public void function setupSubscriptionBenefitAccess(required any subscriptionUsageBenefit) {
		// add this benefit to access
		if(arguments.subscriptionUsageBenefit.getAccessType().getSystemCode() == "satPerSubscription") {
			var accessSmartList = getAccessService().getAccessSmartList();
			accessSmartList.addFilter(propertyIdentifier="subscriptionUsage_subscriptionUsageID", value=arguments.subscriptionUsageBenefit.getSubscriptionUsage().getSubscriptionUsageID());
			if(!accessSmartList.getRecordsCount()) {
				var access = getAccessService().getAccessBySubscriptionUsage(arguments.subscriptionUsageBenefit.getSubscriptionUsage(),true);
				access.setSubscriptionUsage(arguments.subscriptionUsageBenefit.getSubscriptionUsage());
				getAccessService().saveAccess(access);
			}

		} else if(arguments.subscriptionUsageBenefit.getAccessType().getSystemCode() == "satPerBenefit") {
			var access = getAccessService().getAccessBySubscriptionUsageBenefit(arguments.subscriptionUsageBenefit,true);
			access.setSubscriptionUsageBenefit(arguments.subscriptionUsageBenefit);
			getAccessService().saveAccess(access);

		} else if(arguments.subscriptionUsageBenefit.getAccessType().getSystemCode() == "satPerAccount") {
			// TODO: this should get moved to DAO because adding large number of records like this could timeout
			// check how many access records already exists and create new ones
			var recordCountForCreation = arguments.subscriptionUsageBenefit.getAvailableUseCount();

			for(var i = 0; i < recordCountForCreation; i++) {
				var subscriptionUsageBenefitAccount = this.newSubscriptionUsageBenefitAccount();
				subscriptionUsageBenefitAccount.setSubscriptionUsageBenefit(arguments.subscriptionUsageBenefit);
				saveSubscriptionUsageBenefitAccount(subscriptionUsageBenefitAccount);
				var access = getAccessService().newAccess();
				access.setSubscriptionUsageBenefitAccount(subscriptionUsageBenefitAccount);
				getAccessService().saveAccess(access);
			}
		}
	}

	// setup renewal subscription benefits for use by accounts
	public void function setupRenewalSubscriptionBenefitAccess(required any subscriptionUsage) {
		//setup renewal benefits, if first renewal and renewal benefit exists
		if(arrayLen(arguments.subscriptionUsage.getSubscriptionOrderItems()) == 2 && arrayLen(arguments.subscriptionUsage.getRenewalSubscriptionUsageBenefits())) {
			// expire all existing benefits
			for(var subscriptionUsageBenefit in arguments.subscriptionUsage.getSubscriptionUsageBenefits()) {
				var subscriptionUsageBenefitAccount = this.getSubscriptionUsageBenefitAccountBySubscriptionUsageBenefit(subscriptionUsageBenefit);
				subscriptionUsageBenefitAccount.setEndDateTime(now());
				this.saveSubscriptionUsageBenefitAccount(subscriptionUsageBenefitAccount);
			}
			
			this.saveSubscriptionUsage(arguments.subscriptionUsage);
			
			// copy all the renewal subscription benefits
			for(var renewalSubscriptionUsageBenefit in arguments.subscriptionUsage.getRenewalSubscriptionUsageBenefits()) {
				var subscriptionUsageBenefit = this.newSubscriptionUsageBenefit();
				subscriptionUsageBenefit.copyFromSubscriptionUsageBenefit(renewalSubscriptionUsageBenefit);
				subscriptionUsage.addSubscriptionUsageBenefit(subscriptionUsageBenefit);
	
				// call save on this entity to make it persistent so we can use it for further lookup
				this.saveSubscriptionUsageBenefit(subscriptionUsageBenefit);
				
				// create subscriptionUsageBenefitAccount for this account
				var subscriptionUsageBenefitAccount = this.getSubscriptionUsageBenefitAccountBySubscriptionUsageBenefit(subscriptionUsageBenefit,true);
				subscriptionUsageBenefitAccount.setSubscriptionUsageBenefit(subscriptionUsageBenefit);
				subscriptionUsageBenefitAccount.setAccount(arguments.subscriptionUsage.getAccount());
				this.saveSubscriptionUsageBenefitAccount(subscriptionUsageBenefitAccount);
	
				// setup benefits access
				setupSubscriptionBenefitAccess(subscriptionUsageBenefit);
			}
		}
	}

	// process a subscription usage
	public any function processSubscriptionUsage(required any subscriptionUsage, struct data={}, any processContext="update") {
		if(arguments.processContext == 'autoRenew') {
			return autoRenewSubscriptionUsage(arguments.subscriptionUsage, arguments.data);
		} else if(arguments.processContext == 'manualRenew') {
			return manualRenewSubscriptionUsage(arguments.subscriptionUsage, arguments.data);
		} else if(arguments.processContext == 'retry') {
			return retryRenewSubscriptionUsage(arguments.subscriptionUsage, arguments.data);
		} else if(arguments.processContext == 'cancel') {
			return cancelSubscriptionUsage(arguments.subscriptionUsage, arguments.data);
		} else if(arguments.processContext == 'update') {
			return updateSubscriptionUsageStatus(arguments.subscriptionUsage);
		}
	}
	
	// renew a subscription usage automatically through a task
	private any function autoRenewSubscriptionUsage(required any subscriptionUsage, struct data={}) {
		// first check if it's time for renewal
		if(arguments.subscriptionUsage.getNextBillDate() <= now() && arguments.subscriptionUsage.getCurrentStatusCode() != 'sstCancelled') {
			
			// check if autoRenew is true
			if(arguments.subscriptionUsage.getAutoRenewFlag()) {

				// create a new order
				var order = getOrderService().newOrder();
				
				// set order status to new (aka placed)
				order.setOrderStatusType(this.getTypeBySystemCode("ostNew"));
				
				// set the account for order
				order.setAccount(arguments.subscriptionUsage.getAccount());
	
				// add order item to order, set the fulfillment methodID to auto
				var itemData = {fulfillmentMethodID="444df2ffeca081dc22f69c807d2bd8fe"};
				getOrderService().addOrderItem(order=order,sku=arguments.subscriptionUsage.getSubscriptionOrderItems()[1].getOrderItem().getSku(),data=itemData);
	
				// set the orderitem price to renewal price
				order.getOrderItems()[1].setPrice(arguments.subscriptionUsage.getRenewalPrice());
				order.getOrderItems()[1].setSkuPrice(arguments.subscriptionUsage.getRenewalPrice());
		
				// create new subscription orderItem
				var subscriptionOrderItem = this.newSubscriptionOrderItem();
				subscriptionOrderItem.setOrderItem(order.getOrderItems()[1]);
				subscriptionOrderItem.setSubscriptionOrderItemType(this.getTypeBySystemCode('soitRenewal'));
				subscriptionOrderItem.setSubscriptionUsage(arguments.subscriptionUsage);
				this.saveSubscriptionOrderItem(subscriptionOrderItem);

				// save order for processing
				getOrderService().getDAO().save(order);
		
				// set next bill date, calculated from the last bill date
				// need setting to decide what start date to use for next bill date calculation
				arguments.subscriptionUsage.setNextBillDate(order.getOrderItems()[1].getSku().getSubscriptionTerm().getRenewalTerm().getEndDate(arguments.subscriptionUsage.getNextBillDate()));
					
				// flush session to make sure order is persisted to DB
				getDAO().flushORMSession();
					
				// add order payment to order if amount > 0
				if(order.getTotal() > 0) { 
					var paymentProcessed = false;
					// if autoPayFlag true then apply payment
					if(arguments.subscriptionUsage.getAutoPayFlag()) {
						var orderPayment = getPaymentService().newOrderPayment();
						orderPayment.setOrder(order);
						orderPayment.setAmount(order.getTotal());
						orderPayment.copyFromAccountPaymentMethod(subscriptionUsage.getAccountPaymentMethod());
						orderPayment.setOrderPaymentType(this.getTypeBySystemCode("optCharge"));
						getPaymentService().saveOrderPayment(orderPayment);
						// if orderPayment has no error, then try to process payment
						if(!orderPayment.hasErrors()) {
							var paymentProcessed = getPaymentService().processPayment(order.getOrderPayments()[1], 'authorizeAndCharge', order.getOrderPayments()[1].getAmount());
						} 
					}
				} else {
					var paymentProcessed = true;
				}
				
				// if payment is processed, close out fulfillment and order
				if(paymentProcessed) {
					getOrderService().processOrderFulfillment(order.getOrderFulfillments()[1], {locationID=order.getOrderFulfillments()[1].setting('fulfillmentMethodAutoLocation')}, "fulfillItems");
					
					// persist order changes to DB 
					getDAO().flushORMSession();
					
					//send email confirmation, needs a setting to enable this
					getEmailService().sendEmailByEvent("autoSubscriptionUsageRenewalOrderPlaced", order);
				}

			} 
			// update the Subscription Status
			updateSubscriptionUsageStatus(arguments.subscriptionUsage);	
		}
		
		return arguments.subscriptionUsage;
	}
	
	// renew a subscription usage manually
	private any function manualRenewSubscriptionUsage(required any subscriptionUsage, struct data={}) {
		// first check if there is an open order for renewal, if there is, use it else create a new one
		for(var subscriptionOrderItem in arguments.subscriptionUsage.getSubscriptionOrderItems()) {
			if(subscriptionOrderItem.getSubscriptionOrderItemType().getSystemCode() == 'soitRenewal' && subscriptionOrderItem.getOrderItem().getOrder().getOrderStatusType().getSystemCode() != 'ostClosed') {
				var order = subscriptionOrderItem.getOrderItem().getOrder();
			}
		}	
		if(isNull(order)) {
			// create a new order
			var order = getOrderService().newOrder();
			
			// set order status to new (aka placed)
			order.setOrderStatusType(this.getTypeBySystemCode("ostNew"));

			// set the account for order
			order.setAccount(arguments.subscriptionUsage.getAccount());
			
			// add order item to order, set the fulfillment methodID to auto
			var itemData = {fulfillmentMethodID="444df2ffeca081dc22f69c807d2bd8fe"};
			getOrderService().addOrderItem(order=order,sku=arguments.subscriptionUsage.getSubscriptionOrderItems()[1].getOrderItem().getSku(),data=itemData);

			// set the orderitem price to renewal price
			order.getOrderItems()[1].setPrice(arguments.subscriptionUsage.getRenewalPrice());
			order.getOrderItems()[1].setSkuPrice(arguments.subscriptionUsage.getRenewalPrice());
	
			// create new subscription orderItem
			var subscriptionOrderItem = this.newSubscriptionOrderItem();
			subscriptionOrderItem.setOrderItem(order.getOrderItems()[1]);
			subscriptionOrderItem.setSubscriptionOrderItemType(this.getTypeBySystemCode('soitRenewal'));
			subscriptionOrderItem.setSubscriptionUsage(arguments.subscriptionUsage);
			this.saveSubscriptionOrderItem(subscriptionOrderItem);

			// save order for processing
			getOrderService().getDAO().save(order);
	
			// set next bill date, calculated from the last bill date
			// need setting to decide what start date to use for next bill date calculation
			arguments.subscriptionUsage.setNextBillDate(order.getOrderItems()[1].getSku().getSubscriptionTerm().getRenewalTerm().getEndDate(arguments.subscriptionUsage.getNextBillDate()));
				
			// flush session to make sure order is persisted to DB
			getDAO().flushORMSession();
		}	
					
		// add order payment to order if amount > 0 
		if(order.getTotal() > 0) {
			var paymentProcessed = false;
			// check if payment is applied
			if(!arrayLen(order.getOrderPayments())) {
				var orderPayment = getPaymentService().newOrderPayment();
				orderPayment.setOrder(order);
				orderPayment.setAmount(order.getTotal());
				orderPayment.copyFromAccountPaymentMethod(subscriptionUsage.getAccountPaymentMethod());
				orderPayment.setOrderPaymentType(this.getTypeBySystemCode("optCharge"));
				getPaymentService().saveOrderPayment(orderPayment);
			} else {
				var orderPayment = order.getOrderPayments()[1];
			}
				
			// if orderPayment has no error and amount not received yet, then try to process payment
			if(!orderPayment.hasErrors()) {
				var amount = order.getTotal() - orderPayment.getAmountReceived();
				var paymentProcessed = getPaymentService().processPayment(orderPayment, 'authorizeAndCharge', amount);
			} 
		} else {
			var paymentProcessed = true;
		}

		// if payment is processed, close out fulfillment and order
		if(paymentProcessed) {
			var orderFulfillment = getOrderService().processOrderFulfillment(order.getOrderFulfillments()[1], {locationID=order.getOrderFulfillments()[1].setting('fulfillmentMethodAutoLocation')}, "fulfillItems");
			
			if(!orderFulfillment.hasErrors()) {
				// persist order changes to DB 
				getDAO().flushORMSession();
				
				//send email confirmation, needs a setting to enable this
				getEmailService().sendEmailByEvent("manualSubscriptionUsageRenewalOrderPlaced", order);
			} else {
				for(var errorName in orderFulfillment.getErrors()) {
					for(var error in orderFulfillment.getErrors()[errorName]) {
						arguments.subscriptionUsage.addError("processing", error);
					}
				}
			}
		}

		// update the Subscription Status
		updateSubscriptionUsageStatus(arguments.subscriptionUsage);	
		
		return arguments.subscriptionUsage;
	}
	
	// renew a subscription usage by retrying
	private any function retryRenewSubscriptionUsage(required any subscriptionUsage, struct data={}) {
		throw("Implement me!");
	}

	private void function updateSubscriptionUsageStatus(required any subscriptionUsage) {
		// Is the next bill date + grace period in past || the next bill date is in the future, but the last order for this subscription usage hasn't been paid (+ grace period from that orders date)
			// Suspend
		
		// get the current status
		var currentStatus = arguments.subscriptionUsage.getCurrentStatus();
		
		// if current status is active and expiration date in past
		if(currentStatus.getSubscriptionStatusType().getSystemCode() == 'sstActive' && arguments.subscriptionUsage.getExpirationDate() <= now()) {
			// suspend
			setSubscriptionUsageStatus(arguments.subscriptionUsage, 'sstSuspended');
			// reset expiration date
			arguments.subscriptionUsage.setExpirationDate(javaCast("null",""));
		
		} else if (arguments.subscriptionUsage.getExpirationDate() > now()) {
			// if current status is not active, set active status to subscription usage
			if(arguments.subscriptionUsage.getCurrentStatusCode() != 'sstActive') {
				setSubscriptionUsageStatus(arguments.subscriptionUsage, 'sstActive');
			}
		}
	}
	
	private any function cancelSubscriptionUsage(required any subscriptionUsage, struct data={}) {
		// first check if it's not alreayd cancelled
		if(arguments.subscriptionUsage.getCurrentStatusCode() != 'sstCancelled') {
			if(!structKeyExists(data, "effectiveDateTime")) {
				data.effectiveDate = now();
			}
			if(!structKeyExists(data, "subscriptionStatusChangeReasonTypeCode")) {
				data.subscriptionStatusChangeReasonTypeCode = "";
			}
			// add cancelled status to subscription usage
			setSubscriptionUsageStatus(arguments.subscriptionUsage, 'sstCancelled', data.effectiveDate, data.subscriptionStatusChangeReasonTypeCode);
		}
		return arguments.subscriptionUsage;
	}
	
	private void function setSubscriptionUsageStatus(required any subscriptionUsage, required string subscriptionStatusTypeCode, any effectiveDate = now(), any subscriptionStatusChangeReasonTypeCode) {
		var subscriptionStatus = this.newSubscriptionStatus();
		subscriptionStatus.setSubscriptionStatusType(this.getTypeBySystemCode(arguments.subscriptionStatusTypeCode));
		if(structKeyExists(arguments, "subscriptionStatusChangeReasonTypeCode") && arguments.subscriptionStatusChangeReasonTypeCode != "") {
			subscriptionStatus.setSubscriptionStatusChangeReasonType(this.getTypeBySystemCode(arguments.subscriptionStatusChangeReasonTypeCode));
		}
		subscriptionStatus.setEffectiveDateTime(arguments.effectiveDate);
		subscriptionStatus.setChangeDateTime(now());
		arguments.subscriptionUsage.addSubscriptionStatus(subscriptionStatus);
		this.saveSubscriptionUsage(arguments.subscriptionUsage);
	} 
	
	// process subscription usage renewal reminder
	public any function processSubscriptionUsageRenewalReminder(required any subscriptionUsage, struct data={}, any processContext="auto") {
		if(arguments.processContext == 'manual') {
			return manualRenewalReminderSubscriptionUsage(arguments.subscriptionUsage, arguments.data);
		} else if(arguments.processContext == 'auto') {
			return autoRenewalReminderSubscriptionUsage(arguments.subscriptionUsage, arguments.data);
		}
	}
	
	private void function manualRenewalReminderSubscriptionUsage(required any subscriptionUsage, struct data={}) {
		param name="arguments.data.eventName" type="string" default="subscriptionUsageRenewalReminder";
		getEmailService().sendEmailByEvent(arguments.data.eventName, arguments.subscriptionUsage);
	}
	
	private void function autoRenewalReminderSubscriptionUsage(required any subscriptionUsage, struct data={}) {
		param name="arguments.data.eventName" type="string" default="subscriptionUsageRenewalReminder";
		var emails = getEmailService().listEmail({eventName = arguments.data.eventName});
		if(arrayLen(emails)) {
			var reminderEmail = emails[1];
			// check if its time to send reminder email
			var renewalReminderDays = arguments.subscriptionUsage.getSubscriptionOrderItems()[1].getOrderItem().getSku().getSubscriptionTerm().getRenewalReminderDays();
			if(!isNull(renewalReminderDays) && len(renewalReminderDays)) {
				renewalReminderDays = listToArray(renewalReminderDays);
				// loop through the list of reminder days
				for(var i = 1; i <= arrayLen(renewalReminderDays); i++) {
					// find the actual reminder date based on expiration date
					var reminderDate = dateAdd('d',renewalReminderDays[i],arguments.subscriptionUsage.getExpirationDate());
					if(dateCompare(reminderDate,now()) == -1) {
						// check if nextReminderDate is in past
						if(!isNull(arguments.subscriptionUsage.getNextReminderEmailDate()) && arguments.subscriptionUsage.getNextReminderEmailDate() NEQ "" && dateCompare(arguments.subscriptionUsage.getNextReminderEmailDate(),now()) == -1) {
							if(i < arrayLen(renewalReminderDays)){
								arguments.subscriptionUsage.setNextReminderEmailDate(dateAdd('d',renewalReminderDays[i+1],arguments.subscriptionUsage.getExpirationDate()));
							} else {
								arguments.subscriptionUsage.setNextReminderEmailDate(javaCast("null",""));
							}
							getEmailService().sendEmailByEvent(arguments.data.eventName, arguments.subscriptionUsage);
							getDAO().flushORMSession();
							break;
						}
					}
				} 
			}
		}
	}
	
	// force monthly or yearly payments to occur on a certain day of the month (only applicable if payment term is months or years)
	// if today's calendar day is greater than the iForceBillingOnDay, pushes NextBillDate to the next month
	public any function getForceNextBillDate(required any dayOfMonthToForce, any termMonths, any termYears, any nextBillDate, any startDate = now()) {
		var rNextBillDate = arguments.nextBillDate;
		var forceBillingOnDay = int(arguments.dayOfMonthToForce);
		// can only force payment day on month or year payment terms
		if(not isnull(arguments.termMonths) or not isnull(arguments.termYears)){ 
			// set nextBillDate's "day" to forceBillingOnDay
			rNextBillDate=DateAdd("d",forceBillingOnDay-Day(rNextBillDate),rNextBillDate);
			// is today's calendar day greater than the iForceBillingOnDay?
			if(Day(now()) gt forceBillingOnDay) {
				// push NextBillDate to the next month since we've already charged for the next period in the initial purchase
				rNextBillDate = DateAdd("m",1,rNextBillDate);
			}
		}
		return rNextBillDate;
	}
	

	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	public array function getUnusedProductSubscriptionTerms( required string productID ){
		return getDAO().getUnusedProductSubscriptionTerms( arguments.productID );
	}
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
}

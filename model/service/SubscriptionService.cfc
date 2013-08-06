/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
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
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

*/
component extends="HibachiService" persistent="false" accessors="true" output="false" {

	property name="orderDAO" type="any";
	property name="subscriptionDAO" type="any";
	
	property name="accessService" type="any";
	property name="orderService" type="any";
	property name="paymentService" type="any";
	property name="emailService" type="any";
	
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
	
	// setup Initial SubscriptionOrderItem
	public void function setupInitialSubscriptionOrderItem(required any orderItem) {
		var subscriptionOrderItemType = "soitInitial";
		var subscriptionUsage = this.newSubscriptionUsage();
		
		//copy all the info from order items to subscription usage if it's initial order item
		subscriptionUsage.copyOrderItemInfo(arguments.orderItem);
		
		// set account
		subscriptionUsage.setAccount(arguments.orderItem.getOrder().getAccount());
		
		// Loop over the orderPayments to see if we can add an accountPaymentMethod
		for(var orderPayment in arguments.orderItem.getOrder().getOrderPayments()) {
			if(!isNull(orderPayment.getAccountPaymentMethod())) {
				subscriptionUsage.setAccountPaymentMethod( orderPayment.getAccountPaymentMethod() );	
			}
		}
		
		// Set the Expiration & Next Bill Date
		subscriptionUsage.setExpirationDate( arguments.orderItem.getSku().getSubscriptionTerm().getInitialTerm().getEndDate() );
		subscriptionUsage.setNextBillDate( subscriptionUsage.getExpirationDate() );
		subscriptionUsage.setFirstReminderEmailDateBasedOnNextBillDate();
		
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
				this.saveSubscriptionUsageBenefitAccount(subscriptionUsageBenefitAccount);
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
				for(var subscriptionUsageBenefitAccount in subscriptionUsageBenefit.getSubscriptionUsageBenefitAccounts()) {
					subscriptionUsageBenefitAccount.setEndDateTime(now());
					this.saveSubscriptionUsageBenefitAccount(subscriptionUsageBenefitAccount);		
				}
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
	
	private void function setSubscriptionUsageStatus(required any subscriptionUsage, required string subscriptionStatusTypeCode, any effectiveDateTime = now(), any subscriptionStatusChangeReasonTypeCode) {
		var subscriptionStatus = this.newSubscriptionStatus();
		subscriptionStatus.setSubscriptionStatusType(this.getTypeBySystemCode(arguments.subscriptionStatusTypeCode));
		if(structKeyExists(arguments, "subscriptionStatusChangeReasonTypeCode") && arguments.subscriptionStatusChangeReasonTypeCode != "") {
			subscriptionStatus.setSubscriptionStatusChangeReasonType(this.getTypeBySystemCode(arguments.subscriptionStatusChangeReasonTypeCode));
		}
		subscriptionStatus.setEffectiveDateTime(arguments.effectiveDateTime);
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
		if(arrayLen(emails) && !isNull(arguments.subscriptionUsage.getExpirationDate())) {
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
							getHibachiDAO().flushORMSession();
							break;
						}
					}
				} 
			}
		}
	}
	

	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	public array function getUnusedProductSubscriptionTerms( required string productID ){
		return getSubscriptionDAO().getUnusedProductSubscriptionTerms( argumentCollection=arguments );
	}
	
	public any function getSubscriptionCurrentStatus(required string subscriptionUsageID ){
		return getSubscriptionDAO().getSubscriptionCurrentStatus( argumentCollection=arguments );
	}
	
	public any function getUniquePreviousSubscriptionOrderPayments( required string subscriptionUsageID ) {
		return getSubscriptionDAO().getUniquePreviousSubscriptionOrderPayments( argumentCollection=arguments );
	}
	
	public any function getSubscriptionUsageForRenewal() {
		return getSubscriptionDAO().getSubscriptionUsageForRenewal();
	}
	
	public any function getSubscriptionUsageForRenewalReminder() {
		return getSubscriptionDAO().getSubscriptionUsageForRenewalReminder();
	}
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	public any function processSubscriptionUsage_cancel(required any subscriptionUsage, required any processObject) {
		if(isNull(processObject.getEffectiveDateTime())) {
			processObject.setEffectiveDateTime( now() );
		}
		
		setSubscriptionUsageStatus(arguments.subscriptionUsage, 'sstCancelled', processObject.getEffectiveDateTime());
		
		return arguments.subscriptionUsage;
	}
	
	public any function processSubscriptionUsage_renew(required any subscriptionUsage, required any processObject, struct data={}) {
		
		var order = arguments.processObject.getOrder();
		
		// New Renewal Order
		if(order.getNewFlag()) {
			
			// First pull out the nextBillDate if sucessful to populate later
			if(arguments.processObject.getRenewalStartType() == 'extend') {
				// Extend
				var nextBillDate = arguments.processObject.getExtendExpirationDate();
			} else {
				// Prorate
				var nextBillDate = arguments.processObject.getProrateExpirationDate();
			}
			
			// set the account for order
			arguments.processObject.getOrder().setAccount( arguments.subscriptionUsage.getAccount() );
			
			// add order item to order
			var itemData = {
				preProcessDisplayedFlag=1,
				skuID=arguments.subscriptionUsage.getSubscriptionOrderItems()[1].getOrderItem().getSku().getSkuID()
			};
			order = getOrderService().processOrder( order, itemData, 'addOrderItem' );
			
			// Make sure that the orderItem was added to the order without issue
			if(!order.hasErrors()) {
				// set the orderitem price to renewal price
				if(arguments.processObject.getRenewalStartType() == 'extend') {
					// Extend
					order.getOrderItems()[1].setPrice( arguments.subscriptionUsage.getRenewalPrice() );	
				} else {
					// Prorate
					order.getOrderItems()[1].setPrice( arguments.processObject.getProratedPrice() );
				}
				
				// create new subscription orderItem
				var subscriptionOrderItem = this.newSubscriptionOrderItem();
				subscriptionOrderItem.setOrderItem( order.getOrderItems()[1] );
				subscriptionOrderItem.setSubscriptionOrderItemType( this.getTypeBySystemCode('soitRenewal') );
				subscriptionOrderItem.setSubscriptionUsage( arguments.subscriptionUsage );
				this.saveSubscriptionOrderItem( subscriptionOrderItem );
				
				// Setup the Order Payment
				if(arguments.processObject.getRenewalPaymentType() eq 'accountPaymentMethod') {
					var orderPayment = getOrderService().newOrderPayment();
					
					orderPayment.copyFromAccountPaymentMethod( arguments.processObject.getAccountPaymentMethod() );
					
					orderPayment.setOrder( order );
					
				} else if (arguments.processObject.getRenewalPaymentType() eq 'orderPayment') {
					var orderPayment = getOrderService().newOrderPayment();
					
					orderPayment.copyFromOrderPayment( arguments.processObject.getOrderPayment() );
					
					orderPayment.setOrder( order );
					
				} else if (arguments.processObject.getRenewalPaymentType() eq 'new') {
					order = getOrderService().processOrder(order, arguments.data, 'addOrderPayment');
					
				}
				
				// save order for processing
				getOrderService().getHibachiDAO().save( order );
				
				// Persist the order to the DB
				getHibachiDAO().flushORMSession();
				
				// Place the Order
				order = getOrderService().processOrder(order, {}, 'placeOrder');
				
				// set the subscription usage nextBillDate
				arguments.subscriptionUsage.setNextBillDate( nextBillDate );
				arguments.subscriptionUsage.setFirstReminderEmailDateBasedOnNextBillDate();
				
				// As long as the order was placed, then we can update the nextBillDateTime & nextReminderDateTime
				if(order.getStatusCode() == "ostNotPlaced") {
					arguments.subscriptionUsage.addMessage("notPlaced", rbKey('validate.processSubscriptionUsage_renew.order.notPlaced') & ' <a href="?slatAction=admin:entity.detailOrder&orderID=#order.getOrderID()#">#getHibachiScope().rbKey('define.notPlaced')#</a>');
				}
			}
		// Existing Renewal Order to be re-submitted
		} else {
			
			// TODO: Add Retry Logic
			arguments.subscriptionUsage.addError('renew', rbKey('validate.processSubscriptionUsage_renew.order.newFlag') & ' <a href="?slatAction=admin:entity.detailOrder&orderID=#order.getOrderID()#"><cfif not isNull(order.getOrderNumber())>#order.getOrderNumber()#<cfelse>#getHibachiScope().rbKey('define.notPlaced')#</cfif></a>');
		}

		return arguments.subscriptionUsage;
	}
	
	public any function processSubscriptionUsage_sendRenewalReminder(required any subscriptionUsage) {
		
		if(len(subscriptionUsage.setting('subscriptionUsageRenewalReminderEmailTemplate'))) {
			
			var email = getEmailService().newEmail();
			var emailData = {
				subscriptionUsageID = subscriptionUsage.getSubscriptionUsageID(),
				emailTemplateID = subscriptionUsage.setting('subscriptionUsageRenewalReminderEmailTemplate')
			};
			
			email = getEmailService().processEmail(email, emailData, 'createFromTemplate');
			email = getEmailService().processEmail(email, {}, 'addToQueue');
			
			subscriptionUsage.setNextReminderEmailDate( javaCast("null", "") );
			
			// Setup the next Reminder email 
			if( len(arguments.subscriptionUsage.setting('subscriptionUsageRenewalReminderDays')) ) {
				
				// Loop over each of the days looking for the next one
				for(var nextReminderDay in listToArray(subscriptionUsage.setting('subscriptionUsageRenewalReminderDays'))) {
					
					// Setup what the date would be if we used this option
					var nextReminderDate = dateAdd("d", nextReminderDay, subscriptionUsage.getExpirationDate());
					
					// If this option is > than now, then we can set the date and break out of loop
					if(nextReminderDate > now()) {
						
						// Set the next date
						subscriptionUsage.setNextReminderEmailDate( nextReminderDate );	
						
						break;
					}
				}
				
			}
			
			
		} else {
			throw("No reminder email template found.  Please update the setting 'Subscription Renewal Reminder Email Template' either globally, for the subscription term, or subscription usage.");
		}
		
		return arguments.subscriptionUsage;
	}
	
	public any function processSubscriptionUsage_updateStatus(required any subscriptionUsage) {
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
		
		return arguments.subscriptionUsage;
	}
	
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


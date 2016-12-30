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
component persistent="false" accessors="true" output="false" extends="BaseController" {

	property name="accountService" type="any";
	property name="orderService" type="any";
	property name="userUtility" type="any";
	property name="paymentService" type="any";
	property name="subscriptionService" type="any";
	
	public void function create(required struct rc) {
		rc.account = rc.$.slatwall.getCurrentAccount();
		if(!rc.account.isNew()){
			redirectToView();
		} else {
			prepareEditData(rc);
			getFW().setView("frontend:account.create");
		}
	}
	
	public void function edit(required struct rc) {
		rc.account = rc.$.slatwall.getCurrentAccount();
		prepareEditData(rc);
		getFW().setView("frontend:account.edit");
	}
	
	public void function editLogin(required struct rc) {
		rc.account = rc.$.slatwall.getCurrentAccount();
		prepareEditData(rc);
		getFW().setView("frontend:account.editlogin");
	}
	
	public void function prepareEditData(required struct rc) {
		rc.attributeSets = rc.account.getAttributeSets(["Account"]);
	}
	
	public void function save(required struct rc) {
		param name="arguments.rc.primaryPhoneNumber" default="#structNew()#";
		param name="arguments.rc.primaryPhoneNumber.accountPhoneNumberID" default="#rc.$.slatwall.getCurrentAccount().getPrimaryPhoneNumber().getAccountPhoneNumberID()#";
		param name="arguments.rc.primaryPhoneNumber.phoneNumber" default="";
		param name="arguments.rc.primaryPhoneNumber.account.accountID" default="#rc.$.slatwall.getCurrentAccount().getAccountID()#";
		
		if(!len(arguments.rc.primaryPhoneNumber.phoneNumber) && structKeyExists(arguments.rc, "phoneNumber")) {
			arguments.rc.primaryPhoneNumber.phoneNumber = arguments.rc.phoneNumber;
		} else {
			structDelete(arguments.rc, "primaryPhoneNumber");
		}
		
		var wasNew = rc.$.slatwall.getCurrentAccount().isNew();
		var currentAction = "frontend:account.edit";
		if(wasNew){
			currentAction = "frontend:account.create";
		}
		rc.account = getAccountService().saveAccount(rc.$.slatwall.getCurrentAccount(), rc);
		
		// Change Password Logic
		if( !rc.account.hasErrors() && !wasNew && structKeyExists(rc, "password") && !isNull(rc.account.getCMSAccountID()) && len(rc.account.getCMSAccountID()) ) {
			
			// Change password on mura side
			var muraUser = rc.$.getBean('userBean').loadby(userID=rc.account.getCMSAccountID(), siteID=arguments.rc.$.event('siteid'));
			muraUser.setPassword( rc.password );
			muraUser.save();
			
			// Change password on slatwall side
			if(rc.account.getSlatwallAuthenticationExistsFlag()) {
				var passwordChangeData = {};
				passwordChangeData.password = rc.password;
				passwordChangeData.passwordConfirm = rc.password;
				
				rc.account = getAccountService().processAccount(rc.account, passwordChangeData, 'changePassword');
			}
			
		}
		
		if(!rc.account.hasErrors() && wasNew && structKeyExists(rc, "password")) {
			
			// Create the mura user
			var newMuraUser = rc.$.getBean('userBean');
			newMuraUser.setFName( nullReplace(arguments.rc.account.getFirstName(), '') );
			newMuraUser.setLName( nullReplace(arguments.rc.account.getLastName(), '') );
			newMuraUser.setCompany( nullReplace(arguments.rc.account.getCompany(), '') );
			newMuraUser.setUsername( arguments.rc.account.getEmailAddress() );
			newMuraUser.setEmail( arguments.rc.account.getEmailAddress() );
			newMuraUser.setPassword( rc.password );
			newMuraUser.setSiteID( rc.$.event('siteID') );
			
			// Set the CMSAccountID on the slatwall side
			arguments.rc.account.setCMSAccountID( newMuraUser.getUserID() );
			
			// Persist this change
			ormFlush();
			
			// Save the mura user (which will cascade and update the authentication on slatwall side)
			newMuraUser = newMuraUser.save();
			
			// If the mura user had issues saving
			if(!isNull(newMuraUser.getErrors()) && isStruct(newMuraUser.getErrors()) && structCount(newMuraUser.getErrors()) ) {
				
				// Remove the account entity from the database that we persisted
				getAccountService().deleteAccount( arguments.rc.account );
				
				// Create a new version, and populate it with the stuff that was attempted
				arguments.rc.account = getAccountService().newAccount();
				arguments.rc.account.setFirstName( newMuraUser.getFName() );
				arguments.rc.account.setLastName( newMuraUser.getLName() );
				arguments.rc.account.setCompany( newMuraUser.getCompany() );
				arguments.rc.account.setPrimaryEmailAddress( arguments.rc.account.getPrimaryEmailAddress() );
				arguments.rc.account.getPrimaryEmailAddress().setEmailAddress( newMuraUser.getEmail() );
				
				// Loop over the errors in the newMuraUser and add those errors to this account entity
				for(var key in newMuraUser.getErrors()) {
					arguments.rc.account.addError(key, newMuraUser.getErrors()[key]);
				}
				
			} else {
				
				// Loging the current user
				var loginSuccess = rc.$.getBean('userUtility').login(username=arguments.rc.account.getEmailAddress(), password=accountData.password, siteID=rc.$.event('siteid'));
				
			}
			
			
		}
		
		if(rc.account.hasErrors()) {
			prepareEditData(rc);
			getFW().setView(currentAction);
		} else if ( structKeyExists(rc,"returnURL") && len(rc.returnURL) > 3) {
			getFW().redirectExact(rc.returnURL);
		} else {
			redirectToView();
		}
	}
	
	public void function login(required struct rc) {
		param name="rc.username" default="";
		param name="rc.password" default="";
		param name="rc.returnURL" default="";
		param name="rc.forgotPasswordEmail" default="";
		
		if(rc.forgotPasswordEmail != "") {
			rc.forgotPasswordResult = rc.$.getBean('userUtility').sendLoginByEmail(email=rc.forgotPasswordEmail, siteid=rc.$.event('siteID'));
		} else {
			var loginSuccess = rc.$.getBean('userUtility').login(username=rc.username, password=rc.password, siteID=rc.$.event('siteID'));
		
			if(!loginSuccess) {
				request.status = "failed";
			} else if ( len(rc.returnURL) > 3) {
				getFW().redirectExact(returnURL);
			}
			
		}
		
		getFW().setView("frontend:account.detail");
	}
	
	public void function listAddress(required struct rc) {
		rc.account = rc.$.slatwall.getCurrentAccount();
		getFW().setView("frontend:account.listaddress");
	}
	
	public void function editAddress(required struct rc) {
		rc.account = rc.$.slatwall.getCurrentAccount();
		rc.accountAddress = getAccountService().getAccountAddress(rc.accountAddressID);
		// make sure address belongs to this account
		if(rc.account.hasAccountAddress(rc.accountAddress)){
			getFW().setView("frontend:account.editaddress");
		} else {
			redirectToView();
		}
	}
	
	public void function saveAddress(required struct rc) {
		rc.account = rc.$.slatwall.getCurrentAccount();
		rc.accountAddress = getAccountService().getAccountAddress(rc.accountAddressID);
		// make sure address belongs to this account
		if(rc.account.hasAccountAddress(rc.accountAddress) || rc.accountAddress.isNew()){
			rc.accountAddress.setAccount(rc.account);
			rc.accountAddress = getAccountService().saveAccountAddress(rc.accountAddress, rc);
			if(rc.accountAddress.hasErrors()) {
				getFW().setView("frontend:account.editaddress");
			} else {
				getFW().setView("frontend:account.listaddress");
			}
		} else {
			redirectToView();
		}
	}
	
	public void function listPaymentMethod(required struct rc) {
		rc.account = rc.$.slatwall.getCurrentAccount();
		rc.paymentMethods = getPaymentService().listPaymentMethod();
		getFW().setView("frontend:account.listpaymentmethod");
	}
	
	public void function listSubscription(required struct rc) {
		rc.account = rc.$.slatwall.getCurrentAccount();
		
		getFW().setView("frontend:account.listsubscription");
	}
	
	
	public void function editPaymentMethod(required struct rc) {
		rc.account = rc.$.slatwall.getCurrentAccount();
		rc.accountPaymentMethod = getAccountService().getAccountPaymentMethod(rc.accountPaymentMethodID);
		// make sure PaymentMethod belongs to this account
		if(rc.account.hasAccountPaymentMethod(rc.accountPaymentMethod)){
			getFW().setView("frontend:account.editpaymentmethod");
		} else {
			redirectToView();
		}
	}
	
	public void function createPaymentMethod(required struct rc) {
		// if no payment method ID passed redirect to overview
		if(rc.$.event("paymentMethodID") == ""){
			redirectToView();
		}
		rc.accountPaymentMethodID = "";
		rc.account = rc.$.slatwall.getCurrentAccount();
		rc.paymentMethod = getPaymentService().getPaymentMethod(rc.$.event("paymentMethodID"));
		rc.accountPaymentMethod = getAccountService().newAccountPaymentMethod();
		rc.accountPaymentMethod.setPaymentMethod(rc.paymentMethod);
		getFW().setView("frontend:account.editpaymentmethod");
	}
	
	public void function savePaymentMethod(required struct rc) {
		rc.account = rc.$.slatwall.getCurrentAccount();
		var paymentMethod = getPaymentService().getPaymentMethod(rc.$.event("paymentMethod.paymentMethodID"));
		rc.accountPaymentMethod = getAccountService().getAccountPaymentMethod(rc.accountPaymentMethodID, true);
		// make sure PaymentMethod belongs to this account
		if(rc.account.hasAccountPaymentMethod(rc.accountPaymentMethod) || rc.accountPaymentMethod.isNew()){
			rc.accountPaymentMethod.setAccount(rc.account);
			rc.accountPaymentMethod = getAccountService().saveAccountPaymentMethod(rc.accountPaymentMethod, rc);
			if(rc.accountPaymentMethod.hasErrors()) {
				getFW().setView("frontend:account.editpaymentmethod");
			} else {
				redirectToView("listpaymentmethod");
			}
		} else {
			redirectToView();
		}
	}
	
	private void function redirectToView(string view="") {
		if(view == ""){
			getFW().redirectExact( request.muraScope.createHREF(filename=request.slatwallScope.setting('globalPageMyAccount')) );
		} else {
			getFW().redirectExact( request.muraScope.createHREF(filename=request.slatwallScope.setting('globalPageMyAccount'), queryString='showItem=#arguments.view#'));
		}
	}
	
	// Special account specific logic to require a user to be logged in
	public void function after(required struct rc) {
		if(!rc.$.currentUser().isLoggedIn() && rc.slatAction != "frontend:account.create" && rc.slatAction != "frontend:account.save" && rc.slatAction != "frontend:account.noaccess") {
			getFW().setView("frontend:account.login");
		}
	}
	
	public void function verifyEmail(required struct rc) {
		param name="rc.emailVerificationID" default="";
		param name="rc.returnURL" default="";
		
		var emailVerification = getAccountService().getEmailVerification(rc.emailVerificationID);
		
		if(!isNull(emailVerification) && !isNull(emailVerification.getAccountEmailAddress())) {
			emailVerification.getAccountEmailAddress().setVerifiedFlag( true );
		}
		
		if(rc.returnURL neq "") {
			getFW().redirectExact(rc.returnURL);
		}
	}
	
	public void function renewSubscription(required struct rc) {
		var subscriptionUsage = getSubscriptionService().getSubscriptionUsage(rc.subscriptionUsageID);
		
		getSubscriptionService().processSubscriptionUsage( subscriptionUsage, {}, "manualRenew" );
		
		getFW().setView("frontend:account.listsubscription");
	}
	
}
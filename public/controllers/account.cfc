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
component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController" {

	property name="fw" type="any";
	property name="accountService" type="any";
	property name="orderService" type="any";
	property name="subscriptionService" type="any";

	public void function init( required any fw ) {
		setFW( arguments.fw );
	}

	public void function before() {
		getFW().setView("public:main.blank");
	}

	public void function after( required struct rc ) {
		if(structKeyExists(arguments.rc, "fRedirectURL") && arrayLen(getHibachiScope().getFailureActions())) {
			getFW().redirectExact( redirectLocation=arguments.rc.fRedirectURL );
		} else if (structKeyExists(arguments.rc, "sRedirectURL") && !arrayLen(getHibachiScope().getFailureActions())) {
			getFW().redirectExact( redirectLocation=arguments.rc.sRedirectURL );
		} else if (structKeyExists(arguments.rc, "redirectURL")) {
			getFW().redirectExact( redirectLocation=arguments.rc.redirectURL );
		}
	}

	// Account - Login
	public void function login( required struct rc ) {
		var account = getAccountService().processAccount( getHibachiScope().getAccount(), arguments.rc, 'login' );

		getHibachiScope().addActionResult( "public:account.login", account.hasErrors() );
	}

	// Account - Logout
	public void function logout( required struct rc ) {
		var account = getAccountService().processAccount( getHibachiScope().getAccount(), arguments.rc, 'logout' );

		getHibachiScope().addActionResult( "public:account.logout", false );
	}

	// Account - Forgot Password
	public void function forgotPassword( required struct rc ) {
		var account = getAccountService().processAccount( getHibachiScope().getAccount(), arguments.rc, 'forgotPassword');

		getHibachiScope().addActionResult( "public:account.forgotPassword", account.hasErrors() );
	}

	// Account - Reset Password
	public void function resetPassword( required struct rc ) {
		param name="rc.accountID" default="";

		var account = getAccountService().getAccount( rc.accountID );

		if(!isNull(account)) {
			var account = getAccountService().processAccount(account, rc, "resetPassword");

			getHibachiScope().addActionResult( "public:account.resetPassword", account.hasErrors() );

			// As long as there were no errors resetting the password, then we can set the email address in the form scope so that a chained login action will work
			if(!account.hasErrors() && !structKeyExists(form, "emailAddress") && !structKeyExists(url, "emailAddress")) {
				form.emailAddress = account.getEmailAddress();
			}
		} else {
			getHibachiScope().addActionResult( "public:account.resetPassword", true );
		}

		// Populate the current account with this processObject so that any errors, ect are there.
		getHibachiScope().account().setProcessObject( account.getProcessObject( "resetPassword" ) );
	}

	// Account - Change Password
	public void function changePassword( required struct rc ) {
		var account = getAccountService().processAccount( getHibachiScope().getAccount(), arguments.rc, 'changePassword');

		getHibachiScope().addActionResult( "public:account.changePassword", account.hasErrors() );
	}

	// Account - Create
	public void function create( required struct rc ) {
		param name="arguments.rc.createAuthenticationFlag" default="1";

		var account = getAccountService().processAccount( getHibachiScope().getAccount(), arguments.rc, 'create');

		getHibachiScope().addActionResult( "public:account.create", account.hasErrors() );
	}

	// Account - Update
	public void function update( required struct rc ) {
		var account = getAccountService().saveAccount( getHibachiScope().getAccount(), arguments.rc );

		getHibachiScope().addActionResult( "public:account.update", account.hasErrors() );
	}

	// Account Email Address - Delete
	public void function deleteAccountEmailAddress() {
		param name="rc.accountEmailAddressID" default="";

		var accountEmailAddress = getAccountService().getAccountEmailAddress( rc.accountEmailAddressID );

		if(!isNull(accountEmailAddress) && accountEmailAddress.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
			var deleteOk = getAccountService().deleteAccountEmailAddress( accountEmailAddress );
			getHibachiScope().addActionResult( "public:account.deleteAccountEmailAddress", !deleteOK );
		} else {
			getHibachiScope().addActionResult( "public:account.deleteAccountEmailAddress", true );
		}
	}

	// Account Email Address - Send Verification Email
	public void function sendAccountEmailAddressVerificationEmail() {
		param name="rc.accountEmailAddressID" default="";

		var accountEmailAddress = getAccountService().getAccountEmailAddress( rc.accountEmailAddressID );

		if(!isNull(accountEmailAddress) && !isNull(accountEmailAddress.getVerifiedFlag()) && !accountEmailAddress.getVerifiedFlag()) {
			accountEmailAddress = getAccountService().processAccountEmailAddress( accountEmailAddress, rc, 'sendVerificationEmail' );
			getHibachiScope().addActionResult( "public:account.sendAccountEmailAddressVerificationEmail", accountEmailAddress.hasErrors() );
		} else {
			getHibachiScope().addActionResult( "public:account.sendAccountEmailAddressVerificationEmail", true );
		}
	}

	// Account Email Address - Verify
	public void function verifyAccountEmailAddress() {
		param name="rc.accountEmailAddressID" default="";

		var accountEmailAddress = getAccountService().getAccountEmailAddress( rc.accountEmailAddressID );

		if(!isNull(accountEmailAddress)) {
			accountEmailAddress = getAccountService().processAccountEmailAddress( accountEmailAddress, rc, 'verify' );
			getHibachiScope().addActionResult( "public:account.verifyAccountEmailAddress", accountEmailAddress.hasErrors() );
		} else {
			getHibachiScope().addActionResult( "public:account.verifyAccountEmailAddress", true );
		}
	}

	// Account Phone Number - Delete
	public void function deleteAccountPhoneNumber() {
		param name="rc.accountPhoneNumberID" default="";

		var accountPhoneNumber = getAccountService().getAccountPhoneNumber( rc.accountPhoneNumberID );

		if(!isNull(accountPhoneNumber) && accountPhoneNumber.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
			var deleteOk = getAccountService().deleteAccountPhoneNumber( accountPhoneNumber );
			getHibachiScope().addActionResult( "public:account.deleteAccountPhoneNumber", !deleteOK );
		} else {
			getHibachiScope().addActionResult( "public:account.deleteAccountPhoneNumber", true );
		}
	}

	// Account Address - Delete
	public void function deleteAccountAddress() {
		param name="rc.accountAddressID" default="";

		var accountAddress = getAccountService().getAccountAddress( rc.accountAddressID );

		if(!isNull(accountAddress) && accountAddress.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
			var deleteOk = getAccountService().deleteAccountAddress( accountAddress );
			getHibachiScope().addActionResult( "public:account.deleteAccountAddress", !deleteOK );
		} else {
			getHibachiScope().addActionResult( "public:account.deleteAccountAddress", true );
		}
	}

	// Account Payment Method - Delete
	public void function deleteAccountPaymentMethod() {
		param name="rc.accountPaymentMethodID" default="";

		var accountPaymentMethod = getAccountService().getAccountPaymentMethod( rc.accountPaymentMethodID );

		if(!isNull(accountPaymentMethod) && accountPaymentMethod.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
			var deleteOk = getAccountService().deleteAccountPaymentMethod( accountPaymentMethod );
			getHibachiScope().addActionResult( "public:account.deleteAccountPaymentMethod", !deleteOK );
		} else {
			getHibachiScope().addActionResult( "public:account.deleteAccountPaymentMethod", true );
		}
	}

	// Account Payment Method - Add
	public void function addAccountPaymentMethod() {

		if(getHibachiScope().getLoggedInFlag()) {

			// Force the payment method to be added to the current account
			var accountPaymentMethod = getHibachiScope().getAccount().getNewPropertyEntity( 'accountPaymentMethods' );

			accountPaymentMethod.setAccount( getHibachiScope().getAccount() );

			accountPaymentMethod = getAccountService().saveAccountPaymentMethod( accountPaymentMethod, arguments.rc );

			getHibachiScope().addActionResult( "public:account.addAccountPaymentMethod", accountPaymentMethod.hasErrors() );

			// If there were no errors then we can clear out the

		} else {

			getHibachiScope().addActionResult( "public:account.addAccountPaymentMethod", true );

		}

	}

	// Subscription Usage - Update
	public void function updateSubscriptionUsage() {
		param name="rc.subscriptionUsageID" default="";

		var subscriptionUsage = getSubscriptionService().getSubscriptionUsage( rc.subscriptionUsageID );

		if(!isNull(subscriptionUsage) && subscriptionUsage.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
			var subscriptionUsage = getSubscriptionService().saveSubscriptionUsage( subscriptionUsage, arguments.rc );
			getHibachiScope().addActionResult( "public:account.updateSubscriptionUsage", subscriptionUsage.hasErrors() );

		} else {
			getHibachiScope().addActionResult( "public:account.updateSubscriptionUsage", true );
		}
	}

	// Subscription Usage - Renew
	public void function renewSubscriptionUsage() {
		param name="rc.subscriptionUsageID" default="";

		var subscriptionUsage = getSubscriptionService().getSubscriptionUsage( rc.subscriptionUsageID );

		if(!isNull(subscriptionUsage) && subscriptionUsage.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
			var subscriptionUsage = getSubscriptionService().processSubscriptionUsage( subscriptionUsage, arguments.rc, 'renew' );
			getHibachiScope().addActionResult( "public:account.updateSubscriptionUsage", subscriptionUsage.hasErrors() );

		} else {
			getHibachiScope().addActionResult( "public:account.updateSubscriptionUsage", true );
		}
	}

	public void function duplicateOrder() {
		param name="arguments.rc.orderID" default="";
		param name="arguments.rc.setAsCartFlag" default="0";

		var order = getOrderService().getOrder( arguments.rc.orderID );
		if(!isNull(order) && order.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID()) {

			var data = {
				saveNewFlag=true,
				copyPersonalDataFlag=true
			};

			var duplicateOrder = getOrderService().processOrder(order,data,"duplicateOrder" );

			if(isBoolean(arguments.rc.setAsCartFlag) && arguments.rc.setAsCartFlag) {
				getHibachiScope().getSession().setOrder( duplicateOrder );
			}
			getHibachiScope().addActionResult( "public:account.duplicateOrder", false );
		} else {
			getHibachiScope().addActionResult( "public:account.duplicateOrder", true );
		}
	}

}

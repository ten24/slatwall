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
component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {

	public void function setUp() {
		super.setup();
		
		variables.service = request.slatwallScope.getBean("accountService");
	}
	
	public void function defaults_are_correct() {
		assertTrue( isObject(variables.service.getEmailService()) );
	}
	
	public void function deleteAccountAddress_removes_account_address_from_all_order_relationships() {
		var accountAddress = request.slatwallScope.newEntity('accountAddress');
		var account = request.slatwallScope.newEntity('account');
		
		accountAddress.setAccount(account);
		
		entitySave(accountAddress);
		
		var deleteOK = variables.service.deleteAccountAddress(accountAddress);
		
		assert(deleteOK);
	}
	
	public void function processAccount_addAccountPayment(){
		var accountData = {
			accountID=""
		};
		var account = createPersistedTestEntity('Account',accountData);

		var paymentMethodData = {
			paymentMethodID="",
			paymentMethodType="termPayment",
			activeFlag=1
		};
		var paymentMethod = createPersistedTestEntity('PaymentMethod',paymentMethodData);
		
		var checkPaymentMethodData = {
			paymentMethodID="",
			paymentMethodType="check",
			activeFlag=1
		};
		var checkPaymentMethod = createPersistedTestEntity('PaymentMethod',checkPaymentMethodData);
		
		var accountPaymentMethodData = {
			accountPaymentMethodID="",
			activeFlag=1,
			paymentMethod={
				paymentMethodID=paymentMethod.getPaymentMethodID()
			},
			paymentTerm={
				paymentTermID="27f223d1a5b7cba92e783c926e29efc6"
			},
			account={
				accountID=account.getAccountID()
			}
		};
		var accountPaymentMethod = createPersistedTestEntity('AccountPaymentMethod',accountPaymentMethodData);
		assert(!isNull(accountPaymentMethod.getPaymentMethod()));
		assert(!isNull(accountPaymentMethod.getPaymentTerm()));
		assert(!isNull(accountPaymentMethod.getAccount()));
		
		var orderData={
			orderID="",
			account={
				accountID=account.getAccountID()
			},
			orderType={
				//Sales Order
				typeID="444df2df9f923d6c6fd0942a466e84cc"
			}
		};
		var order = createPersistedTestEntity('Order',orderData);
		
		var orderItemData = {
			orderItemID="",
			
			order={
				orderID=order.getOrderID()
			},
			price=77.00
		};
		var orderItem = createPersistedTestEntity('OrderItem',orderItemData);
		
		var orderPaymentData = {
			orderPaymentID="",
			order={
				orderID=order.getOrderID()
			},
			accountPaymentMethod={
				accountPaymentMethodID=accountPaymentMethod.getAccountPaymentMethodID()
			},
			paymentMethod={
				paymentMethodID="444df303dedc6dab69dd7ebcc9b8036a"
			},
			orderPaymentType={
				//charge
				orderPaymentTypeID="444df2f0fed139ff94191de8fcd1f61b"
			}
		};
		var orderPayment = createPersistedTestEntity('OrderPayment',orderPaymentData);
		
		assert(!isNull(orderPayment.getOrder()));
		assert(!isNull(orderPayment.getAccountPaymentMethod()));
		assert(!isNull(orderPayment.getOrderPaymentType()));
		ormflush();
		var data = {
			accountAddressID="",
			billingAddress={
				addressID="",
				countryCode='US',
				name="test",
				company="test",
				streetAddress="test",
				street2Address="test",
				city="test",
				statCode="MA",
				postalCode="01757"
			},
			appliedOrderPayments=[
				{
					amount=1,
					orderPaymentID=orderPayment.getOrderPaymentID(),
					//aptCharge
					paymentTypeID="444df32dd2b0583d59a19f1b77869025"
				}
			],
			newAccountPayment={
				accountPaymentID="",
				amount = 2,
				currencyCode='USD',
				paymentMethod={
					paymentMethodID=checkPaymentMethod.getPaymentMethodID()
				},
				account={
					accountID=account.getAccountID()
				},
				accountPaymentType={
					//aptCharge
					typeID="444df32dd2b0583d59a19f1b77869025"
				},
				getAccountPaymentMethodID="",
				saveAccountPaymentMethodFlag=0,
				accountID=account.getAccountID()
			},
			preProcessDisplayedFlag=1,
			processContext="addAccountPayment"
		};
		
		account = variables.service.process(account,data,'addAccountPayment');
		
		assert(arraylen(account.getAccountPayments()));
		assert(arraylen(account.getAccountPayments()[1].getAppliedAccountPayments()));
		assert(arraylen(account.getAccountPayments()[1].getPaymentTransactions()));
		assert(account.getAccountPayments()[1].getPaymentTransactions()[1].getTransactionSuccessFlag());
		
		assertFalse(account.hasErrors());
	}
}



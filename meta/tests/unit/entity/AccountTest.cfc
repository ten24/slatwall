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
component extends="Slatwall.meta.tests.unit.entity.SlatwallEntityTestBase" {

	// @hint put things in here that you want to run befor EACH test
	public void function setUp() {
		super.setup();

		variables.entityService = "accountService";
		variables.entity = request.slatwallScope.getService( variables.entityService ).newAccount();
	}

	public void function accountCanBeDeleted() {
		var accountService = request.slatwallScope.getService("accountService");

		var accountData = {
			firstName = "Account",
			lastName = "Delete",
			phoneNumber = "1234567890",
			createAuthenticationFlag = 0
		};

		var account = entityNew("SlatwallAccount");

		account = accountService.processAccount(account, accountData, 'create');
		var accountHasErrors = account.hasErrors();

		ormFlush();

		var deleteOK = accountService.deleteAccount(account);

		assert(deleteOk);

		ormFlush();
	}

	public void function password_reset_test() {

		var accountData = {
			accountID=lcase(Replace(createUUID(), '-', '', "All")),
			accountAuthentications = [
				{
					accountAuthenticationID=lcase(Replace(createUUID(), '-', '', "All")),
					expirationDateTime=dateAdd("d", 7, now())
				},
				{
					accountAuthenticationID=lcase(Replace(createUUID(), '-', '', "All")),
					expirationDateTime=dateAdd("d", -7, now())
				}
			]
		};
		var account = createPersistedTestEntity('account', accountData);
		var accountID = account.getAccountID();
		var auth1ID = account.getAccountAuthentications()[1].getAccountAuthenticationID();

		assertEquals(lcase("#accountID##hash(auth1ID & accountID)#"), account.getPasswordResetID() );
	}

	public void function test_gift_card_relation(){
		var accountData = {
			accountID=""
		};
		var giftCardData = {
			giftCardID=""
		};

		var account = createPersistedTestEntity('account', accountData);
		var giftCard = createPersistedTestEntity('giftCard', giftCardData);

		account.addGiftCard(giftCard);

		assertTrue(account.hasGiftCard(giftCard));

		account.removeGiftCard(giftCard);

		assertFalse(account.hasGiftCard(giftCard));
	}
	
	public void function getTermAccountAvailableCreditTest(){
		//testing both for loops have been reached
		var accountData1 = {
			accountID = "",
			firstName = "testPaymentMethodType",
			lastName = "pmLastName"
		};
		var mockAccount1 = createPersistedTestEntity("Account", accountData1);
		
		var orderData = {
			orderID = "",
			account = {
				accountID = mockAccount1.getAccountID()
			}
		};
		var mockOrder1 = createPersistedTestEntity("Order", orderData);

		var orderPaymentsData1 = {
			orderPaymentID = "",
			amount = 2300,
			orderPaymentType = "444df2f0fed139ff94191de8fcd1f61b",//optCharge
			order = {
				orderID = mockOrder1.getOrderID()
			},
			termPaymentAccount = {
				accountID = mockAccount1.getAccountID()
			}
		};
		var orderPayment1 = createPersistedTestEntity("OrderPayment", orderPaymentsData1);
		
		var accountPaymentData = {
			accountPaymentID = "",
			account = {
				accountID = mockAccount1.getAccountID()
			}
		};
		var accountPayment1 = createPersistedTestEntity("AccountPayment", accountPaymentData);
		
		var accountPaymentAppliedData = {
			accountPaymentAppliedID = "",
			amount = 10.00,
			accountPaymentType = {
					typeID="444df32dd2b0583d59a19f1b77869025" //aptCharge
			},
			accountPayment = {
				accountPaymentID = accountPayment1.getAccountPaymentID()
			}
		};
		var accountPaymentApplied1 = createPersistedTestEntity("AccountPaymentApplied", accountPaymentAppliedData);
		
		//create setting
		var settingData = {
			settingID="",
			settingName="accountTermCreditLimit",
			settingValue=2220
		};
		var settingEntity = createPersistedTestEntity('Setting',settingData);
		

		assertEquals(-70, mockAccount1.getTermAccountAvailableCredit());
	}

}



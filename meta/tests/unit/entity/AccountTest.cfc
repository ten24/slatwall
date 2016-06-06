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
	// ================== START TESTING: Non-Persistent Property Methods ========================
	
	//	need to have consistent domain to host image in order to test consistently and safely
//	public void function getAdminIconTest() {
//		var accountData = {
//			accountID = "001",
//			gravatarURL = "http://7-themes.com/data_images/out/39/6902886-sakura-wallpaper.jpg"
//			
//		};
//		var mockAccount = createTestEntity('Account', accountData);
//		var resultExistingAdminIcon = mockAccount.getAdminIcon(80);
//		request.debug(resultExistingAdminIcon);
//		assertEquals(resultExistingAdminIcon, "see output first");
//	}

	public void function getEmailAddressTest() {
		//Testing existed accountEmailAddress
		var accountData = {
			accountID = "",
			firstName = "Hello",
			lastName = "Kitty",
			accountEmailAddresses = [
				{
					accountEmailAddressID = "00033",
					emailAddress = "firstaccountEamilAddress@hotmail.com"
				},{
					accountEmailAddressID = "00034",
					emailAddress = "secondAccountEmailAddress@hotmail.com"
				}
			]		
		};
		var mockAccount = createTestEntity('Account', accountData);
		var resultEmailAddress = mockAccount.getEmailAddress();
		assertEquals(resultEmailAddress, "firstaccountEamilAddress@hotmail.com");
		//Testing empty accountEmailAddress
		accountData = {
			accountID = "",
			firstName = "Hello",
			lastName = "Kitty"
		};
		mockAccount = createTestEntity('Account', accountData);
		assertTrue(isNull(mockAccount.getEmailAddress()));
	}
	
	public void function getFullNameTest() {
		//testing existing FirstName & LastName
		var accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty"
		};
		var mockAccount = createTestEntity('Account', accountData);
		var resultFirstLastName = mockAccount.getFullName();
		assertEquals(resultFirstLastName, "Hello Kitty");
		//testing existing FirstName empty LastName
		accountData = {
			accountID = "001",
			firstName = "Hello"
		};
		mockAccount = createTestEntity('Account', accountData);
		var resultOnlyFirstName = mockAccount.getFullName();
		assertEquals(resultOnlyFirstName, "Hello "); 
		//testing empty FirstName existing LastName
		accountData = {
			accountID = "001",
			lastName = "Kitty"
		};
		mockAccount = createTestEntity('Account', accountData);
		var resultOnlyLastName = mockAccount.getFullName();
		assertEquals(resultOnlyLastName, " Kitty");
		//testing empty FirstName & LastName
		accountData = {
			accountID = "001"
		};
		mockAccount = createTestEntity('Account', accountData);
		var resultNoName = mockAccount.getFullName();
		assertEquals(resultNoName, " ");
	}
	public void function getAddressTest() {
		//testing existing PrimaryAddress existing Account Address
		var accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty",
			primaryAddress = {
				accountAddressID = "0001",
				address={
					addressID = "",
					streetAddress = "primary address",
					name = "ten24DSPrimaryAddressName"
				}
			},
			accountAddresses = [{
				accountAddressID = "",
				address={
					addressID = "034401",
					name = "ten24DS"
				}
			}]
		};
		var mockAccount = createTestEntity('Account', accountData);
		var resultBothAddress = mockAccount.getAddress().getName();
		assertEquals(resultBothAddress, "ten24DSPrimaryAddressName");
		//testing empty PrimaryAddress but existing Address
		accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty",
			accountAddresses = [{
				accountAddressID = "",
				address={
					addressID = "001",
					name = "ten24DS",
					city = "worcester",
					firstName = "Yuqing",
					streetAddress = "12 Franklin St",
					phoneNumber = "123"
				}
			}]
		};
		mockAccount = createTestEntity('Account', accountData);
		var resultNoPrimaryYesAccountAddress = mockAccount.getAddress().getStreetAddress();
		assertEquals(resultNoPrimaryYesAccountAddress, "12 Franklin St");
		//testing existing PrimaryAddress no Account Address
		accountData = {
			accountID = "002",
			firstName = "Hello",
			lastName = "Kit",
			primaryAddress={ 
				accountAddressID="",
				address={
					addressID = "",
					streetAddress = "primary address",
					phoneNumber = "123"
				}
			}
		};
		mockAccount = createTestEntity('Account', accountData);
		var resultExistPrimaryNoAccountAddress = mockAccount.getAddress().getphoneNumber();
		assertEquals(resultExistPrimaryNoAccountAddress, "123");		
		
	}
	
	public void function getPhoneNumberTest() {
		//Testing existing primaryPhoneNumber empty accountPhoneNumbers
		var accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty",
			primaryPhoneNumber = {
				accountPhoneNumberID = "0001",
				phoneNumber = "123"
			}
			
		};
		var mockAccount = createTestEntity('Account', accountData);
		var resultPrimaryPhone = mockAccount.getPhoneNumber();
		assertEquals(resultPrimaryPhone, "123");
		//Testing existing primaryPhoneNumber existing accountPhoneNumbers
		accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty",
			primaryPhoneNumber = {
				accountPhoneNumberID = "0001",
				phoneNumber = "123"
			},
			accountPhoneNumbers = [{
					accountPhoneNumberID = "10033",
					phoneNumber = "firstphoneNumber"
				}]
		};
		mockAccount = createTestEntity('Account', accountData);
		var resultBothPhones = mockAccount.getPhoneNumber();
		assertEquals(resultBothPhones, "123");
		//Testing empty primaryPhoneNumber existing accountPhoneNumbers
		accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty",
			accountPhoneNumbers = [{
					accountPhoneNumberID = "10033",
					phoneNumber = "firstphoneNumber"
			}]
		};
		mockAccount = createTestEntity('Account', accountData);
		var resultEmptyPrimaryExistAccountPhone = mockAccount.getPhoneNumber();
		assertEquals(resultEmptyPrimaryExistAccountPhone, "firstphoneNumber");
	}
	

	
	public void function getAdminAccountFlagTest() {
		//testing TRUE SuperUser with PermissionGroup
		var accountData = {
			accountID = "001",
			
			permissionGroups = [{
				permissionGroupID = "001",
				permissionGroupName = "Permission1"
			},{
				permissionGroupID = "",
				permissionGroupName = "Permission2"
			}],
			superUserFlag = TRUE	
		};
		var mockAccount = createTestEntity('Account', accountData);
		var resultTrueSUExistPG = mockAccount.getAdminAccountFlag();
		assertTrue(resultTrueSUExistPG);
		//testing false SuperUser with PermissionGroup
		accountData = {
			accountID = "001",
			permissionGroups = [{
				permissionGroupID = "001",
				permissionGroupName = "Permission1"
			},{
				permissionGroupID = "",
				permissionGroupName = "Permission2"
			}]
		};
		mockAccount = createTestEntity('Account', accountData);
		var resultNoSUExistPG = mockAccount.getAdminAccountFlag();
		assertTrue(resultNoSUExistPG);
		//testing False SuperUser with None PermissionGroup
		accountData = {
			accountID = "001"	
		};
		mockAccount = createTestEntity('Account', accountData);
		var resultNSUNoPG = mockAccount.getAdminAccountFlag();
		assertFalse(resultNSUNoPG);
	}
	
	public void function getGiftCardSmartListTest() {//Working on, not finished
		
		var accountData = {
			accountID = "001",
			superUserFlag = TRUE	
		};
		var mockAccount = createTestEntity('Account', accountData);
		var result = mockAccount.getGiftCardSmartList();
		request.debug(result);
		assertFalse(resultNSUNoPG);
	}
	// ============  END TESTING:  Non-Persistent Property Methods =================
	
	// ================== START TESTING: Overridden Methods ========================
	public void function getPrimaryEmailAddressTest() {
		//testing existing pimaryEamilAddress
		var accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty",
			primaryEmailAddress = {
				accountEmailAddressID = "0001",
				emailAddress = "123@hotmail.com"
			}
		};
		var mockAccount = createTestEntity('Account', accountData);
		var resultPrimaryEmail = mockAccount.getPrimaryEmailAddress().getEmailAddress();
		assertEquals(resultPrimaryEmail, "123@hotmail.com");
		//testing empty PrimaryEmailAddress and empty accountEmailAddress
		accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty"
		};
		mockAccount = createTestEntity('Account', accountData);
		assertTrue(mockAccount.getPrimaryEmailAddress().getNewFlag());
		//testing empty PrimaryEmailAddress and existing accountEmailAddress
		accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty",
			accountEmailAddresses = [
				{
					accountEmailAddressID = "",
					emailAddress = "firstaccountEamilAddress@hotmail.com"
				},{
					accountEmailAddressID = "",
					emailAddress = "secondAccountEmailAddress@hotmail.com"
				}
			]
		};
		mockAccount = createPersistedTestEntity('Account', accountData);
		var resultNoPrimaryExistAccountOne = mockAccount.getPrimaryEmailAddress().getEmailAddress();
		assertEquals(resultNoPrimaryExistAccountOne, "firstaccountEamilAddress@hotmail.com");
		
	}
	
	public void function getPrimaryPhoneNumberTest() {
		//Testing existing primaryPhoneNumber
		var accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty",
			primaryPhoneNumber = {
				accountPhoneNumberID = "0001",
				phoneNumber = "123"
			}
		};
		var mockAccount = createTestEntity('Account', accountData);
		var resultPrimaryPhone = mockAccount.getPrimaryPhoneNumber().getPhoneNumber();
		assertEquals(resultPrimaryPhone, "123");
		//Testing emmpty primaryPhoneNumber
		accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty",
			primaryPhoneNumber = {}
		};
		mockAccount = createTestEntity('Account', accountData);
		assertTrue(isNull(mockAccount.getPrimaryPhoneNumber().getPhoneNumber()));
		//Testing empty primaryPhoneNumber but existing phoneNumber
		accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty",
			primaryPhoneNumber = {},//hi
			accountPhoneNumbers = [
				{
					accountPhoneNumberID = "10033",
					phoneNumber = "firstphoneNumber"
				},{
					accountPhoneNumberID = "10034",
					phoneNumber = "secondphoneNumber"
				}
			]
		};
		mockAccount = createTestEntity('Account', accountData);
		resultNoPrimaryPhoneExistAccountPhone = mockAccount.getPrimaryPhoneNumber().getPhoneNumber();
		assertEquals(resultNoPrimaryPhoneExistAccountPhone, "firstphoneNumber");
	}
	
	public void function getPrimaryAddressTest() {
		//testing existing PrimaryAddress
		var accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty",
			primaryAddress = {
				accountAddressID = "0001",
				accountAddressName = "123 Franklin St"
			}
		};
		var mockAccount = createTestEntity('Account', accountData);
		var resultPrimaryAddress = mockAccount.getPrimaryAddress().getAccountAddressName();
		assertEquals(resultPrimaryAddress, "123 Franklin St");
		//testing empty PrimaryAddress but existing Address
		var accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty",
			accountAddresses = [{
				accountAddressID = "0001",
				accountAddressName = "12 Franklin St"
			}]
		};
		var mockAccount = createTestEntity('Account', accountData);
		var resultNoPrimaryAddressExistAddress = mockAccount.getPrimaryAddress().getAccountAddressName();
		assertEquals(resultNoPrimaryAddressExistAddress, "12 Franklin St");
		//testing empty PrimaryAddress empty address
		accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty"
		};
		mockAccount = createTestEntity('Account', accountData);
		assert(mockAccount.getPrimaryAddress().getNewFlag());
	}
	
	public void function getPrimaryPaymentMethodTest() {
		//testing existing PrimaryPaymentMethod
		var accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty",
			primaryPaymentMethod = {
				accountPaymentMethodID = "0001",
				accountPaymentMethodName = "Yuqing BOA card",
				nameOnCreditCard = "Yuqing"
			}
		};
		var mockAccount = createTestEntity('Account', accountData);
		var resultPrimaryPaymentNameOnCreditCard = mockAccount.getPrimaryPaymentMethod().getNameOnCreditCard();
		assertEquals(resultPrimaryPaymentNameOnCreditCard, "Yuqing");
		var resultPrimaryPaymentAccountPaymentMethodName = mockAccount.getPrimaryPaymentMethod().getaccountPaymentMethodName();
		assertEquals(resultPrimaryPaymentAccountPaymentMethodName, "Yuqing BOA card");
		//testing empty PrimaryPaymentMethod but existing account paymentMethods
		accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty",
			accountPaymentMethods = [{
				accountPaymentMethodID = "0001",
				accountPaymentMethodName = "Yuqing BOA card",
				nameOnCreditCard = "YuqingYang"
			}]
		};
		mockAccount = createTestEntity('Account', accountData);
		var resultNoPrimaryPaymentExistingPayment = mockAccount.getPrimaryPaymentMethod().getNameOnCreditCard();
		assertEquals(resultNoPrimaryPaymentExistingPayment, "YuqingYang");
		//testing empty PrimaryPaymentMethod
		accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty"
		};
		mockAccount = createTestEntity('Account', accountData);
		var resultNonePrimaryPayment = mockAccount.getPrimaryPaymentMethod();
		assertTrue(resultNonePrimaryPayment..getNewFlag());
		
	}
	
	public void function getSuperUserFlagTest() {
		//testing existing flag == TRUE
		var accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty",
			superUserFlag = true
		};
		var mockAccount = createTestEntity('Account', accountData);
		var resultTrueSuperUserFlag = mockAccount.getSuperUserFlag();
		assertTrue(resultTrueSuperUserFlag);
		//testing existing flag == False
		accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty",
			superUserFlag = FALSE
		};
		mockAccount = createTestEntity('Account', accountData);
		var resultFalseSuperUserFlag = mockAccount.getSuperUserFlag();
		assertFalse(resultFalseSuperUserFlag);
		//testing empty flag
		accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty"
		};
		mockAccount = createTestEntity('Account', accountData);
		var resultEmptySuperUserFlag = mockAccount.getSuperUserFlag();
		assertFalse(resultEmptySuperUserFlag);
	}
	
	public void function getSimpleRepresentationTest() {
		//testing existing FirstName & LastName
		var accountData = {
			accountID = "",
			firstName = "Hello",
			lastName = "Kitty"
		};
		var mockAccount = createTestEntity('Account', accountData);
		var resultFirstLastName = mockAccount.getSimpleRepresentation();
		assertEquals(resultFirstLastName, "Hello Kitty");
		//testing empty FirstName & LastName
		accountData = {
			accountID = "001"
		};
		mockAccount = createTestEntity('Account', accountData);
		var resultFirstLastName = mockAccount.getSimpleRepresentation();
		assertEquals(resultFirstLastName, " ");
		//testing empty account
		accountData = {};
		mockAccount = createTestEntity('Account', accountData);
		var resultFirstLastName = mockAccount.getSimpleRepresentation();
		assertEquals(resultFirstLastName, " ");
	}
	
}



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
	
//	TODO: need to have consistent domain to host image in order to test consistently and safely
//	public void function getAdminIconTest() {
//		var accountData = {
//			accountID = "001",
//			gravatarURL = "http://7-themes.com/data_images/out/39/6902886-sakura-wallpaper.jpg"
//			
//		};
//		var mockAccount = createTestEntity('Account', accountData);
//		var resultExistingAdminIcon = mockAccount.getAdminIcon(80);
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
	
	public void function getGiftCardSmartListTest() {
		//testing existed GiftCard SmartList
		var accountData = {
			accountID = "",
			firstName = "hello"
		};		
		var mockAccount = createPersistedTestEntity("Account", accountData);		
		var giftCard1Data = {
			giftCardID = "",
			giftCardCode = "firstGiftCardCode",
			ownerAccount = {
				accountID = mockAccount.getAccountID()
			}
		};		
		var giftCard2Data = {
			giftCardID = "",
			giftCardCode = "secondGiftCardCode",
			ownerAccount = {
				accountID = mockAccount.getAccountID()
			}
		};	
		var giftCard3Data = {
			giftCardID = "",
			giftCardCode = "thirdGiftCardCode",
			ownerAccount = {
				accountID = mockAccount.getAccountID()
			}
		};				
		var giftCard1 = createPersistedTestEntity('GiftCard', giftcard1Data);
		var giftCard2 = createPersistedTestEntity('GiftCard', giftcard2Data);
		var giftCard3 = createPersistedTestEntity('GiftCard', giftcard3Data);
		
		
		var resultExistSM = mockAccount.getGiftCardSmartList().getRecords();
		assertEquals(arraylen(resultExistSM), arraylen(mockAccount.getGiftCards()));
		//testing empty GiftCard SmartList
		var accountData = {
			accountID = "",
			firstName = "hello"
		};		
		var mockAccount = createPersistedTestEntity("Account", accountData);
		var resultEmptyGC = mockAccount.getGiftCardSmartList().getRecords();
		assertEquals(arraylen(resultEmptyGC), 0);				
	}
	
	public void function getOrdersPlacedSmartList_AccountIDFilter_DESCOrderByDate_Test() {
		var accountData = {
			accountID = "",
			firstName = "hello"	
		};
		var accountData2 = {
			accountID = "",
			firstName = "Kitty"	
		};
		var mockAccount = createPersistedTestEntity("Account", accountData);
		var mockAccount2 = createPersistedTestEntity("Account", accountData2);		
		var order1Data = {
			orderID = "",
			orderNumber = "orderNumber001",
			orderOpenDateTime = dateAdd('d', 1, now()),
			orderStatusType = {
				typeID = "444df2b5c8f9b37338229d4f7dd84ad1"
			},
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		var order2Data = {
			orderID = "",
			orderNumber = "orderNumber002",
			orderOpenDateTime = dateAdd('d', 4, now()),
			orderStatusType = {
				typeID = "444df2b90f62f72711eb5b3c90848e7e"
			},
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		var order3Data = {
			orderID = "",
			orderNumber = "orderNumber003",
			orderOpenDateTime = dateAdd('d', -2, now()),
			orderStatusType = {
				typeID = "444df2b6b8b5d1ccfc14a4ab38aa0a4c"
			},
			account = {
				accountID = mockAccount.getAccountID()
			}
		};	
		var order4Data = {
			orderID = "",
			orderNumber = "orderNumber004",
			orderOpenDateTime = dateAdd('d', -2, now()),
			orderStatusType = {
				typeID = "444df2b6b8b5d1ccfc14a4ab38aa0a4c"
			},
			account = {
				accountID = mockAccount2.getAccountID()
			}
		};	
		var order1 = createPersistedTestEntity('Order', order1Data);
		var order2 = createPersistedTestEntity('Order', order2Data);
		var order3 = createPersistedTestEntity('Order', order3Data);
		var order4 = createPersistedTestEntity('Order', order4Data);
		//testing to get the correct number of records in SmartList
		var resultOrdersPlacedSM = mockAccount.getOrdersPlacedSmartList().getRecords();
		assertEquals(arraylen(resultOrdersPlacedSM), 3);
		//testing if the smart list is ordered by orderOpenDateTime DESC
		assertEquals(resultOrdersPlacedSM[1].getOrderNumber(), "orderNumber002");
		assertEquals(resultOrdersPlacedSM[2].getOrderNumber(), "orderNumber001");
		assertEquals(resultOrdersPlacedSM[3].getOrderNumber(), "orderNumber003");
		//testing if AccountID filter works in the SmartList
		var resultOrdersPlacedSM2 = mockAccount2.getOrdersPlacedSmartList().getRecords();
		assertEquals(resultOrdersPlacedSM[1].getAccount().getAccountID(),mockAccount.getAccountID());
		assertEquals(resultOrdersPlacedSM2[1].getAccount().getAccountID(),mockAccount2.getAccountID());
	}
	public void function getOrdersPlacedSmartList_StatusTypeFilter_Test() {
		var accountData = {
			accountID = "",
			firstName = "hello"		
		};
		var mockAccount = createPersistedTestEntity("Account", accountData);	
		//StatusType is "Cancelling", normal case, should be insert into the smart list	
		var order1Data = {
			orderID = "",
			orderNumber = "orderNumber001",
			orderOpenDateTime = dateAdd('d', 1, now()),
			orderStatusType = {
				typeID = "444df2b90f62f72711eb5b3c90848e7e"
			},
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		//StatusType not existed
		var order2Data = {
			orderID = "",
			orderNumber = "orderNumber002",
			orderOpenDateTime = dateAdd('d', 4, now()),
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		//StatusType is "Not Placed",  not one of the four
		var order3Data = {
			orderID = "",
			orderNumber = "orderNumber003",
			orderOpenDateTime = dateAdd('d', -2, now()),
			orderStatusType = {
				typeID = "444df2b498de93b4b33001593e96f4be",
				typeName = "Not Placed"
			},
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		var order1 = createPersistedTestEntity('Order', order1Data);
		var order2 = createPersistedTestEntity('Order', order2Data);
		var order3 = createPersistedTestEntity('Order', order3Data);
		var resultOrdersPlacedSM = mockAccount.getOrdersPlacedSmartList().getRecords();
		assertEquals(arraylen(resultOrdersPlacedSM), arraylen(mockAccount.getOrders()) - 2);
	}
	
public void function getPrimaryEmailAddressesNotInUseFlagTest() {
		//testing when the email has not been used
		var accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty",
			primaryEmail = {
				accountEmailAddressID = "",
				emailAddress = "hk@happy.com"
			},
			accountAuthentications = {
				accountAuthenticationID=""
			}
		};
		var mockAccount = createTestEntity('Account', accountData);
		var resultNewPrimaryEmail = mockAccount.getPrimaryEmailAddressesNotInUseFlag();
		assertTrue(resultNewPrimaryEmail);
		//testing when primary email is empty, default flag should be true
		var accountDataNoPE = {
			accountID = "002",
			firstName = "Hello2",
			lastName = "Kitty2",
			accountAuthentications = {
				accountAuthenticationID=""
			}
		};
		var mockAccountNoPE = createTestEntity('Account', accountDataNoPE);
		var resultNoPrimaryEmail = mockAccount.getPrimaryEmailAddressesNotInUseFlag();
		assertTrue(resultNoPrimaryEmail);
		//testing if one account use the same PrimaryEmail already belongs to another account
		var email = createUUID()&"@test.com";
		var emailDate = {
			accountEmailAddressID = "",
			emailAddress = email
		};
		var mockEmail = createPersistedTestEntity('AccountEmailAddress', emailDate);
		
		var accountData1 = {
			accountID = "",
			primaryEmailAddress={
				accountEmailAddressID=mockEmail.getAccountEmailAddressID()
			}
		};
		
		var mockAccount1 = createPersistedTestEntity('Account', accountData1);
		
		var accountAuthenticationData = {
			accountAuthenticationID="",
			account={
				accountID=mockAccount1.getAccountID()
			}
		};
		accountAuthentication = createPersistedTestEntity('AccountAuthentication',accountAuthenticationData);
		
		var accountData2 = {
			accountID = "",
			primaryEmailAddress={
				accountEmailAddressID="",
				emailAddress=email
			}
		};
		var mockAccount2 = createTestEntity('Account', accountData2);
		
		assertFalse(mockAccount2.getPrimaryEmailAddressesNotInUseFlag());	
	}

	public void function getOrdersNotPlacedSmartListTest() {
		var accountData = {
			accountID = "",
			firstName = "hello"
		};
		var mockAccount = createPersistedTestEntity("Account", accountData);
		//Testing the normal case, StatueType is 'Not Placed'		
		var order1Data = {
			orderID = "",
			orderNumber = "orderNumber001",
			orderStatusType = {
				typeID = "444df2b498de93b4b33001593e96f4be"
			},
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		var order4Data = {
			orderID = "",
			orderNumber = "orderNumber004",
			orderStatusType = {
				typeID = "444df2b498de93b4b33001593e96f4be"
			},
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		
		//Testing order already been placed
		var order2Data = {
			orderID = "",
			orderNumber = "orderNumber002",
			orderStatusType = {
				typeID = "444df2b6b8b5d1ccfc14a4ab38aa0a4c"
			},
			account = {
				accountID = mockAccount.getAccountID()
			}
		};	
		//Testing cancelling order (been placed)
		var order3Data = {
			orderID = "",
			orderNumber = "orderNumber003",
			orderStatusType = {
				typeID = "444df2b90f62f72711eb5b3c90848e7e"
			},
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		var order1 = createPersistedTestEntity('Order', order1Data);
		var order2 = createPersistedTestEntity('Order', order2Data);
		var order3 = createPersistedTestEntity('Order', order3Data);
		sleep(1000);//Make the modifiedDateTime of order4 BIGGER that of order1
		var order4 = createPersistedTestEntity('Order', order4Data);
		var resultOrdersNotPlacedSM = mockAccount.getOrdersNotPlacedSmartList();
		assertEquals(arraylen(resultOrdersNotPlacedSM.getRecords(refresh=true)), 2);
		//testing the DESC order of modified date, failed.
		assertEquals(resultOrdersNotPlacedSM.getRecords(refresh=true)[1].getOrderNumber(), "orderNumber004");	
	}

	public void function getSlatwallAuthenticationExistsFlag_WithPassword_Test() {
		//testing the authentication w/ Password only, authz flag should be true
		var accountData2 = {
			accountID = "",
			firstName = "Hol2a"
		};
		var mockAccount2 = createPersistedTestEntity('Account', accountData2);
		var authzData2HasPassword = {
			accountAuthenticationID = "",
			password = "123",
			account = {
				accountID = mockAccount2.getAccountID()
			}
		};
		var mockAccountAuthentications2 = createPersistedTestEntity('AccountAuthentication', authzData2HasPassword);
		var resultWithPassword = mockAccount2.getSlatwallAuthenticationExistsFlag();		
		assertTrue(resultWithPassword);
	}
	public void function getSlatwallAuthenticationExistsFlag_WithIntegration_Test() {
		//testing the authentictions w/ Integration only, shoule be false
		var accountData3 = {
			accountID = "",
			firstName = "Hola"
		};
		var mockAccount3 = createPersistedTestEntity('Account', accountData3);
		var authzData3HasIntegration = {
			accountAuthenticationID = "",
			integration={
				integrationID="4028288f549c11ac01549c1bb4c80000"
			},
			account = {
				accountID = mockAccount3.getAccountID()
			}
		};
		var mockAccountAuthentications3 = createPersistedTestEntity('AccountAuthentication', authzData3HasIntegration);
		var resultWithIntegration = mockAccount3.getSlatwallAuthenticationExistsFlag();
		assertFalse(resultWithIntegration);	
	}
	
	public void function getSlatwallAuthenticationExistsFlag_WithPwdAndIntegration_Test() {
		//testing tue authentication w/ Integration and w/ Passoword, should be false
		var accountData4 = {
			accountID = "",
			firstName = "Hola"
		};
		var mockAccount4 = createPersistedTestEntity('Account', accountData4);
		var authzData4PwdIntegration = {
			accountAuthenticationID = "",
			integration={
				integrationID="4028288f549c11ac01549c1bb4c80000"
			},
			account = {
				accountID = mockAccount4.getAccountID()
			}
		};
		var mockAccountAuthentications4 = createPersistedTestEntity('AccountAuthentication', authzData4PwdIntegration);
		var resultPwdIntegration = mockAccount4.getSlatwallAuthenticationExistsFlag();
		assertFalse(resultPwdIntegration);		
	}
	
	public void function getSlatwallAuthenticationExistsFlag_TrueActiveFlag_Test() {
		//Under condition that if the first logical connectives returns true;		
		//testing normal case, activeFlag is true
		var accountData1 = {
			accountID = "",
			firstName = "Ha"
		};
		var mockAccount1 = createPersistedTestEntity('Account', accountData1);
		var authzData1 = {
			accountAuthenticationID = "",
			activeFlag = TRUE,
			password = "12345",
			account = {
				accountID = mockAccount1.getAccountID()
			}
		};
		var mockAccountAuthentications1 = createPersistedTestEntity('AccountAuthentication', authzData1);		
		var resultTrueFlag = mockAccount1.getSlatwallAuthenticationExistsFlag();
		assertTrue(resultTrueFlag);
	}
	public void function getSlatwallAuthenticationExistsFlag_FalseActiveFlag_Test() {
		//Under condition that if the first logical connectives returns true;
		//testing when activeFlag is false
		var accountData2 = {
			accountID = "",
			firstName = "Hola"
		};
		var mockAccount2 = createPersistedTestEntity('Account', accountData2);
		var authzData2 = {
			accountAuthenticationID = "",
			activeFlag = FALSE,
			password = "12345",
			account = {
				accountID = mockAccount2.getAccountID()
			}
		};
		var mockAccountAuthentications2 = createPersistedTestEntity('AccountAuthentication', authzData2);		
		var resultFalseFlag = mockAccount2.getSlatwallAuthenticationExistsFlag();
		assertFalse(resultFalseFlag);
	}
	public void function getSlatwallAuthenticationExistsFlag_NullActiveFlag_Test() {
		//Under condition that if the first logical connectives returns true
		//testing when activeFlag is null
		var accountData3 = {
			accountID = "",
			firstName = "Hola"
		};
		var mockAccount3 = createPersistedTestEntity('Account', accountData3);
		var authzData3 = {
			accountAuthenticationID = "",
			password = "12345",
			account = {
				accountID = mockAccount3.getAccountID()
			}
		};
		var mockAccountAuthentications3 = createPersistedTestEntity('AccountAuthentication', authzData3);
		mockAccountAuthentications3.setActiveFlag(javaCast("null",""));		
		try{
			isNull(mockAccountAuthentications3.getActiveFlag());			
		} catch (any e) {
			throw ("The null activeFlag is undefined in this boolearn type");
		}
		var resultNullFlag = mockAccount3.getSlatwallAuthenticationExistsFlag();
		assertFalse(resultNullFlag);
		
	}
	
	
	public void function getActiveSubscriptionUsageBenefitsSmartList_endDateTime_Test() {
		var accountData1 = {
			accountID = "",
			firstName = "subtion"
		};
		var mockAccount1 = createPersistedTestEntity('Account', accountData1);
		
		var subscriptionUsageData = {
			subscriptionUsageID = "",
			expirationDate = dateAdd('d', 3, now()),
			account = {
				accountID = mockAccount1.getAccountID()
			}
		};
		var mockSubscriptionUsage1 = createPersistedTestEntity('SubscriptionUsage', subscriptionUsageData);
		
		var subscriptionUsageBenefitData = {
			subscriptionUsageBenefitID = "",
			subscriptionUsage = {
				subscriptionUsageID = mockSubscriptionUsage1.getSubscriptionUsageID()
			}
		};
		var mockSubscriptionUsageBenefit1 = createPersistedTestEntity('SubscriptionUsageBenefit', subscriptionUsageBenefitData);
		var subscriptionUsageBenefitData2 = {
			subscriptionUsageBenefitID = "",
			subscriptionUsage = {
				subscriptionUsageID = mockSubscriptionUsage1.getSubscriptionUsageID()
			}
		};
		var mockSubscriptionUsageBenefit2 = createPersistedTestEntity('SubscriptionUsageBenefit', subscriptionUsageBenefitData2);
		var subscriptionUsageBenefitData3 = {
			subscriptionUsageBenefitID = "",
			subscriptionUsage = {
				subscriptionUsageID = mockSubscriptionUsage1.getSubscriptionUsageID()
			}
		};
		var mockSubscriptionUsageBenefit3 = createPersistedTestEntity('SubscriptionUsageBenefit', subscriptionUsageBenefitData3);
		
		var subsUsageBenefitAccountData = {//endDateTime is null
			subsUsageBenefitAccountID = "",
			account = {
				accountID = mockAccount1.getAccountID()
			},
			subscriptionUsageBenefit = {
				subscriptionUsageBenefitID = mockSubscriptionUsageBenefit1.getSubscriptionUsageBenefitID()
			}
		};
		var mockSubsUsageBenefitAccount1 = createPersistedTestEntity('SubscriptionUsageBenefitAccount', subsUsageBenefitAccountData);
		var subsUsageBenefitAccountData2 = {//endDateTime is now + 2days
			subsUsageBenefitAccountID = "",
			endDateTime = dateAdd('d', 2, now()),
			account = {
				accountID = mockAccount1.getAccountID()
			},
			subscriptionUsageBenefit = {
				subscriptionUsageBenefitID = mockSubscriptionUsageBenefit2.getSubscriptionUsageBenefitID()
			}
		};
		var mockSubsUsageBenefitAccount2 = createPersistedTestEntity('SubscriptionUsageBenefitAccount', subsUsageBenefitAccountData2);
		var subsUsageBenefitAccountData3 = {//endDateTime is now - 2days
			subsUsageBenefitAccountID = "",
			endDateTime = dateAdd('d', -2, now()),
			account = {
				accountID = mockAccount1.getAccountID()
			},
			subscriptionUsageBenefit = {
				subscriptionUsageBenefitID = mockSubscriptionUsageBenefit3.getSubscriptionUsageBenefitID()
			}
		};
		var mockSubsUsageBenefitAccount3 = createPersistedTestEntity('SubscriptionUsageBenefitAccount', subsUsageBenefitAccountData3);
		
		var result = mockAccount1.getActiveSubscriptionUsageBenefitsSmartList().getRecords();
		//testing if the whereCondition of endDate time works
		assertEquals(2, arrayLen(result));
		var subscriptionUsageBenefitIDList = "";
		subscriptionUsageBenefitIDList = listAppend(subscriptionUsageBenefitIDList,"#mockSubscriptionUsageBenefit1.getsubscriptionUsageBenefitID()#");
		subscriptionUsageBenefitIDList = listAppend(subscriptionUsageBenefitIDList,"#mockSubscriptionUsageBenefit2.getsubscriptionUsageBenefitID()#");
		assertTrue(listFind(subscriptionUsageBenefitIDList, "#result[1].getsubscriptionUsageBenefitID()#") > 0);
	}
	
	public void function getActiveSubscriptionUsageBenefitsSmartList_rangeOfExpirationDate_AccountFilter_Test() {
		//Mocking Data: mockAccount1 -> mockSubscriptionUsage1 (expireDate now+3d)-> mockSubscriptionUsageBenefit1 -> mockSubsUsageBenefitAccount1
		//Mocking Data: mockAccount1 -> mockSubscriptionUsage2 (expireDate now-3d)-> mockSubscriptionUsageBenefit2 -> mockSubsUsageBenefitAccount2
		var accountData1 = {
			accountID = "",
			firstName = "subtion"
		};
		var mockAccount1 = createPersistedTestEntity('Account', accountData1);
		
		var subscriptionUsageData = {
			subscriptionUsageID = "",
			expirationDate = dateAdd('d', 3, now()),
			account = {
				accountID = mockAccount1.getAccountID()
			}
		};
		var mockSubscriptionUsage1 = createPersistedTestEntity('SubscriptionUsage', subscriptionUsageData);
		var subscriptionUsageData2 = {
			subscriptionUsageID = "",
			expirationDate = dateAdd('d', -3, now()),
			account = {
				accountID = mockAccount1.getAccountID()
			}
		};
		var mockSubscriptionUsage2 = createPersistedTestEntity('SubscriptionUsage', subscriptionUsageData2);
		
		var subscriptionUsageBenefitData = {
			subscriptionUsageBenefitID = "",
			subscriptionUsage = {
				subscriptionUsageID = mockSubscriptionUsage1.getSubscriptionUsageID()
			}
		};
		var mockSubscriptionUsageBenefit1 = createPersistedTestEntity('SubscriptionUsageBenefit', subscriptionUsageBenefitData);
		var subscriptionUsageBenefitData2 = {
			subscriptionUsageBenefitID = "",
			subscriptionUsage = {
				subscriptionUsageID = mockSubscriptionUsage2.getSubscriptionUsageID()
			}
		};
		var mockSubscriptionUsageBenefit2 = createPersistedTestEntity('SubscriptionUsageBenefit', subscriptionUsageBenefitData2);
		
		var subsUsageBenefitAccountData = {
			subsUsageBenefitAccountID = "",
			account = {
				accountID = mockAccount1.getAccountID()
			},
			subscriptionUsageBenefit = {
				subscriptionUsageBenefitID = mockSubscriptionUsageBenefit1.getSubscriptionUsageBenefitID()
			}
		};
		var mockSubsUsageBenefitAccount1 = createPersistedTestEntity('SubscriptionUsageBenefitAccount', subsUsageBenefitAccountData);
		var subsUsageBenefitAccountData2 = {
			subsUsageBenefitAccountID = "",
			account = {
				accountID = mockAccount1.getAccountID()
			},
			subscriptionUsageBenefit = {
				subscriptionUsageBenefitID = mockSubscriptionUsageBenefit2.getSubscriptionUsageBenefitID()
			}
		};
		var mockSubsUsageBenefitAccount2 = createPersistedTestEntity('SubscriptionUsageBenefitAccount', subsUsageBenefitAccountData2);
		
		var result = mockAccount1.getActiveSubscriptionUsageBenefitsSmartList().getRecords();		
		//testing range of ExpireDate
		assertEquals(1, arrayLen(result));
		//testing if the filter of AccountID works
		assertEquals(mockAccount1.getAccountID(), result[1].getSubscriptionUsage().getAccount().getAccountID());
	}


	public void function getTermAccountBalance_UnreceivedAndUnassigned_Test() {
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
			},
			accountPaymentType = {
					typeID="444df32dd2b0583d59a19f1b77869025" //aptCharge
			}
		};
		var accountPayment1 = createPersistedTestEntity("AccountPayment", accountPaymentData);
		//will not factor in without a received amount as it isn't a term payment
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

		assertEquals(2300, mockAccount1.getTermAccountBalance());
	}
	
	public void function getTermAccountBalance_UnreceivedOpenOrderPayment_Test() {
		//testing only the first loop been reached
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
		
		var paymentTransactionsData = {
			paymentTransactionID = "",
			amountReceived = 800,
			amountCredited = 100,
			amountAuthorized = 1000,
			orderPayment = {
				orderPaymentID = orderPayment1.getOrderPaymentID()
			}
		};
		var paymentTransaction1 = createPersistedTestEntity("PaymentTransaction", paymentTransactionsData);	

		assertEquals(1500, mockAccount1.getTermAccountBalance());
	}
	
	public void function getTermAccountBalance_UnassignedPayment_Test() {
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
		
		var accountPaymentData = {
			accountPaymentID = "",
			account = {
				accountID = mockAccount1.getAccountID()
			},
			accountPaymentType = {
					typeID="444df32dd2b0583d59a19f1b77869025" //aptCharge
			}
		};
		var accountPayment1 = createPersistedTestEntity("AccountPayment", accountPaymentData);
		//won't factor in as it isn't a term payment and therefore requires a recieved amount
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

		assertEquals(0, mockAccount1.getTermAccountBalance());
	}
	
	
	public void function getUnenrolledAccountLoyaltyOptionsTest() {
		//mocking: 							<- mockAccountLoyalty1ShouldReturn -> mockLoyalty1Active (activeFlag 1)
		//mocking: mockAccount1RunFunction  <- mockAccountLoyalty2TestAccount  -> mockLoyalty3Active (activeFlag 1)
		//mocking:							<- mockAccountLoyalty3TestFlag     -> mockLoyalty2Inactive (activeFlag 0)
		var accountData1 = {
			accountID = "",
			firstName = "Loyalty1Test"
		};
		var mockAccount1RunFunction = createPersistedTestEntity('Account', accountData1);
		
		var loyaltyData1 = {
			loyaltyID = "",
			loyaltyName = "Loyalty1Active",
			activeFlag = 1
		};
		var mockLoyalty1Active = createPersistedTestEntity('Loyalty', loyaltyData1);
		
		var loyaltyData2 = {
			loyaltyID = "",
			loyaltyName = "Loyalty2Inactive",
			activeFlag = 0
		};
		var mockLoyalty2Inactive = createPersistedTestEntity('Loyalty', loyaltyData2);
		
		var loyaltyData3 = {
			loyaltyID = "",
			loyaltyName = "Loyalty3active",
			activeFlag = 1
		};
		var mockLoyalty3Active = createPersistedTestEntity('Loyalty', loyaltyData3);
		
				
		var accountLoyaltyData1 = {
			accountLoyaltyID = "",
			loyalty = {
				loyaltyID = mockLoyalty1Active.getLoyaltyID()
			}
		};
		var mockAccountLoyalty1ShouldReturn = createPersistedTestEntity("AccountLoyalty", accountLoyaltyData1);
		
		var accountLoyaltyData2 = { 
			accountLoyaltyID = "",
			account = {
				accountID = mockAccount1RunFunction.getAccountID()
			},
			loyalty = {
				loyaltyID = mockLoyalty3Active.getLoyaltyID()
			}
		};
		var mockAccountLoyalty2TestAccount = createPersistedTestEntity("AccountLoyalty", accountLoyaltyData2);
		var accountLoyaltyData3 = {
			accountLoyaltyID = "",
			loyalty = {
				loyaltyID = mockLoyalty2Inactive.getLoyaltyID()
			}
		};
		var mockAccountLoyalty3TestFlag = createPersistedTestEntity("AccountLoyalty", accountLoyaltyData3);
		
		var result = mockAccount1RunFunction.getUnenrolledAccountLoyaltyOptions();
		assertEquals(mockLoyalty1Active.getLoyaltyID(), result[arrayLen(result)].value);

	}
	
	public void function getTermAccountAvailableCreditTest() {
		//general testing of negative credit limit
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
			amount = 300,
			orderPaymentType = "444df2f0fed139ff94191de8fcd1f61b", //optCharge
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
			},
			accountPaymentType={
				//systemCode="aptCharge"
			 	typeID="444df32dd2b0583d59a19f1b77869025"
			}
		};
		var accountPayment1 = createPersistedTestEntity("AccountPayment", accountPaymentData);
		//will not factor this in because it is not term and therefore needs a recieved amount
		var accountPaymentAppliedData = {
			accountPaymentAppliedID = "",
			amount = 50.00,
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
			settingValue = -1000
		};
		var settingEntity = createPersistedTestEntity('Setting',settingData);
		assertEquals(-1300, mockAccount1.getTermAccountAvailableCredit());
	}
	
	public void function getGuestAccountFlagTest() {
		//Mock Data: mockAccount1 -> mockAccountAuthentications1, mockAccountAuthentications2  Should return false
		//Mock Data: mockAccount2 -> No Account Authentication                                 Should return true
		var accountData1 = {
			accountID = "",
			firstName = "Hola"
		};
		var mockAccount1 = createPersistedTestEntity('Account', accountData1);
		var accountData2 = {
			accountID = "",
			firstName = "Hola"
		};
		var mockAccount2 = createPersistedTestEntity('Account', accountData2);
		
		var authzData1 = {
			accountAuthenticationID = "",
			account = {
				accountID = mockAccount1.getAccountID()
			}
		};
		var mockAccountAuthentications1 = createPersistedTestEntity('AccountAuthentication', authzData1);
		var authzData2 = {
			accountAuthenticationID = "",
			account = {
				accountID = mockAccount1.getAccountID()
			}
		};
		var mockAccountAuthentications2 = createPersistedTestEntity('AccountAuthentication', authzData2);

		assertFalse(mockAccount1.getGuestAccountFlag());	
		assertTrue(mockAccount2.getGuestAccountFlag());
	}

	public void function getActiveAccountAuthentications_ExistedAuthz_Test() {
		//When authz existed, the IF statement of Logical Operators will be TRUE if any of the four is true
		var accountData = {
			accountID = "",
			firstName = "mockActiveName"
		};
		var mockAccount = createPersistedTestEntity('Account', accountData);
		
		//If password is empty, isNull(authentication.getPassword()) is TRUE, should be added in array
		var accountAuthenticationsData1 = {
			accountAuthenticationID = "",
			activeFlag = FALSE,
			authenticationDescription = "mockAccountAuthentications1",
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		var mockAccountAuthentications1 = createPersistedTestEntity('AccountAuthentication', accountAuthenticationsData1);
		
		//If activeFlag is true, authentication.getActiveFlag() == TRUE is TRUE, should be added in array
		var accountAuthenticationsData2 = {
			accountAuthenticationID = "",
			authenticationDescription = "mockAccountAuthentications2",
			password = "23",
			activeFlag = TRUE,
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		var mockAccountAuthentications2 = createPersistedTestEntity('AccountAuthentication', accountAuthenticationsData2);
		
		//If integration existed, !isNull(authentication.getIntegration()) is TRUE, should be added in array
		var integrationData = {
			integrationID="4028288f549c11ac01549c1bb5d3000a"
		};
		var mockIntegration = createPersistedTestEntity('Integration', integrationData);
		
		var accountAuthenticationsData3 = {
			accountAuthenticationID = "",
			authenticationDescription = "mockAccountAuthentications3",
			password = "45",
			integration={
				integrationID = mockIntegration.getIntegrationID()
			},
			activeFlag = FALSE,
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		var mockAccountAuthentications3 = createPersistedTestEntity('AccountAuthentication', accountAuthenticationsData3);
		
		//If activeFlag is NULL, isNull(authentication.getActiveFlag()) is true, should be added in array
		var accountAuthenticationsData4 = {
			accountAuthenticationID = "",
			authenticationDescription = "mockAccountAuthentications4",
			password = "1234",
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		var mockAccountAuthentications4 = createPersistedTestEntity('AccountAuthentication', accountAuthenticationsData4);
		
		//If all the if statement fails, should not be added in array
		var accountAuthenticationsData5 = {
			accountAuthenticationID = "",
			authenticationDescription = "mockAccountAuthentications5",
			activeFlag = FALSE,
			password = "35",
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		var mockAccountAuthentications5 = createPersistedTestEntity('AccountAuthentication', accountAuthenticationsData5);
		
		var result = mockAccount.getActiveAccountAuthentications();
		assertEquals(4, arrayLen(result));
		var aaaListForResult = "";
		aaaListForResult = listAppend(aaaListForResult, "#mockAccountAuthentications1.getAccountAuthenticationID()#");
		aaaListForResult = listAppend(aaaListForResult, "#mockAccountAuthentications2.getAccountAuthenticationID()#");
		aaaListForResult = listAppend(aaaListForResult, "#mockAccountAuthentications3.getAccountAuthenticationID()#");
		aaaListForResult = listAppend(aaaListForResult, "#mockAccountAuthentications4.getAccountAuthenticationID()#");
		assertTrue(ListFind(aaaListForResult, result[1].getAccountAuthenticationID()) > 0);
		assertTrue(ListFind(aaaListForResult, result[2].getAccountAuthenticationID()) > 0);
		assertTrue(ListFind(aaaListForResult, result[3].getAccountAuthenticationID()) > 0);
		assertTrue(ListFind(aaaListForResult, result[4].getAccountAuthenticationID()) > 0);
	}
	
	public void function getActiveAccountAuthentications_NoAuthz_Test() {
		//Testing if Authz does not existed, should return array length 0
		var accountData0 = {
			accountID = "",
			firstName = "mockActiveName"
		};
		var mockAccount0 = createPersistedTestEntity('Account', accountData0);
		var result0 = mockAccount0.getActiveAccountAuthentications();
		assertEquals(0, arrayLen(result0));	
	}

	public void function getSaveablePaymentMethodsSmartList_filterOnTwoFlags_Test() {
		var accountData = {
			accountID = "",
			firstName = "saveableTest"
		};
		var mockAccount = createPersistedTestEntity('Account', accountData);

		var orderData1 = {
			orderID = "",
			orderNumber = "orderNumber00001",
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		var order1 = createPersistedTestEntity("Order", orderData1);
		
		var paymentMethodData1 = {//PaymentMethod1 everything meet filters, should be added
			paymentMethodID="",
			activeFlag = 1,
			allowSaveFlag = 1,
			paymentMethodType = 'termPayment'
		};
		var mockpaymentMethod1 = createPersistedTestEntity('paymentMethod',paymentMethodData1);
		var paymentMethodData2 = {//paymentMethod2 activeFlag is incorrect
			paymentMethodID="",
			activeFlag = 1,
			allowSaveFlag = 0,
			paymentMethodType = 'giftCard'
		};
		var mockpaymentMethod2 = createPersistedTestEntity('paymentMethod',paymentMethodData2);
		var paymentMethodData3 = {//paymentMethod3 allowSaveFlag is incorrect
			paymentMethodID="",
			activeFlag = 0,
			allowSaveFlag = 1,
			paymentMethodType = 'external'
		};
		var mockpaymentMethod3 = createPersistedTestEntity('paymentMethod',paymentMethodData3);
		var paymentMethodData4 = {//paymentMethod4 paymentMethodtype is incorrect
			paymentMethodID="",
			activeFlag = 1,
			allowSaveFlag = 1,
			paymentMethodType = 'cash'
		};
		var mockpaymentMethod4 = createPersistedTestEntity('paymentMethod',paymentMethodData4);
		
		//create settingValue of all the mockPaymentMethods
		var settingData = {
			settingID = "",
			settingName = "accountEligiblePaymentMethods",
			settingValue = "#mockpaymentMethod1.getPaymentMethodID()#, #mockpaymentMethod2.getPaymentMethodID()#, 
			                #mockpaymentMethod3.getPaymentMethodID()#, #mockpaymentMethod4.getPaymentMethodID()#"
		};
		var settingEntity = createPersistedTestEntity('Setting',settingData);
		
		var orderPaymentData1 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = mockpaymentMethod1.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}
		};
		var orderPayment1 = createPersistedTestEntity('OrderPayment', orderPaymentData1);
		var orderPaymentData2 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = mockpaymentMethod2.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}
		};
		var orderPayment2 = createPersistedTestEntity('OrderPayment', orderPaymentData2);
		var orderPaymentData3 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = mockpaymentMethod3.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}
		};
		var orderPayment3 = createPersistedTestEntity('OrderPayment', orderPaymentData3);
		var orderPaymentData4 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = mockpaymentMethod4.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}
		};
		var orderPayment4 = createPersistedTestEntity('OrderPayment', orderPaymentData4);
		var result = mockAccount.getSaveablePaymentMethodsSmartList().getRecords(refresh = true);
		assertEquals(1, arrayLen(result));
		assertEquals(mockpaymentMethod1.getPaymentMethodID(), result[1].getPaymentMethodID());		
	}
	
	public void function getSaveablePaymentMethodsSmartList_OverrideSetting_Test() {
		var accountData = {
			accountID = "",
			firstName = "saveableTest"
		};
		var mockAccount = createPersistedTestEntity('Account', accountData);

		var orderData1 = {
			orderID = "",
			orderNumber = "orderNumber00001",
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		var order1 = createPersistedTestEntity("Order", orderData1);
		
		var paymentMethodData1 = {//PaymentMethod1 passes the filter on Setting, should be added in SmartList
			paymentMethodID="",
			activeFlag = 1,
			allowSaveFlag = 1,
			paymentMethodType = 'termPayment'
		};
		var mockpaymentMethod1 = createPersistedTestEntity('paymentMethod',paymentMethodData1);
		var paymentMethodData2 = {//paymentMethod2 dropped off in smartlist by the filter on Setting
			paymentMethodID="",
			activeFlag = 1,
			allowSaveFlag = 1,
			paymentMethodType = 'giftCard'
		};
		var mockpaymentMethod2 = createPersistedTestEntity('paymentMethod',paymentMethodData2);
		
		var paymentMethodData3 = {//paymentMethod3 only mocked for the settingValue
			paymentMethodID=""
		};
		var mockpaymentMethod3 = createPersistedTestEntity('paymentMethod',paymentMethodData3);
		
		//create setting of mockpaymentMethod1 & mockpaymentMethod3
		var settingData = {
			settingID = "",
			settingName = "accountEligiblePaymentMethods",
			settingValue = "#mockpaymentMethod1.getPaymentMethodID()#, #mockpaymentMethod3.getPaymentMethodID()#"
		};
		var settingEntity = createPersistedTestEntity('Setting',settingData);
		
		var orderPaymentData1 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = mockpaymentMethod1.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}
		};
		var orderPayment1 = createPersistedTestEntity('OrderPayment', orderPaymentData1);
		var orderPaymentData2 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = mockpaymentMethod2.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}
		};
		var orderPayment2 = createPersistedTestEntity('OrderPayment', orderPaymentData2);
		var orderPaymentData3 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = mockpaymentMethod3.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}
		};
		var orderPayment3 = createPersistedTestEntity('OrderPayment', orderPaymentData3);

		var result = mockAccount.getSaveablePaymentMethodsSmartList().getRecords(refresh = true);
		assertEquals(1, arrayLen(result));
		assertEquals(mockpaymentMethod1.getPaymentMethodID(), result[1].getPaymentMethodID());		
	}
	
	public void function getSaveablePaymentMethodsSmartList_NoneSetting_Test() {
		var accountData = {
			accountID = "",
			firstName = "saveableTest"
		};
		var mockAccount = createPersistedTestEntity('Account', accountData);

		var orderData1 = {
			orderID = "",
			orderNumber = "orderNumber00001",
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		var order1 = createPersistedTestEntity("Order", orderData1);
		
		var paymentMethodData1 = {//PaymentMethod1 meet all filter requirements except the setting
			paymentMethodID="",
			activeFlag = 1,
			allowSaveFlag = 1,
			paymentMethodType = 'termPayment'
		};
		var mockpaymentMethod1 = createPersistedTestEntity('paymentMethod',paymentMethodData1);
		
		//create setting that length is 0
		var settingData = {
			settingID = "",
			settingName = "accountEligiblePaymentMethods",
			settingValue = ""
		};
		var settingEntity = createPersistedTestEntity('Setting',settingData);
		
		var orderPaymentData1 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = mockpaymentMethod1.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}
		};
		var orderPayment1 = createPersistedTestEntity('OrderPayment', orderPaymentData1);
		
		//MockPaymentMethod1 should be added in as setting filter is none there
		var result = mockAccount.getSaveablePaymentMethodsSmartList().getRecords(refresh = true);
		assertEquals(1, arrayLen(result));
		assertEquals(mockpaymentMethod1.getPaymentMethodID(), result[1].getPaymentMethodID());		
	}
	

	public void function getPaymentMethodOptionsSmartListTest() {
		var accountData1 = {
			accountID = "",
			firstName = "testPaymentMethodType",
			lastName = "pmLastName"
		};
		var mockAccountPMOSL = createPersistedTestEntity("Account", accountData1);
		var pmoSLBeforeMock = mockAccountPMOSL.getPaymentMethodOptionsSmartList().getRecords();
		var lenBeforeMock = arrayLen(pmoSLBeforeMock );

		var orderData1 = {
			orderID = "",
			orderNumber = "orderNumber00001",
			account = {
				accountID = mockAccountPMOSL.getAccountID()
			}
		};
		var order1 = createPersistedTestEntity("Order", orderData1);
		
		var paymentMethodData1 = {//PaymentMethod1 true ActiveFlag, wrong Type
			paymentMethodID="",
			activeFlag = 1,
			paymentMethodType = 'termPaymen'
		};
		var paymentMethod1 = createPersistedTestEntity('paymentMethod',paymentMethodData1);
		var paymentMethodData2 = {//paymentMethod2 true ActiveFlag, correct Type
			paymentMethodID="",
			activeFlag = 1,
			paymentMethodType = 'giftCard'
		};
		var paymentMethod2 = createPersistedTestEntity('paymentMethod',paymentMethodData2);
		var paymentMethodData3 = {//paymentMethod3 false ActiveFlag, correct Type
			paymentMethodID="",
			activeFlag = 0,
			paymentMethodType = 'cash'
		};
		var paymentMethod3 = createPersistedTestEntity('paymentMethod',paymentMethodData3);
		var paymentMethodData4 = {//paymentMethod4 default ActiveFlag, empty Type
			paymentMethodID=""
		};
		var paymentMethod4 = createPersistedTestEntity('paymentMethod',paymentMethodData4);
		
		var orderPaymentData1 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = paymentMethod2.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}
		};
		var orderPayment1 = createPersistedTestEntity('OrderPayment', orderPaymentData1);
		var orderPaymentData2 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = paymentMethod2.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}
		};
		var orderPayment2 = createPersistedTestEntity('OrderPayment', orderPaymentData2);
		var orderPaymentData3 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = paymentMethod3.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}
		};
		var orderPayment3 = createPersistedTestEntity('OrderPayment', orderPaymentData3);
		var orderPaymentData4 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = paymentMethod4.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}
		};
		var orderPayment4 = createPersistedTestEntity('OrderPayment', orderPaymentData4);
		//Only PaymentMethod2 should be added in the SL
		var pmoSL = mockAccountPMOSL.getPaymentMethodOptionsSmartList().getRecords(refresh = true);
		assertEquals(1, arrayLen(pmoSL) - lenBeforeMock);
	}
	
	

	public void function getPasswordResetIDTest() {
		//testing when authentication existed, the result is right
		var accountData = {
			accountID = "",
			firstName = "mockName"
		};
		var mockAccount = createPersistedTestEntity('Account', accountData);
		var accountAuthentications1Data = {
			accountAuthenticationID = "",
			expirationDateTime = DateAdd("d", 2, now()),
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		var mockAccountAuthentications1 = createPersistedTestEntity('AccountAuthentication', accountAuthentications1Data);

		var result = mockAccount.getPasswordResetID();
		var expectedResult = lcase(mockAccount.getAccountID()&hash(mockaccountAuthentications1.getAccountAuthenticationID() & mockAccount.getAccountID()));
		assertEquals(result, expectedResult);
		//testing two authentications in one account but choose the top authz in DESC order to map the result
		var accountData2 = {
			accountID = "",
			firstName = "mockName"
		};
		var mockAccount2 = createPersistedTestEntity('Account', accountData2);
		var accountAuthentications2Data = {
			accountAuthenticationID = "",
			expirationDateTime = DateAdd("d", 1, now()),
			account = {
				accountID = mockAccount2.getAccountID()
			}
		};
		var mockAccountAuthentications2 = createPersistedTestEntity('AccountAuthentication', accountAuthentications2Data);
		var accountAuthentications3Data = {
			accountAuthenticationID = "",
			expirationDateTime = DateAdd("d", 3, now()),
			account = {
				accountID = mockAccount2.getAccountID()
			}
		};
		var mockAccountAuthentications3 = createPersistedTestEntity('AccountAuthentication', accountAuthentications3Data);
		var resultTwoAuthz = mockAccount2.getPasswordResetID();
		var expectedResultTwoAuthz = lcase(mockAccount2.getAccountID()&hash(mockaccountAuthentications3.getAccountAuthenticationID() & mockAccount2.getAccountID()));
		assertEquals(resultTwoAuthz, expectedResultTwoAuthz);
		//testing when authentication does not exist, the authentication will be created after running this function
		var accountData3 = {
			accountID = "",
			firstName = "Helo"
		};
		var mockAccount3 = createPersistedTestEntity('Account', accountData3);
		var resultNoAuthz = mockAccount3.getPasswordResetID();
		assertEquals(1, arrayLen(mockAccount3.getAccountAuthentications()));
		
	}
	
	public void function getTermOrderPaymentsByDueDateSmartList_filterInPaymentMethodType_Test() {
		//Mocking Data: mockAccount1 ->Order1 -> OrderPayment1 -> PaymentMethod1 termPayment
		//Mocking Data: mockAccount1 ->Order1 -> OrderPayment2 -> PaymentMethod2 giftCard
		//Mocking Data: mockAccount1 ->Order2 -> OrderPayment3 -> PaymentMethod1 termPayment
		//Mocking Data: mockAccount1 ->Order3 -> OrderPayment4 -> PaymentMethod2 giftCard
		var accountData1 = {
			accountID = "",
			firstName = "testPaymentMethodType"
			
		};
		var mockAccount1 = createPersistedTestEntity("Account", accountData1);

		var order1Data = {
			orderID = "",
			orderNumber = "orderNumber001",
			orderStatusType = {
				typeID = "444df2b6b8b5d1ccfc14a4ab38aa0a4c"
			},
			
			account = {
				accountID = mockAccount1.getAccountID()
			}
		};
		var order1 = createPersistedTestEntity('Order', order1Data);
		var order2Data = {
			orderID = "",
			orderNumber = "orderNumber002",
			orderStatusType = {
				typeID = "444df2b6b8b5d1ccfc14a4ab38aa0a4c"
			},
			
			account = {
				accountID = mockAccount1.getAccountID()
			}
		};
		var order2 = createPersistedTestEntity('Order', order2Data);
		var order3Data = {
			orderID = "",
			orderNumber = "orderNumber003",
			orderStatusType = {
				typeID = "444df2b6b8b5d1ccfc14a4ab38aa0a4c"
			},
			
			account = {
				accountID = mockAccount1.getAccountID()
			}
		};
		var order3 = createPersistedTestEntity('Order', order3Data);
		
		
		var paymentMethodData1 = {
			paymentMethodID="",
			paymentMethodType = 'termPayment'
		};
		var paymentMethod1 = createPersistedTestEntity('paymentMethod',paymentMethodData1);
		var paymentMethodData2 = {
			paymentMethodID="",
			paymentMethodType = 'giftCard'
		};
		var paymentMethod2 = createPersistedTestEntity('paymentMethod',paymentMethodData2);
				
		var orderPaymentData1 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = paymentMethod1.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}			
		};
		var orderPayment1 = createPersistedTestEntity('OrderPayment', orderPaymentData1);
		var orderPaymentData2 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = paymentMethod2.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}			
		};
		var orderPayment2 = createPersistedTestEntity('OrderPayment', orderPaymentData2);
		var orderPaymentData3 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = paymentMethod1.getPaymentMethodID()
				},
				order = {
					orderID = order2.getOrderID()
				}			
		};
		var orderPayment3 = createPersistedTestEntity('OrderPayment', orderPaymentData3);
		var orderPaymentData4 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = paymentMethod2.getPaymentMethodID()
				},
				order = {
					orderID = order3.getOrderID()
				}			
		};
		var orderPayment4 = createPersistedTestEntity('OrderPayment', orderPaymentData4);

		//testing if PaymentMethod filter works in the SmartList
		var mockSM1 = mockAccount1.getTermOrderPaymentsByDueDateSmartList().getRecords();
		assertEquals(arrayLen(mockSM1), 2);
		assertEquals(paymentMethod1.getPaymentMethodID(), mockSM1[1].getPaymentMethodID());
		assertEquals(paymentMethod1.getPaymentMethodID(), mockSM1[2].getPaymentMethodID());
	}
	

	public void function getTermOrderPaymentsByDueDateSmartList_filterInOrderStatusType_filterAccountID_Test() {
		//Mocking Data: mockAccount1 ->Order1  OrderstatusType = onHold
		//Mocking Data: mockAccount1 ->Order2  OrderStatusType = canceled
		//Mocking Data: mockAccount1 ->Order3  OrderStatusType = (empty)
		var accountData1 = {
			accountID = "",
			firstName = "hellooo"
		};
		var mockAccount1 = createPersistedTestEntity("Account", accountData1);

		var order1Data = {
			orderID = "",
			orderNumber = "orderNumber001",
			orderStatusType = {
				typeID = "444df2b7d7dcce8a3aa485f80264ac3a" //onHold
			},
			
			account = {
				accountID = mockAccount1.getAccountID()
			}
		};
		var order1 = createPersistedTestEntity('Order', order1Data);
		var order2Data = {
			orderID = "",
			orderNumber = "orderNumber002",
			orderStatusType = {
				typeID = "444df2b90f62f72711eb5b3c90848e7e" //canceled
			},
			
			account = {
				accountID = mockAccount1.getAccountID()
			}
		};
		var order2 = createPersistedTestEntity('Order', order2Data);
		var order3Data = {
			orderID = "",
			orderNumber = "orderNumber003",
			account = {
				accountID = mockAccount1.getAccountID()
			}
		};
		var order3 = createPersistedTestEntity('Order', order3Data);
		
		var paymentMethodData = {
			paymentMethodID="",
			paymentMethodType = 'termPayment'
		};
		var paymentMethod = createPersistedTestEntity('paymentMethod',paymentMethodData);
				
		var orderPaymentData1 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = paymentMethod.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}			
		};
		var orderPayment1 = createPersistedTestEntity('OrderPayment', orderPaymentData1);
		var orderPaymentData2 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = paymentMethod.getPaymentMethodID()
				},
				order = {
					orderID = order2.getOrderID()
				}			
		};
		var orderPayment2 = createPersistedTestEntity('OrderPayment', orderPaymentData2);
		var orderPaymentData3 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = paymentMethod.getPaymentMethodID()
				},
				order = {
					orderID = order3.getOrderID()
				}			
		};
		var orderPayment3 = createPersistedTestEntity('OrderPayment', orderPaymentData3);
		
		var mockSM1 = mockAccount1.getTermOrderPaymentsByDueDateSmartList().getRecords();
		//testing  filter in AccountID
		assertEquals(arrayLen(mockSM1), 1);
		assertEquals(mockSM1[1].getOrder().getAccount().getAccountID(), mockAccount1.getAccountID());
		//testing filter in OrderStatusPayment
		assertEquals(orderPayment1.getOrderPaymentID(), mockSM1[1].getOrderPaymentID());
		
	}
	
	
	public void function getTermOrderPaymentsByDueDateSmartList_orderByPaymentDueDate_Test() {
		//Mocking Data: mockAccount1 ->Order1 -> OrderPayment1 DueDate now() +5 days
		//Mocking Data: mockAccount1 ->Order1 -> OrderPayment2 DueDate now() +2 days
		//Mocking Data: mockAccount1 ->Order2 -> OrderPayment3 DueDate now() +3 days
		//Mocking Data: mockAccount1 ->Order3 -> OrderPayment4 DueDate now() -8 days
		var accountData = {
			accountID = "",
			firstName = "hellooo"	
		};
		var mockAccount = createPersistedTestEntity("Account", accountData);

		var order1Data = {
			orderID = "",
			orderNumber = "orderNumber001",
			orderStatusType = {
				typeID = "444df2b6b8b5d1ccfc14a4ab38aa0a4c" 
			},
			
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		var order1 = createPersistedTestEntity('Order', order1Data);
		var order2Data = {
			orderID = "",
			orderNumber = "orderNumber002",
			orderStatusType = {
				typeID = "444df2b6b8b5d1ccfc14a4ab38aa0a4c" 
			},
			
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		var order2 = createPersistedTestEntity('Order', order2Data);
		var order3Data = {
			orderID = "",
			orderNumber = "orderNumber003",
			orderStatusType = {
				typeID = "444df2b6b8b5d1ccfc14a4ab38aa0a4c" 
			},
			
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		var order3 = createPersistedTestEntity('Order', order3Data);
		
		var paymentMethodData = {
			paymentMethodID="",
			paymentMethodType = 'termPayment'
		};
		var paymentMethod = createPersistedTestEntity('paymentMethod',paymentMethodData);
				
		var orderPaymentData1 = {
				orderPaymentID = "",
				paymentDueDate = dateAdd('d', 5, now()),
				paymentMethod = {
					paymentMethodID = paymentMethod.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}			
		};
		var orderPayment1 = createPersistedTestEntity('OrderPayment', orderPaymentData1);
		var orderPaymentData2 = {
				orderPaymentID = "",
				paymentDueDate = dateAdd('d', 2, now()),
				paymentMethod = {
					paymentMethodID = paymentMethod.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}			
		};
		var orderPayment2 = createPersistedTestEntity('OrderPayment', orderPaymentData2);
		var orderPaymentData3 = {
				orderPaymentID = "",
				paymentDueDate = dateAdd('d', 3, now()),
				paymentMethod = {
					paymentMethodID = paymentMethod.getPaymentMethodID()
				},
				order = {
					orderID = order2.getOrderID()
				}			
		};
		var orderPayment3 = createPersistedTestEntity('OrderPayment', orderPaymentData3);
		var orderPaymentData4 = {
				orderPaymentID = "",
				paymentDueDate = dateAdd('d', -8, now()),
				paymentMethod = {
					paymentMethodID = paymentMethod.getPaymentMethodID()
				},
				order = {
					orderID = order3.getOrderID()
				}			
		};
		var orderPayment4 = createPersistedTestEntity('OrderPayment', orderPaymentData4);		
		var mockSM = mockAccount.getTermOrderPaymentsByDueDateSmartList().getRecords();
		assertEquals(orderPayment4.getOrderPaymentID(), mockSM[1].getOrderPaymentID());
		assertEquals(orderPayment2.getOrderPaymentID(), mockSM[2].getOrderPaymentID());
		assertEquals(orderPayment3.getOrderPaymentID(), mockSM[3].getOrderPaymentID());
		assertEquals(orderPayment1.getOrderPaymentID(), mockSM[4].getOrderPaymentID());
	}

//  ToDo: Cannot test, no SSH
//	public void function getGravatarURLTest() {
//		var accountData = {
//			accountID = "",
//			accountAuthentications = {
//				accountAuthenticationID = "",
//				expirationDateTime = DateAdd("d", 2, now()),
//				password = "123"
//			} 
//		};
//		var mockAccount = createTestEntity('Account', accountData);
//	}
		
	public void function getEligibleAccountPaymentMethodsSmartListTest() {
		var accountData1 = {
			accountID = "",
			firstName = "testPaymentMethodType",
			lastName = "pmLastName"
		};
		var mockAccountPMSL = createPersistedTestEntity("Account", accountData1);		
		
		var orderData1 = {
			orderID = "",
			orderNumber = "orderNumber00001",
			account = {
				accountID = mockAccountPMSL.getAccountID()
			}
		};
		var order1 = createPersistedTestEntity("Order", orderData1);
		
		var paymentMethodData1 = {//PaymentMethod1 true ActiveFlag, wrong Type
			paymentMethodID='',
			activeFlag = 1,
			paymentMethodType = 'termPayment'
		};
		var paymentMethod1 = createPersistedTestEntity('paymentMethod',paymentMethodData1);
		var paymentMethodData2 = {//paymentMethod2 true ActiveFlag, correct Type
			paymentMethodID="0",
			activeFlag = 1,
			paymentMethodType = 'external'
		};
		var paymentMethod2 = createPersistedTestEntity('paymentMethod',paymentMethodData2);
		var paymentMethodData3 = {//paymentMethod3 false ActiveFlag, correct Type
			paymentMethodID="",
			activeFlag = 0,
			paymentMethodType = 'check'
		};
		var paymentMethod3 = createPersistedTestEntity('paymentMethod',paymentMethodData3);
		var paymentMethodData4 = {//paymentMethod4 default ActiveFlag, empty Type
			paymentMethodID=""
		};
		var paymentMethod4 = createPersistedTestEntity('paymentMethod',paymentMethodData4);
		
		//create setting
		var settingData = {
			settingID="",
			settingName="accountEligiblePaymentMethods",
			settingValue = "#paymentMethod2.getPaymentMethodID()#, #paymentMethod3.getPaymentMethodID()#"
		};
		var settingEntity = createPersistedTestEntity('Setting',settingData);
		
		var orderPaymentData1 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = paymentMethod2.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}
		};
		var orderPayment1 = createPersistedTestEntity('OrderPayment', orderPaymentData1);
		var orderPaymentData2 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = paymentMethod2.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}
		};
		var orderPayment2 = createPersistedTestEntity('OrderPayment', orderPaymentData2);
		var orderPaymentData3 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = paymentMethod3.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}
		};
		var orderPayment3 = createPersistedTestEntity('OrderPayment', orderPaymentData3);
		var orderPaymentData4 = {
				orderPaymentID = "",
				paymentMethod = {
					paymentMethodID = paymentMethod4.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}
		};
		var orderPayment4 = createPersistedTestEntity('OrderPayment', orderPaymentData4);

		
		var pmAfterSL = mockAccountPMSL.getEligibleAccountPaymentMethodsSmartList().getRecords( refresh = true);
		//only paymentMethod2 should be filtered out
		assertEquals(paymentMethod2.getPaymentMethodID(), pmAfterSL[1].getPaymentMethodID());
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
		var accountData2 = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty"
		};
		var mockAccount2 = createTestEntity('Account', accountData2);
		assertTrue(mockAccount2.getPrimaryEmailAddress().getNewFlag());
		
		//testing empty PrimaryEmailAddress and existing accountEmailAddress
		var accountData3 = {
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
		var mockAccount3 = createPersistedTestEntity('Account', accountData3);
		assertEquals("firstaccountEamilAddress@hotmail.com", mockAccount3.getPrimaryEmailAddress().getEmailAddress());
		
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
		var accountData3 = {
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
		var mockAccount3 = createTestEntity('Account', accountData3);
		assertEquals("firstphoneNumber", mockAccount3.getPrimaryPhoneNumber().getPhoneNumber());
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
			accountID = "002",
			firstName = "Hello",
			lastName = "Kitty",
			accountPaymentMethods = [{
				accountPaymentMethodID = "0002",
				accountPaymentMethodName = "Kitty BOA card",
				nameOnCreditCard = "HelloKittyAccountPaymentInfo"
			}]
		};
		mockAccount = createTestEntity('Account', accountData);
		var resultNoPrimaryPaymentExistingPayment = mockAccount.getPrimaryPaymentMethod().getNameOnCreditCard();
		assertEquals(resultNoPrimaryPaymentExistingPayment, "HelloKittyAccountPaymentInfo");
		//testing empty PrimaryPaymentMethod
		accountData = {
			accountID = "001",
			firstName = "Hello",
			lastName = "Kitty"
		};
		mockAccount = createTestEntity('Account', accountData);
		var resultNonePrimaryPayment = mockAccount.getPrimaryPaymentMethod();
		assertTrue(resultNonePrimaryPayment.getNewFlag());
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
	
	// ================== END TESTING: Overridden Methods ========================
	
	// ============= START Testing: Overridden Smart List Getters ================
	public void function getAccountContentAccessesSmartListTest() {
		//testing the filter on AccountID
		var accountData = {
			accountID = ""
		};
		var mockAccount1 = createPersistedTestEntity('Account', accountData);
	
		var orderData = {
			orderID = ""
		};
		var mockOrder1 = createPersistedTestEntity('Order', orderData);
		
		var orderItemData = {
			orderItemID = "",
			order = {
				orderID = mockOrder1.getOrderID()
			}
		};
		var mockOrderItem1 = createPersistedTestEntity('OrderItem', orderItemData);
		mockOrderItem1.setOrder(mockOrder1);
		
		var contentData1 = {
			contentID = ""
		};
		var mockContent1 = createPersistedTestEntity('Content', contentData1);
		
		var accountContentAccessData = {
			accountContentAccessID = "",
			account = {
				accountID = mockAccount1.getAccountID()
			},
			orderItem = {
				orderItemID = mockOrderItem1.getOrderItemID()
			},
			accessContents=[
				{
					contentid=mockContent1.getContentID()
				}
			]
		};
		var accountContentAccess1 = createPersistedTestEntity('AccountContentAccess', accountContentAccessData);
		
		var result = mockAccount1.getAccountContentAccessesSmartList().getRecords(refresh = true);
		assertEquals(mockAccount1.getAccountID(), result[1].getAccount().getAccountID());
		
		
	}	
	// =============  END TESTING: Overridden Smart List Getters =================
}



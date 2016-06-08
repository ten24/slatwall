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
/*
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
*/
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
		var order4 = createPersistedTestEntity('Order', order4Data);
		var resultOrdersNotPlacedSM = mockAccount.getOrdersNotPlacedSmartList();
		assertEquals(arraylen(resultOrdersNotPlacedSM.getRecords()), 2);
		//testing the DESC order of modified date	??Yuqing only works when date changed, hours not been effected
		request.debug("Order 1 Time is: ");
		request.debug(order1.getModifiedDateTime());
		request.debug("Order 4 before Modified: ");
		request.debug(order4.getModifiedDateTime());
		order4.setModifiedDateTime(dateAdd('d', 3, now()));
		var resultChangedModifiedDate = mockAccount.getOrdersNotPlacedSmartList();//YUQING ？ not stable
		request.debug("Order 4 after Modified: ");
		request.debug(order4.getModifiedDateTime());
		assertEquals(resultChangedModifiedDate.getRecords()[1].getOrderNumber(), "orderNumber004");	
	}

	public void function getPasswordResetIDTest() {
		//testing when authentication existed
		var num = "1232123";
		var accountData = {
			accountID = "",
			firstName = "Helo",
			primaryEmailAddress = {
				accountEmailAddressID = "00010001",
				emailAddress = "testPasswordReset@hotmail.com"
			}
		};
		var mockAccount = createPersistedTestEntity('Account', accountData);
		var accountAuthentications1Data = {
			accountAuthenticationID = "",
			expirationDateTime = DateAdd("d", 2, now()),
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		var accountAuthentications2Data = {
			accountAuthenticationID = "",
			expirationDateTime = DateAdd("d", 4, now()),
			account = {
				accountID = mockAccount.getAccountID()
			}
		};
		var mockAccountAuthentications1 = createPersistedTestEntity('AccountAuthentication', accountAuthentications1Data);
		var mockAccountAuthentications2 = createPersistedTestEntity('AccountAuthentication', accountAuthentications2Data);
		var result = mockAccount.getPasswordResetID();
		request.debug(result);
//		request.debug(mockAccount.getAccountID());Yuqing
		request.debug(mockAccountAuthentications1.getAccountAuthenticationID());
//		assertEquals (result, "noIdea");
		//testing when authentication does not exist
		accountData = {
			accountID = "",
			firstName = "Helo",
			primaryEmailAddress = {
				accountEmailAddressID = "00010001",
				emailAddress = "testPasswordReset@hotmail.com"
			}
		};
		mockAccount = createPersistedTestEntity('Account', accountData);
		var result = mockAccount.getPasswordResetID();
		request.debug(result);
		assertEquals(result, "noIdeaWhat&Mean in Hash");
	}
	public void function getSlatwallAuthenticationExistsFlagTest() {
		//testing if no valid properties(Password,Integration,ActiveFlag) existed in authentication,then authentication does not exist
		var accountData1 = {
			accountID = "",
			firstName = "Hola"
		};
		var mockAccount1 = createPersistedTestEntity('Account', accountData1);
		var authzData1Normal = {
			accountAuthenticationID = "",
			account = {
				accountID = mockAccount1.getAccountID()
			}
		};
		var mockAccountAuthentications1 = createPersistedTestEntity('AccountAuthentication', authzData1Normal);		
		var resultNotValidAuthz = mockAccount1.getSlatwallAuthenticationExistsFlag();
		assertFalse(resultNotValidAuthz);
		//testing if valid authz property created, (Password), authz flag should be true
		var accountData2 = {
			accountID = "",
			firstName = "Hola"
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
		assertTrue(resultWithPassword);//yuqing
		//testing existed authentictions w/ Integration  YUQING
	}
	
	public void function getTermOrderPaymentsByDueDateSmartListTest() {
		//testing if AccountID filter works in the SmartList
		var accountData1 = {//create Account
			accountID = "",
			firstName = "hellooo"
			
		};
		var mockAccount1 = createPersistedTestEntity("Account", accountData1);

		var order1Data = {//create Order
			orderID = "",
			orderNumber = "orderNumber001",
			orderStatusType = {
				typeID = "444df2b6b8b5d1ccfc14a4ab38aa0a4c" //processing
			},
			
			account = {
				accountID = mockAccount1.getAccountID()
			}
		};
		var order1 = createPersistedTestEntity('Order', order1Data);	
		
		var paymentMethodData = {//create paymentMethod
			paymentMethodID="",
			paymentMethodType = 'termPayment'
		};
		var paymentMethod = createPersistedTestEntity('paymentMethod',paymentMethodData);
				
		var orderPaymentData = {//create OrderPayment
				orderPaymentID = "",
				paymentDueDate = dateAdd('d', 1, now()),
				paymentMethod = {
					paymentMethodID = paymentMethod.getPaymentMethodID()
				},
				order = {
					orderID = order1.getOrderID()
				}			
		};
		var orderPayment1 = createPersistedTestEntity('OrderPayment', orderPaymentData);
		
		request.debug(getMetaData(mockaccount1));
		
		var mockSM1 = mockAccount1.getTermOrderPaymentsByDueDateSmartList().getRecords();
		request.debug(arraylen(mockAccount1.getTermOrderPaymentsByDueDateSmartList().getRecords()));
		request.debug(mockSM1[1].getOrder().getOrderID());
		assertEquals(mockSM1[1].getOrder().getAccount().getAccountID(), mockAccount1.getAccountID());
		
		
		
		
		
		//Other test cases
		var order2Data = {
			orderID = "",
			orderNumber = "orderNumber002",
			orderOpenDateTime = dateAdd('d', 4, now()),
			orderStatusType = {
				typeID = "444df2b7d7dcce8a3aa485f80264ac3a"//onhold
			},
			account = {
				accountID = mockAccount1.getAccountID()
			}
		};
		var order3Data = {
			orderID = "",
			orderNumber = "orderNumber003",
			orderOpenDateTime = dateAdd('d', -2, now()),
			orderStatusType = {
				typeID = "444df2b90f62f72711eb5b3c90848e7e"//canceled
			},
			account = {
				accountID = mockAccount1.getAccountID()
			}
		};	
		var order4Data = {
			orderID = "",
			orderNumber = "orderNumber004",
			orderOpenDateTime = dateAdd('d', -2, now()),
			orderStatusType = {
				typeID = "444df2b5c8f9b37338229d4f7dd84ad1"//new
			},
			account = {
				accountID = mockAccount2.getAccountID()
			}
		};	
		
		var order2 = createPersistedTestEntity('Order', order2Data);
		var order3 = createPersistedTestEntity('Order', order3Data);
		var order4 = createPersistedTestEntity('Order', order4Data);
		
		//testing to get the correct number of records in SmartList
		var resultOrdersPlacedSM = mockAccount.getTermOrderPaymentsByDueDateSmartList().getRecords();
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
	
	public void function getActiveSubscriptionUsageBenefitsSmartListTest() {
		var accountData1 = {
			accountID = "",
			firstName = "subscription",
			subscriptionUsageBenefitAccounts = [{
				subsUsageBenefitAccountID = "",
				endDateTime = dateAdd('d', 3, now)
			}],
			subscriptionUsages = [{
				subscriptionUsageID = "",
				expirationDate = dateAdd('d', 1, now())
			}]
		};
		var mockAccount1 = createPersistedTestEntity('Account', accountData1);
		var authzData1Normal = {
			accountAuthenticationID = "",
			account = {
				accountID = mockAccount1.getAccountID()
			}
		};
		var mockAccountAuthentications1 = createPersistedTestEntity('AccountAuthentication', authzData1Normal);		
		var resultNotValidAuthz = mockAccount1.getSlatwallAuthenticationExistsFlag();
		assertFalse(resultNotValidAuthz);
	}
	
//	
//	public void function getActiveAccountAuthenticationsTest() {
//		
//	}
/*		
	//Cannot test, no SSH
	public void function getGravatarURLTest() {
		var accountData = {
			accountID = "",
			accountAuthentications = {
				accountAuthenticationID = "",
				expirationDateTime = DateAdd("d", 2, now()),
				password = "123"
			} 
		};
		var mockAccount = createTestEntity('Account', accountData);
		request.debug(mockAccount.getGravatarURL());
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
*/	
}



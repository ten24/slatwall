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
		variables.entity = request.slatwallScope.getService( variables.entityService ).newAccountPayment();
		
	}
	
	public void function getExpirationMonthOptions_returns_a_12_index_array() {
		assert(arrayLen(variables.entity.getExpirationMonthOptions()) eq 12);
	}
	
	public void function getExpirationYearOptions_returns_a_20_index_array() {
		assertEquals(arrayLen(variables.entity.getExpirationYearOptions()), 20);
	}
	
	public void function isValidTest(){
		var accountPaymentData={
			accountPaymentID=""
		};
		var accountPayment = createPersistedTestEntity('AccountPayment',accountPaymentData);
		accountPayment.validate('save');
		assert(accountPayment.hasErrors());		
	}
	
	public void function getAmountTest(){
		var accountPaymentData={
			accountPaymentID=""
		};
		var accountPayment = createPersistedTestEntity('AccountPayment',accountPaymentData);
		
		var AccountPaymentAppliedData = {
			accountPaymentAppliedID="",
			amount = 7.5323,
			accountPayment={
				accountPaymentID=accountPayment.getAccountPaymentID()
			}
		};
		var accountPaymentApplied = createTestEntity('AccountPaymentApplied',accountPaymentAppliedData);
		
		var AccountPaymentAppliedData2 = {
			accountPaymentAppliedID="",
			amount = 7.5643,
			accountPayment={
				accountPaymentID=accountPayment.getAccountPaymentID()
			}
		};
		var accountPaymentApplied2 = createTestEntity('AccountPaymentApplied',accountPaymentAppliedData2);
		
		assertEquals(15.09,accountPayment.getAmount());
	}
	
	public void function getAmountReceivedTest(){
		var accountPaymentData={
			accountPaymentID="",
			accountPaymentType={
				//charge
				typeID="444df32dd2b0583d59a19f1b77869025"
			}
		};
		var accountPayment = createPersistedTestEntity('AccountPayment',accountPaymentData);
		var PaymentTransactionData={
			PaymentTransactionID="",
			accountPayment={
				accountPaymentID=accountPayment.getAccountPaymentID()
				
			},
			amountReceived=7.345
		};
		var PaymentTransaction = createPersistedTestEntity('PaymentTransaction',PaymentTransactionData);
		
		var PaymentTransactionData2={
			PaymentTransactionID="",
			accountPayment={
				accountPaymentID=accountPayment.getAccountPaymentID()
				
			},
			amountReceived=1.2123
		};
		var PaymentTransaction2 = createPersistedTestEntity('PaymentTransaction',PaymentTransactionData2);
		
		assertEquals(8.55,accountPayment.getAmountReceived());
	}
	
	public void function getAmountCreditedTest(){
		var accountPaymentData={
			accountPaymentID="",
			accountPaymentType={
				//credit
				typeID="444df32e9b448ea196c18c66e1454c46"
			}
		};
		var accountPayment = createPersistedTestEntity('AccountPayment',accountPaymentData);
		var PaymentTransactionData={
			PaymentTransactionID="",
			accountPayment={
				accountPaymentID=accountPayment.getAccountPaymentID()
				
			},
			amountCredited=7.345
		};
		var PaymentTransaction = createPersistedTestEntity('PaymentTransaction',PaymentTransactionData);
		
		var PaymentTransactionData2={
			PaymentTransactionID="",
			accountPayment={
				accountPaymentID=accountPayment.getAccountPaymentID()
				
			},
			amountCredited=1.2123
		};
		var PaymentTransaction2 = createPersistedTestEntity('PaymentTransaction',PaymentTransactionData2);
		
		assertEquals(8.55,accountPayment.getAmountCredited());
	}
	
	public void function getAmountAuthorizedTest(){
		var accountPaymentData={
			accountPaymentID="",
			accountPaymentType={
				//charge
				typeID="444df32dd2b0583d59a19f1b77869025"
			}
		};
		var accountPayment = createPersistedTestEntity('AccountPayment',accountPaymentData);
		var PaymentTransactionData={
			PaymentTransactionID="",
			accountPayment={
				accountPaymentID=accountPayment.getAccountPaymentID()
				
			},
			amountAuthorized=7.345
		};
		var PaymentTransaction = createPersistedTestEntity('PaymentTransaction',PaymentTransactionData);
		
		var PaymentTransactionData2={
			PaymentTransactionID="",
			accountPayment={
				accountPaymentID=accountPayment.getAccountPaymentID()
				
			},
			amountAuthorized=1.2123
		};
		var PaymentTransaction2 = createPersistedTestEntity('PaymentTransaction',PaymentTransactionData2);
		
		assertEquals(8.55,accountPayment.getAmountAuthorized());
	}
	
//	public void function getAmountUnassignedTest(){
//		var accountPaymentData={
//			accountPaymentID="",
//			
//			
//			accountPaymentType={
//				//charge
//				typeID="444df32dd2b0583d59a19f1b77869025"
//			}
//		};
//		var accountPayment = createPersistedTestEntity('AccountPayment',accountPaymentData);
//		var AccountPaymentAppliedData = {
//			accountPaymentAppliedID="",
//			amount = 7.5323,
//			accountPayment={
//				accountPaymentID=accountPayment.getAccountPaymentID()
//			},
//			accountPaymentType={
//				//charge
//				typeID="444df32dd2b0583d59a19f1b77869025"
//			}
//		};
//		var accountPaymentApplied = createTestEntity('AccountPaymentApplied',accountPaymentAppliedData);
//		
//		var AccountPaymentAppliedData2 = {
//			accountPaymentAppliedID="",
//			amount = 7.5643,
//			accountPayment={
//				accountPaymentID=accountPayment.getAccountPaymentID()
//			},
//			accountPaymentType={
//				//charge
//				typeID="444df32dd2b0583d59a19f1b77869025"
//			}
//		};
//		var accountPaymentApplied2 = createTestEntity('AccountPaymentApplied',accountPaymentAppliedData2);
//		
//		var PaymentTransactionData={
//			PaymentTransactionID="",
//			accountPayment={
//				accountPaymentID=accountPayment.getAccountPaymentID()
//				
//			},
//			amountCredited=7.345
//		};
//		var PaymentTransaction = createPersistedTestEntity('PaymentTransaction',PaymentTransactionData);
//		
//		var PaymentTransactionData={
//			PaymentTransactionID="",
//			accountPayment={
//				accountPaymentID=accountPayment.getAccountPaymentID()
//				
//			},
//			amountRecieved=5.3234324
//		};
//		var PaymentTransaction = createPersistedTestEntity('PaymentTransaction',PaymentTransactionData);
//		
//		request.debug(accountPayment.getAmountUnassigned());
//	}
	
}



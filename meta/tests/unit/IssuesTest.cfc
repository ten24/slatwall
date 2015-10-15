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
component extends="SlatwallUnitTestBase" {
	
	public void function issue_1296() {
		
		var smartList = request.slatwallScope.getService("productService").getProductSmartList();
		
		if(smartList.getRecordsCount() >= 2) {
			smartList.setPageRecordsShow(1);
		
			var productOne = smartList.getPageRecords( true )[1];
			
			smartList.setCurrentPageDeclaration( 2 );
			
			var productTwo = smartList.getPageRecords( true )[1];
			
			assert(productOne.getProductID() neq productTwo.getProductID());	
		}
	}
	
	public void function issue_1329() {
		
		var smartList = request.slatwallScope.getService("productService").getProductSmartList();
		
		smartList.addRange( 'calculatedQATS', 'XXX^' );
		
		smartList.getPageRecords();
		
	}

	public void function issue_1331() {
		
		var product = request.slatwallScope.getService("productService").newProduct();
		
		product.setProductType( request.slatwallScope.getService("productService").getProductType('444df313ec53a08c32d8ae434af5819a') );
		
		assertFalse( product.isProcessable('addOptionGroup') );
	}
	

	
	public void function issue_1348() {
		var product = entityNew("SlatwallProduct");
		var sku = entityNew("SlatwallSku");
		
		sku.setProduct( product );
		sku.setSkuCode( "issue_1348" );
		sku.setPrice( -20 );
		
		sku.validate(context="save");
		
		assert( sku.hasError('price') );
		assert( right( sku.getError('price')[1], 8) neq "_missing");
	}
	
	public void function two_accounts_with_same_primary_email_cannot_be_saved() {
		//GH issue 1376
		var accountService = request.slatwallScope.getService("accountService");
		
		var accountData = {
			firstName = "1376",
			lastName = "Issue",
			phoneNumber = "1234567890",
			emailAddress = "issue1376@github.com",
			emailAddressConfirm = "issue1376@github.com",
			createAuthenticationFlag = 1,
			password = "issue1376",
			passwordConfirm = "issue1376"
		};
		 
		var account = entityNew("SlatwallAccount");
		
		account = accountService.processAccount(account, accountData, 'create'); 
		var accountHasErrors = account.hasErrors();
		
		ormFlush();
		
		var account2 = entityNew("SlatwallAccount");
		accountData.firstName="1376 - 2";
		
		account2 = accountService.processAccount(account2, accountData, 'create');
		
		var account2HasErrors = account2.hasErrors();
		
		account.setPrimaryEmailAddress(javaCast("null",""));
		account.setPrimaryPhoneNumber(javaCast("null",""));
		account2.setPrimaryEmailAddress(javaCast("null",""));
		account2.setPrimaryPhoneNumber(javaCast("null",""));
		
		entityDelete( account );
		entityDelete (account2 );
		
		ormFlush();
		
		assertFalse(accountHasErrors);
		assert(account2HasErrors);
	}

	public void function issue_1604() {
		
		var order = request.slatwallScope.getCart();
		
		order = request.slatwallScope.getService('orderService').processOrder(order, {}, 'clear');
			
		assert(!isNull(order));
	}
	
	public void function issue_1690() {
		
		var product  = request.slatwallScope.newEntity("Product");
		
		product.validate( context="save" );
		
		if(!product.hasErrors()){
			request.slatwallScope.saveEntity( product );
		}
	}
	
	public void function issue_1690_2() {
		var product  = request.slatwallScope.newEntity("Product");
		request.slatwallScope.saveEntity( product );
	}
	
}



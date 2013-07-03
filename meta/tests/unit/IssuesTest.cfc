/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component extends="SlatwallUnitTestBase" {

	public void function issue_1097() {
		
		var product = entityNew("SlatwallProduct");
		
		productData = {
			productName = "My Product",
			productType = {
				productTypeID = "444df2f7ea9c87e60051f3cd87b435a1"
			}
		};
		
		product.populate( productData );
		
		entitySave( product );
		
		ormFlush();
		
		entityDelete( product );
		
		ormFlush();
	}
	
	public void function issue_1296() {
		
		var smartList = request.slatwallScope.getService("productService").getProductSmartList();
		
		smartList.setPageRecordsShow(1);
		
		var productOne = smartList.getPageRecords( true )[1];
		
		smartList.setCurrentPageDeclaration( 2 );
		
		var productTwo = smartList.getPageRecords( true )[1];
		
		assert(productOne.getProductID() neq productTwo.getProductID());
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
	
	public void function issue_1335() {

		var skuCurrency = entityNew("SlatwallSkuCurrency");

		skuCurrency.setPrice( -20 );
		skuCurrency.setListPrice( 'test' );
		
		skuCurrency.validate(context="save");
		
		assert( skuCurrency.hasError('price') );
		assert( skuCurrency.hasError('listPrice') );
		
		assert( right( skuCurrency.getError('price')[1], 8) neq "_missing");
		assert( right( skuCurrency.getError('listPrice')[1], 8) neq "_missing");
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
	
	public void function issue_1376() {
		
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
		var account2 = entityNew("SlatwallAccount");
		
		account = accountService.processAccount(account, accountData, 'create'); 
		var accountHasErrors = account.hasErrors();
		
		ormFlush();
		
		accountData.firstName="1376 - 2";
		
		account2 = accountService.processAccount(account2, accountData, 'create');
		
		var account2HasErrors = account2.hasErrors();
		
		account.setPrimaryEmailAddress(javaCast("null",""));
		account.setPrimaryPhoneNumber(javaCast("null",""));
		account2.setPrimaryEmailAddress(javaCast("null",""));
		account2.setPrimaryPhoneNumber(javaCast("null",""));
		
		entityDelete(account);
		entityDelete(account2);
		
		ormFlush();
		
		assertFalse(accountHasErrors);
		assert(account2HasErrors);
	}
	
	public void function issue_1604() {
		
		var order = request.slatwallScope.getCart();
		
		order = request.slatwallScope.getService('orderService').processOrder(order, {}, 'clear');
			
		assert(!isNull(order));
	}
}


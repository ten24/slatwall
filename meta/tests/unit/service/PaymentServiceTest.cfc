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
		
		variables.service = request.slatwallScope.getService("paymentService");
	}
	
	// getUncapturedPreAuthorizations()
	public void function getUncapturedPreAuthorizations_returns_empty_array_with_no_history() {
		var payment = entityNew('SlatwallOrderPayment');
		
		var result = variables.service.getUncapturedPreAuthorizations( payment );
		
		assert(arrayLen(result) eq 0); 
	}
	
	// getUncapturedPreAuthorizations()
	public void function getUncapturedPreAuthorizations_returns_correctly_sorted_auth_amounts() {
		var payment = entityNew('SlatwallOrderPayment');
		
		var pt1 = entityNew('SlatwallPaymentTransaction');
		pt1.setCreatedDateTime('3/1/2012');
		pt1.setAmountAuthorized( 100 );
		pt1.setTransactionType( 'authorize' );
		pt1.setAuthorizationCode( 'AUTH-ONE' );
		pt1.setOrderPayment( payment );
		
		var pt2 = entityNew('SlatwallPaymentTransaction');
		pt2.setCreatedDateTime('3/5/2012');
		pt2.setAmountReceived( 30 );
		pt2.setTransactionType( 'chargePreAuthorization' );
		pt2.setAuthorizationCodeUsed( 'AUTH-ONE' );
		pt2.setOrderPayment( payment );
		
		var pt3 = entityNew('SlatwallPaymentTransaction');
		pt3.setCreatedDateTime('2/20/2012');
		pt3.setAmountAuthorized( 200 );
		pt3.setTransactionType( 'authorize' );
		pt3.setAuthorizationCode( 'AUTH-TWO' );
		pt3.setOrderPayment( payment );
		
		var pt4 = entityNew('SlatwallPaymentTransaction');
		pt4.setCreatedDateTime('2/25/2012');
		pt4.setAmountAuthorized( 50 );
		pt4.setTransactionType( 'authorize' );
		pt4.setAuthorizationCode( 'AUTH-THREE' );
		pt4.setOrderPayment( payment );
		
		var pt5 = entityNew('SlatwallPaymentTransaction');
		pt5.setCreatedDateTime('2/26/2012');
		pt5.setAmountReceived( 50 );
		pt5.setTransactionType( 'chargePreAuthorization' );
		pt5.setAuthorizationCodeUsed( 'AUTH-THREE' );
		pt5.setOrderPayment( payment );
		
		assert(arrayLen(payment.getPaymentTransactions()) eq 5);
		
		var result = variables.service.getUncapturedPreAuthorizations( payment );
		
		assert(arrayLen(result) eq 2);
		assert(result[1].createdDateTime eq '2/20/2012');
		assert(result[2].createdDateTime eq '3/1/2012');
		assert(result[1].chargeableAmount eq 200);
		assert(result[2].chargeableAmount eq 70);
	}
	
}



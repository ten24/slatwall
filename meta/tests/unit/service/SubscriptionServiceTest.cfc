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
		variables.service = request.slatwallScope.getService("subscriptionService");
	}
	/* test to be completed
	public void function processSubscriptionUsage_renew_test(){
		//args subsciptionUsage, processObject,data
		var accountData = {
			accountID = 'ryansAccountID',
			firstName = 'Ryan',
			lastName = 'Marchand'
		};
		var account = createPersistedTestEntity('account',accountData);
		
		var subscriptionUsageData = {
			subscriptionUsageID="",
			renewalPrice = {
				USD=0
			},
			currencyCode='USD',
			subscriptionOrderItems = [
				{
					subscriptionOrderItemID="",
					subscriptionOrderItemType={
						//soitRenewal
						typeid="444df312935fa6b9866a813b3f4793a2"
					},
					
					currencyCode='USD'
					
				}
			],
			
			expirationDate="12/12/2014"
		};
		var subscriptionUsage = createPersistedTestEntity('subscriptionUsage',subscriptionUsageData);
		
		subscriptionUsage.setAccount(account);
		
		var orderData={
			orderID="",
			orderStatusType={
				//ostClosed
				typeid="444df2b8b98441f8e8fc6b5b4266548c"
			},
			orderItems=[
				{
					orderItemID="test",
					quantity=1,
					
					currencyCode='USD'
				}
			]
		};
		var order = createPersistedTestEntity('order',orderData);
		
		var productData ={
			productid="",
			productName="productName",
			skus=[
				{
					skuid="",
					price = 10,
					skuName="testsku"
					
				}
			],
			productType={
				productTypeID="444df2f9c7deaa1582e021e894c0e299"
			}
		};
		var product = createPersistedTestEntity('product',productData);
		
		var subscriptionTermData={
			subscriptionTermID="",
			subscriptionTermName="subTermName"
		};
		var subscriptionTerm = createPersistedTestEntity('subscriptionTerm',subscriptionTermData); 
		var termData = {
			termID="",
			termHours=0,
			termDays=5,
			termMonths=0,
			termYears=0
		};
		var term = createPersistedTestEntity('term',termData);
		
		var orderItem = order.getOrderItems()[1];
		var sku = product.getSkus()[1];
		
		subscriptionTerm.setRenewalTerm(term);
		
		orderItem.setSku(sku);
		sku.setSubscriptionTerm(subscriptionTerm);
		
		subscriptionUsage.getSubscriptionOrderItems()[1].setOrderItem(order.getOrderItems()[1]);
		

//		//addToDebug(subscriptionTerm);
		//subscriptionUsage.setSubscriptionTerm(subscriptionTerm);
		
		//subscriptionUsage.setRenewalTerm()
		//subscriptionUsage.getSubscriptionOrderItems()[1].setOrderItem(orderItem);
		
		//subscriptionUsage.getSubscriptionOrderItems()[1].getOrderItem().setCurrencyCode('USD');
		
		var data = {
			subscriptionUsageID=subscriptionUsage.getSubscriptionUsageID()
		};
		
		var subscriptionUsage = variables.service.processSubscriptionUsage( subscriptionUsage, data, 'renew' );
		//account.renewSubscriptionUsage();
		

	}*/
	
	
	
}



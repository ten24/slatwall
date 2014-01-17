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
component extends="HibachiService" persistent="false" accessors="true" output="false" {

	property name="addressService" type="any";

	public void function updateOrderAmountsWithTaxes(required any order) {
		
		for(var orderItem in arguments.order.getOrderItems()) {
			
			// Remove all existing tax calculations
			for(var ta=arrayLen(orderItem.getAppliedTaxes()); ta >= 1; ta--) {
				orderItem.getAppliedTaxes()[ta].removeOrderItem();
			}
			
			if(orderItem.getOrderItemType().getSystemCode() == "oitSale") {
				
				// Get this sku's taxCategory
				var taxCategory = this.getTaxCategory(orderItem.getSku().setting('skuTaxCategory'));
				
				if(!isNull(taxCategory)) {
					
					var taxAddress = "";
					
					if(!isNull(orderItem.getOrderFulfillment()) && !isNull(orderItem.getOrderFulfillment().getAddress()) && !orderItem.getOrderFulfillment().getAddress().getNewFlag()) {
						var taxAddress = orderItem.getOrderFulfillment().getShippingAddress();
					} else if (arrayLen(orderItem.getOrder().getOrderPayments()) eq 1 and !isNull(orderItem.getOrder().getOrderPayments()[1].getBillingAddress())) {
						var taxAddress = orderItem.getOrder().getOrderPayments()[1].getBillingAddress();
					}
					
					if(isObject(taxAddress)) {
						for(var r=1; r<= arrayLen(taxCategory.getTaxCategoryRates()); r++) {
							if(isNull(taxCategory.getTaxCategoryRates()[r].getAddressZone()) || (getAddressService().isAddressInZone(address=taxAddress, addressZone=taxCategory.getTaxCategoryRates()[r].getAddressZone()))) {
								var newAppliedTax = this.newTaxApplied();
								newAppliedTax.setAppliedType("orderItem");
								newAppliedTax.setTaxAmount(round(orderItem.getExtendedPriceAfterDiscount() * taxCategory.getTaxCategoryRates()[r].getTaxRate()) / 100);
								newAppliedTax.setTaxRate(taxCategory.getTaxCategoryRates()[r].getTaxRate());
								newAppliedTax.setTaxCategoryRate(taxCategory.getTaxCategoryRates()[r]);
								newAppliedTax.setOrderItem(orderItem);
							}
						}
					}
					
				}
				
			} else if (orderItem.getOrderItemType().getSystemCode() == "oitReturn") {
				
				if(!isNull(orderItem.getReferencedOrderItem())) {
					
					var originalAppliedTaxes = orderItem.getReferencedOrderItem().getAppliedTaxes();
					
					for(var originalAppliedTax in orderItem.getReferencedOrderItem().getAppliedTaxes()) {
						
						var newAppliedTax = this.newTaxApplied();
						
						newAppliedTax.setAppliedType("orderItem");
						newAppliedTax.setTaxAmount( round(orderItem.getExtendedPriceAfterDiscount() * originalAppliedTax.getTaxRate()) / 100 );
						newAppliedTax.setTaxRate( originalAppliedTax.getTaxRate() );
						newAppliedTax.setTaxCategoryRate( originalAppliedTax.getTaxCategoryRate() );
						newAppliedTax.setOrderItem( orderItem );
					}
				}
				
			}
			
		}
	}
	

	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================

}

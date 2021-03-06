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
component entityname="SlatwallProductBundleBuildItem" table="SwProductBundleBuildItem" persistent="true" accessors="true" extends="HibachiEntity" hb_serviceName="productService" hb_permission="productBundleBuild.productBundleBuildItems" {
	
	// Persistent Properties
	property name="productBundleBuildItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="quantity" ormtype="integer";
	
	// Calculated Properties

	// Related Object Properties (many-to-one)
	property name="productBundleBuild" cfc="ProductBundleBuild" fieldtype="many-to-one" fkcolumn="productBundleBuildID";
	property name="productBundleGroup" cfc="ProductBundleGroup" fieldtype="many-to-one" fkcolumn="productBundleGroupID";
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Remote Properties
	property name="remoteID" hb_populateEnabled="false" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	
	// Deprecated Properties


	// ==================== START: Logical Methods =========================
	
	// ====================  END: Logical Methods ==========================
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================

	public void function setProductBundleBuild( required any productBundleBuild ){
		variables.productBundleBuild = arguments.productBundleBuild;
		variables.productBundleBuild.addProductBundleBuildItem(this);
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	public boolean function hasQuantityWithinMaxOrderQuantity(boolean forceMaxOrderSettingFlag=false){
		var quantity = getQuantity();
		//if forceMaxOrderSettingFlag is true and the quantity is > than the maxOrderQuantitySettting
		//then we'll want to return true so that we validate against that instead
		if ( arguments.forceMaxOrderSettingFlag && quantity > getSku().setting('skuOrderMaximumQuantity') ) {
			return true;
		} else if ( quantity <= this.getProductBundleGroup().getMaximumQuantity() && quantity <= getMaximumOrderQuantitySetting() ) {
			return true;
		}
		return false;
    }
    
    public boolean function hasQuantityWithinMinOrderQuantity() {
    	if ( !isNull(this.getProductBundleGroup().getMinimumQuantity()) ) {
			return quantity >= this.getProductBundleGroup().getMinimumQuantity();
		}
    	return ( this.getQuantity() ?: 0 ) >= this.getSku().setting('skuOrderMinimumQuantity');
    }
 	
 	public numeric function getMaximumOrderQuantitySetting() {
		if( this.getSku().getActiveFlag() && this.getSku().getProduct().getActiveFlag() ){
			return getSku().setting('skuOrderMaximumQuantity');
		}
		return 0;
	}
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicit Getters ===================
	
	// ==============  END: Overridden Implicit Getters ====================
	
	// ============= START: Overridden Smart List Getters ==================
	
	// =============  END: Overridden Smart List Getters ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
	
}
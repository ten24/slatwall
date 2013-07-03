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
component displayname="Fulfillment Method" entityname="SlatwallFulfillmentMethod" table="SlatwallFulfillmentMethod" persistent=true output=false accessors=true extends="HibachiEntity" cacheuse="transactional" hb_serviceName="fulfillmentService" hb_permission="this" {
	
	// Persistent Properties
	property name="fulfillmentMethodID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="fulfillmentMethodName" ormtype="string";
	property name="fulfillmentMethodType" ormtype="string" hb_formFieldType="select";
	property name="activeFlag" ormtype="boolean" default="false";
	property name="sortOrder" ormtype="integer";
	
	// Related Object Properties (many-to-one)
	
	// Related Object Properties (one-to-many)
	property name="shippingMethods" singularname="shippingMethod" cfc="ShippingMethod" type="array" fieldtype="one-to-many" fkcolumn="fulfillmentMethodID" cascade="all-delete-orphan" inverse="true";
	property name="orderFulfillments" singularname="orderFulfillment" cfc="OrderFulfillment" fieldtype="one-to-many" fkcolumn="fulfillmentMethodID" inverse="true" lazy="extra";						// Set to lazy, just used for delete validation
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	property name="promotionQualifiers" singularname="promotionQualifier" cfc="PromotionQualifier" type="array" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierFulfillmentMethod" fkcolumn="fulfillmentMethodID" inversejoincolumn="promotionQualifierID" inverse="true";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
		
	public array function getFulfillmentMethodTypeOptions() {
		var options = [
			{name="Shipping", value="shipping"},
			{name="Email", value="email"},
			{name="Pickup", value="pickup"},
			{name="Auto", value="auto"},
			{name="Download", value="download"}
		];
		return options;
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Shipping Methods (one-to-many)    
	public void function addShippingMethod(required any shippingMethod) {    
		arguments.shippingMethod.setFulfillmentMethod( this );    
	}    
	public void function removeShippingMethod(required any shippingMethod) {    
		arguments.shippingMethod.removeFulfillmentMethod( this );    
	}
	
	// Order Fulfillments (one-to-many)
	public void function addOrderFulfillment(required any orderFulfillment) {
		arguments.orderFulfillment.setFulfillmentMethod( this );
	}
	public void function removeOrderFulfillment(required any orderFulfillment) {
		arguments.orderFulfillment.removeFulfillmentMethod( this );
	}
	
	// Promotion Qualifiers (many-to-many - inverse)
	public void function addPromotionQualifier(required any promotionQualifier) {
		arguments.promotionQualifier.addFulfillmentMethods( this );
	}
	public void function removePromotionQualifier(required any promotionQualifier) {
		arguments.promotionQualifier.removeFulfillmentMethods( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}

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
component output="false" accessors="true" extends="HibachiProcess" {

	property name="productService" type="any";
	// Injected Entity
	property name="product";

	// Data Properties
	property name="baseProductType";
	property name="eventStartDateTime" hb_rbKey="entity.sku.eventStartDateTime" hb_formFieldType="datetime";
	property name="eventEndDateTime" hb_rbKey="entity.sku.eventEndDateTime" hb_formFieldType="datetime";
	property name="startReservationDateTime" hb_rbKey="entity.sku.startReservationDateTime" hb_formFieldType="datetime";
	property name="endReservationDateTime" hb_rbKey="entity.sku.endReservationDateTime" hb_formFieldType="datetime";
	property name="price";
	property name="options";
	property name="subscriptionBenefits";
	property name="renewalSubscriptionBenefits";
	property name="subscriptionTerms";
	property name="bundleContentAccessFlag" hb_formFieldType="yesno";
	property name="contents";
	property name="bundleLocationConfigurationFlag" hb_formFieldType="yesno";
	property name="locationConfigurations";
	//property name="productType";
	property name="product__productName";
	property name="product__productCode";
	property name="product__productTypeID";
	property name="product__urlTitle";
	property name="product__brandID";


	/*
	*  PRODUCT SETTERS
	*  Properties with a 'product__' prefix neeed to be assigned
	*  to this object's product.
	*/
	
	
	//productBrand setter
	public function setproduct__brandID(string productBrandID) {
		product.setBrand( getProductService().getBrand( arguments.productBrandID ) );
	}
	
	//productName setter
	public function setproduct__productName(string productName) {
		product.setproductName(arguments.productName);
	}
	
	//productCode setter
	public function setproduct__productCode(string productCode) {
		product.setproductCode(arguments.productCode);
	}
	
	//productType setter
	public function setproduct__productTypeID(string productTypeID) {
		product.setproductType( getProductService().getProductType( arguments.productTypeID ) );
	}
	
	//urlTitle setter
	public function setproduct__urlTitle(string urlTitle) {
		product.seturlTitle(arguments.urlTitle);
	}
	
	// Creates a unique url title from a combination of properties
	public function createUniqueURLTitle(titleString=this.product.getTitle(), tableName="SwProduct") {
		product.setURLTitle(getDataService().createUniqueURLTitle(titleString=arguments.titleString, tableName=arguments.tableName));
	}
	
	// Returns a structure of properties associated with the product objecrt
	public struct function getProductProperties() {
		var productProperties = structNew();
		var properties = getMetaData(this).properties;
		var PRODUCT_PREFIX = "product__";
		var productPrefixLength = len(PRODUCT_PREFIX);
		for(var i=1;i<=arraylen(properties);i++) {
			if(left(properties[i].name,productPrefixLength) == PRODUCT_PREFIX) {
				var productPropertyName = right(properties[i].name,len(properties[i].name)-productPrefixLength);
				productProperties[productPropertyName] = getPropertyValue(properties[i].name);
			}
		}

		return productProperties;
	}

	// Returns the value of a property within this object
	private any function getPropertyValue(String key){
		var method = this["get#key#"];
		return method();
	}

	
	
}

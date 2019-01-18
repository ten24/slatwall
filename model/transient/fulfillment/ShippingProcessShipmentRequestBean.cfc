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
    along with this program.  If not, see <http://www.gnu.org/licenses/;.

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

component accessors="true" output="false" extends="Slatwall.model.transient.fulfillment.ShippingRequestBean" {
    
    property name="packageCount" type="numeric";
    property name="packageNumber" type="numeric";
    property name="container" type="struct";
    property name="containers" type="array";
    property name="masterTrackingID" type="string";
    
	public any function init() {
		// Set defaults


		return super.init();
	}
	
	public struct function getContainer(){
	    if(isNull(variables.container)){
	        var container = {};
	        container.height = 1;
	        container.width = 1;
	        container.depth = 1;
            variables.container = container;
	    }
	    var dimensions = 'height,width,depth';
	    for(var dimension in dimensions){
	        if(isNull(variables.container[dimension])){
	            variables.container[dimension] = 1;
	        }
	    }
	    
	    return variables.container;
	}
	
	public void function addContainer(struct container){
	    if(isNull(arguments.container)){
	        arguments.container = {};
	        arguments.container.height = 1;
	        arguments.container.width = 1;
	        arguments.container.depth = 1;
	    }
	    var dimensions = 'height,width,depth';
	    for(var dimension in dimensions){
	        if(isNull(arguments.container[dimension])){
	            arguments.container[dimension] = 1;
	        }
	    }
	    if(isNull(variables.containers)){
	    	variables.containers = [];
	    }
	    var containers = variables.containers;
	    arrayAppend(containers,arguments.container);
	    this.setContainers(containers);
	}

    public void function populateShippingItemsWithOrderDelivery_Create(required any processObject, boolean clear=false){
        if(arguments.clear){
			variables.shippingItemRequestBeans = [];
		} 
		var orderDeliveryItems = arguments.processObject.getOrderDeliveryItems();
		for(var i=1; i <= arrayLen(orderDeliveryItems); i++) {
		    var orderItem = getService('orderService').getOrderItem(orderDeliveryItems[i].orderItem.orderItemID);
		    if(isnull(orderItem) || orderItem.getNewFlag()){
		        continue;
		    }
		    var sku = orderItem.getSku();
			addShippingItem(
				value=sku.getPrice(),
				weight=sku.setting( 'skuShippingWeight' ),
				weightUnitOfMeasure=sku.setting( 'skuShippingWeightUnitCode' ),
				quantity=orderDeliveryItems[i].quantity
		    );
		}
    }
    
    public void function populateShippingItemsWithOrderDelivery_GenerateShippingLabel(required any processObject, boolean clear=false){
        if(arguments.clear){
			variables.shippingItemRequestBeans = [];
		} 
		var orderDeliveryItems = arguments.processObject.getOrderDelivery().getOrderDeliveryItems();
		for(var i=1; i <= arrayLen(orderDeliveryItems); i++) {
		    
		    var sku = orderDeliveryItems[i].getOrderItem().getSku();
			addShippingItem(
				value=sku.getPrice(),
				weight=sku.setting( 'skuShippingWeight' ),
				weightUnitOfMeasure=sku.setting( 'skuShippingWeightUnitCode' ),
				quantity=orderDeliveryItems[i].getQuantity()
		    );
		}
    }

}
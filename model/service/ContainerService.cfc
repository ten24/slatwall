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
2/
*/
component extends="HibachiService" output="false" accessors="true"  {
    
    property name="stockService";
    property name="orderService";
    property name="skuService";
    
	// ===================== START: Logical Methods ===========================
	
	public any function populateContainerFromContainerStructAndOrderDelivery(required struct containerStruct,required any orderDelivery){
	    var container = this.newContainer();
	    
	    if ( structKeyExists(arguments.containerStruct, "height") ){
	    	container.setHeight(arguments.containerStruct.height);
	    }
	    if ( structKeyExists(arguments.containerStruct, "width") ){
	    	container.setWidth(arguments.containerStruct.width);
	    }
	    if ( structKeyExists(arguments.containerStruct, "depth") ){
	    	container.setDepth(arguments.containerStruct.depth);
	    }
	    if ( structKeyExists(arguments.containerStruct, "weight") ){
	    	container.setWeight(arguments.containerStruct.weight);
	    }
		if (structKeyExists(arguments.containerStruct, 'value')){
	    	container.setValue(arguments.containerStruct.value);
		}
		if(structKeyExists(arguments.containerStruct,'containerLabel') && !isNull(arguments.containerStruct.containerLabel)){
	    	container.setContainerLabel(arguments.containerStruct.containerLabel);
		}
		if(structKeyExists(arguments.containerStruct,'trackingNumber') && !isNull(arguments.containerStruct.trackingNumber)){
	    	container.setTrackingNumber(arguments.containerStruct.trackingNumber);
		}
		if(structKeyExists(arguments.containerStruct,'containerPresetID') && !isNull(arguments.containerStruct.containerPresetID)){
	    	container.setContainerPreset(this.getContainerPreset(arguments.containerStruct.containerPresetID));
		}
	    container.setOrderDelivery(arguments.orderDelivery);

	    
        this.saveContainer(container);
		
		if (structKeyExists(arguments.containerStruct,'containerItems') && !isNull(arguments.containerStruct.containerItems)) {
			for(var containerItem in arguments.containerStruct.containerItems){
				if (containerItem.packagedQuantity > 0) {
					container = this.addContainerItemToContainer(container,containerItem);
				}
			}
		}
		
		if(container.hasErrors()){
		    arguments.orderDelivery.addErrors(container.getErrors());
		}
		
        return arguments.orderDelivery;
	}
	
	public any function addContainerItemToContainer(required any container, required struct containerItemStruct){
		
		var orderDeliveryItems = arguments.container.getOrderDelivery().getOrderDeliveryItems();
		var orderDeliveryItemIndex = arrayFind(orderDeliveryItems, function(item){
			return item.getOrderItem().getOrderItemID() ==  containerItemStruct.item.orderItemID;
		});
		if(orderDeliveryItemIndex > 0){
			var orderDeliveryItem = orderDeliveryItems[orderDeliveryItemIndex];
		}else{
	    	var orderDeliveryItem = this.getOrderDeliveryItemFromContainerAndContainerItemStruct(argumentCollection=arguments);
		}

		var containerItem = this.newContainerItem();
		containerItem.setOrderDeliveryItem(orderDeliveryItem);
		
		if ( structKeyExists(arguments.containerItemStruct, 'sku') ){
			containerItem.setSku(getSkuService().getSku(arguments.containerItemStruct.sku.skuID));
		}
	
		containerItem.setContainer(arguments.container);
		containerItem.setQuantity(arguments.containerItemStruct.packagedQuantity);
		try{
		    this.saveContainerItem(containerItem);
		}catch(any e){
		    writeDump(var=containerItem,top=3);
		    writeDump(e);abort;
		}
		if(containerItem.hasErrors()){
		    arguments.container.addErrors(containerItem.getErrors());
		}

		return container;
	}
	
	private any function getOrderDeliveryItemFromContainerAndContainerItemStruct(required any container, required struct containerItemStruct){
	    // Create a new orderDeliveryItem
		var newOrderDeliveryItem = getOrderService().newOrderDeliveryItem();

		var orderItem = this.getOrderItem(
				arguments.containerItemStruct.item.orderItemID
			);
		// Populate with the data
		newOrderDeliveryItem.setOrderItem(orderItem);
		if(structKeyExists(arguments.containerItemStruct.item,'quantity')){
			newOrderDeliveryItem.setQuantity( arguments.containerItemStruct.item.quantity );
		}else{
			newOrderDeliveryItem.setQuantity( arguments.containerItemStruct.packagedQuantity );
		}
		
		var stock = getStockService().getStockBySkuAndLocation(
			sku=newOrderDeliveryItem.getOrderItem().getSku(),
			location=arguments.container.getOrderDelivery().getLocation()
		);
		newOrderDeliveryItem.setStock(
			stock
		);
		newOrderDeliveryItem.setOrderDelivery( arguments.container.getOrderDelivery() );
		
		return newOrderDeliveryItem;
	}

	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
}

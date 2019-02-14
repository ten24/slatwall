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
	
	public any function getContainerDetails(required any entity,boolean apiFormat=false){
	    var itemPackageName = '';
	    var itemArrayName = '';
	    var ignoreExcludedItems = false;
		
	    var entityClassName = arguments.entity.getClassName();

	    switch(entityClassName){
      
	        case "Order":
	        	itemArrayName="OrderItems";
        		break;
            
            case "OrderDelivery":
	        	itemArrayName="OrderDeliveryItems";
            	break;
            case "OrderFulfillment":
	        	itemArrayName="OrderFulfillmentItems";
        		break;
            
    		case "ShippingRatesRequestBean":
    			itemPackageName="OrderFulfillment";
	        	itemArrayName="OrderFulfillmentItems";
	        	ignoreExcludedItems=true;
        		break;
    		case "ShippingProcessShipmentRequestBean":
    			itemPackageName="OrderDelivery";
	        	itemArrayName="OrderDeliveryItems";
        		break;
			case "OrderDelivery_Create": case "OrderDelivery_GetContainerDetails":
				var itemArray = getItemArrayFromOrderDelivery_Create(arguments.entity);
				break;
        default:
            throw("#entity.getClassName()# is not a valid entity for function 'getContainerDetails'");
	    }

	    var packageEntity = arguments.entity;
	    
	    if(len(itemPackageName)){
    		packageEntity = arguments.entity.invokeMethod('get#itemPackageName#');
	    }
	    
	    if(isNull(packageEntity)){
	    	return;
	    }
	    
    	if(!structKeyExists(local,'itemArray')){
    		try{
    			var itemArray = packageEntity.invokeMethod('get#itemArrayName#');
    		}catch(any e){
    			writeDump(var=arguments.entity,top=3);
    			writeDump(e);abort;
    		}
    	}
    	
    	//For rate requests, filter out skus with Shipping Cost Exempt set to true
		if(ignoreExcludedItems){
			itemArray = arrayFilter(itemArray,function(item){
				if(item.getClassName() == 'OrderItem'){
					var orderItem = item;
				}else{
					var orderItem = item.getOrderItem();
				}
				return !orderItem.getSku().setting('skuShippingCostExempt');
			});
		}

	    var containerStruct = {'packageCount':0};
	    
	    for(var item in itemArray){
	    	arguments.containerStruct = addItemToContainerStruct(containerStruct, item);
	    }

		 if(arguments.apiFormat){
        	for(var key in containerStruct){
        		if(isArray(containerStruct[key])){
        			for(var container in containerStruct[key]){
        				for(var containerItem in container.containerItems){
    						if(containerItem.item.getClassName() == 'OrderItem'){
        						containerItem.item = {
        							'orderItemID':containerItem.item.getOrderItemID(),
        							'skuCode':containerItem.item.getSku().getSkuCode(),
        							'skuName':containerItem.item.getSku().getSkuName(),
        							'quantity':containerItem.item.getQuantity()
        						};
        					}else{
        						containerItem.item = {
        							'orderItemID':containerItem.item.getOrderItem().getOrderItemID(),
        							'skuCode':containerItem.item.getOrderItem().getSku().getSkuCode(),
        							'skuName':containerItem.item.getOrderItem().getSku().getSkuName(),
        							'quantity':containerItem.item.getOrderItemQuantity()
        						};
        					}
        					containerItem.sku = {
        							'skuID':containerItem.sku.getSkuID(),
        							'skuCode':containerItem.sku.getSkuCode(),
        							'skuName':containerItem.sku.getSkuName()
        						};
        				}
        			}
        		}
        	}
        }
	    return containerStruct;
	}
	
	private any function getItemArrayFromOrderDelivery_Create(required any processObject){
		//Get # of bottles for each bottle size option
        var itemArray = [];
        var deliveryItems = arguments.processObject.getOrderDeliveryItems();
        for (var itemData in deliveryItems){
			if (itemData.quantity > 0 ){
				var orderItem = getService('OrderService').getOrderItemByOrderItemID(itemData.orderitem.orderItemID);
				if (!isNull(orderItem)){
					
					var containerBean = getTransient('ContainerItemBean');
					containerBean.setOrderItem(orderItem);
					containerBean.setQuantity(itemData.quantity);
					containerBean.setOrderItemQuantity(itemData.quantity);
					arrayAppend(itemArray, containerBean);
				}
				
			}
        }
        return itemArray;
	}
	
	private struct function addItemToContainerStruct(required struct containerStruct, required any item){
		
		var packageName = 'default';
		if(!structKeyExists(arguments.containerStruct,packageName) || isNull(arguments.containerStruct[packageName]) || arrayIsEmpty(arguments.containerStruct[packageName])){
			arguments.containerStruct[packageName] = [{'maxQuantity'=1000}];
			arguments.containerStruct['packageCount'] += 1;
		}
		var containerArray = arguments.containerStruct[packageName];
		
		var remainingQuantity = item.getQuantity();
		
		if(structKeyExists(item,'getCurrencyCode')){
			var currencyCode = item.getCurrencyCode();
		}else if(structKeyExists(item,'getOrderItem')){
			var currencyCode = item.getOrderItem().getCurrencyCode();
		}else{
			var currencyCode = 'USD';
		}
		var itemValue = item.getSku().getAverageCost(currencyCode);
		var itemWeight = item.getSku().setting('skuShippingWeight');
			
		for(var i = 1; i <= arrayLen(containerArray); i++){
			var container = containerArray[i];
			if(remainingQuantity > 0){
				if(!structKeyExists(container,'containerItems')){
					container['containerItems'] = [];
				}
				var containerItems = container['containerItems'];
				
				var currentQuantity = 0;
				for(var containerItem in containerItems){
					currentQuantity += containerItem['packagedQuantity'];
				}
				var allowedQuantity = container['maxQuantity'] - currentQuantity;
				if(allowedQuantity >= remainingQuantity){
					var packageQuantity = remainingQuantity;
				}else{
					var packageQuantity = allowedQuantity;
				}
				if(packageQuantity == 0){
					continue;
				}
				if(!structKeyExists(container, 'itemcount')){
					container['itemcount'] = 0;
				}
				container['itemcount'] += packageQuantity;
				arrayAppend(containerItems,{'item':item,'sku':item.getSku(),'packagedQuantity':packageQuantity});

				container['containerItems'] = containerItems;
				remainingQuantity -= packageQuantity;
				
				if(!structKeyExists(container, 'value')){
					container['value'] = 0;
				}
				container['value'] += (itemValue * packageQuantity);
				
				if(!structKeyExists(container,'weight')){
					container['weight'] = 0;	
				}
				container['weight'] += (itemWeight * packageQuantity);
			}else{
				break;
			}
		}
		return arguments.containerStruct;
	}
	
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
	
	public any function getOrderDeliveryItemFromContainerAndContainerItemStruct(required any container, required struct containerItemStruct){
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

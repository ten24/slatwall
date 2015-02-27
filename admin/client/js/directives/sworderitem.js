'use strict';
angular.module('slatwalladmin').directive('swOrderItem',

[ '$log',
  '$compile',
  '$http',
  '$templateCache',
  '$slatwall',
  'partialsPath', 
  function(
	  $log,
	  $compile,
	  $http,
	  $templateCache,
	  $slatwall,
	  partialsPath
  ) {

	return {
		restrict : "A",
		scope:{
			orderItem:"=",
			orderId:"@",
			attributes:"="
		},
		templateUrl:partialsPath+"orderitem.html",
		link : function(scope, element, attr) {
			$log.debug('order item init');
			$log.debug(scope.orderItem);
			scope.orderItem.clicked = false; //Never been clicked
			scope.orderItem.details = [];
			scope.orderItem.events = [];
			console.log("MY ID: " + scope.orderItem.data.orderItemID);
			var erColumnsConfig =[
			   		         {
			   		        	 	  "isDeletable": false,
			   			      	  "isExportable": true,
			   			      	  "propertyIdentifier": "_eventregistration.eventRegistrationID",
			   			      	  "ormtype": "id",
			   			      	  "isVisible": true,
			   			          "isSearchable": true,
			   			      	  "title": "Event Registration ID"
			   			    },
			   			    {
		   		        	 	  "isDeletable": false,
		   			      	  "isExportable": true,
		   			      	  "propertyIdentifier": "_eventregistration.pendingClaimDateTime",
		   			      	  "ormtype": "id",
		   			      	  "isVisible": true,
		   			          "isSearchable": true,
		   			      	  "title": "Event Registration ID"
			   			    },
			   			    {
			   			    	"isDeletable": false,
			   			    	"isExportable": true,
			   			    	"propertyIdentifier": "_eventregistration.waitlistQueueDateTime",
			   			    	"ormtype": "id",
			   			    	"isVisible": true,
			   			    	"isSearchable": true,
			   			    	"title": "Event Registration ID"
			   			    }
			   			    ];
			//Not working
			/*
			 * ,
			   			    {
		   		        	 	  "isDeletable": false,
			   			      	  "isExportable": true,
			   			      	  "propertyIdentifier": "_eventregistration.waitlistQueuePositionStruct",
			   			      	  "ormtype": "id",
			   			      	  "isVisible": true,
			   			          "isSearchable": true,
			   			      	  "title": "Waitlist Queue Position Struct"
					   		}*/
			var erFilterGroupsConfig =[
			         			    {
			         			      "filterGroup": [
			         			        {
			         			          "propertyIdentifier": "_eventregistration.orderItem.orderItemID",
			         			          "comparisonOperator": "=",
			         			          "value": scope.orderItem.data.orderItemID,
			         			        }
			         			      ]
			         			    }
			         			  ];
			         			
			  var erOptions = {
			         			columnsConfig:angular.toJson(erColumnsConfig),
			         			filterGroupsConfig:angular.toJson(erFilterGroupsConfig),
			         			allRecords:true
			  };
			  var eventPromise = $slatwall.getEntity('EventRegistration', erOptions);
			 
			  		eventPromise.then(function(value){
			  			
					angular.forEach(value.records,function(event){
						scope.orderItem.events.push(event);
						$log.debug(event);
					});
									
				});
			//-------------------------------------->Using until above works with queue position
			if(scope.orderItem.data.sku.data.product.data.productType.data.systemCode === 'event'){
				var eventRegistrationPromise = scope.orderItem.$$getEventRegistrations();
				eventRegistrationPromise.then(function(){
					angular.forEach(scope.orderItem.data.eventRegistrations,function(eventRegistration){
						console.log(eventRegistration);
						var eventRegistrationPromise = eventRegistration.$$getEventRegistrationStatusType();
						eventRegistrationPromise.then(function(){
							console.log(eventRegistration);
							console.log(eventRegistration.data.eventRegistrationStatusType.data.systemCode);
							if(eventRegistration.data.eventRegistrationStatusType.data.systemCode === 'erstWaitlisted'){
								scope.orderItem.onWaitlist = true; 
							}
						});
					});
				});
			}
			//--------------------------------------->
			
			
			//define how we get child order items
			var columnsConfig =[
		         {
			      "isDeletable": false,
			      "isExportable": true,
			      "propertyIdentifier": "_orderitem.orderItemID",
			      "ormtype": "id",
			      "isVisible": true,
			      "isSearchable": true,
			      "title": "Order Item ID"
			    },
 				 {
 				      "title": "Order Item Price",
 				      "propertyIdentifier": "_orderitem.price",
 				      "isVisible": true,
 				      "isDeletable": true
 				},
			    {
			      "title": "Sku Name",
			      "propertyIdentifier": "_orderitem.sku.skuName",
			      "isVisible": true,
			      "isDeletable": true
			    },
			   {
 				      "title": "Sku Price",
 				      "propertyIdentifier": "_orderitem.skuPrice",
 				      "isVisible": true,
 				      "isDeletable": true
			   },
 				   {
	 				      "title": "Sku ID",
	 				      "propertyIdentifier": "_orderitem.sku.skuID",
	 				      "isVisible": true,
	 				      "isDeletable": true
	 			},
			      {
			      "title": "SKU Code",
			      "propertyIdentifier": "_orderitem.sku.skuCode",
			      "isVisible": true,
			      "isDeletable": true
			      },
			   {
 				      "title": "Product Bundle Group",
 				      "propertyIdentifier": "_orderitem.productBundleGroup.productBundleGroupID",
 				      "isVisible": true,
 				      "isDeletable": true
 				},
 				{
 				      "title": "Product ID",
 				      "propertyIdentifier": "_orderitem.sku.product.productID",
 				      "isVisible": true,
 				      "isDeletable": true
 				},
 				{
 				      "title": "Product Name",
 				      "propertyIdentifier": "_orderitem.sku.product.productName",
 				      "isVisible": true,
 				      "isDeletable": true
 				},
 				{
 				      "title": "Product Type",
 				      "propertyIdentifier": "_orderitem.sku.product.productType",
 				      "isVisible": true,
 				      "isDeletable": true
 				},
 				{
 				      "title": "Product Description",
 				      "propertyIdentifier": "_orderitem.sku.product.productDescription",
 				      "isVisible": true,
 				      "isDeletable": true
 				},
 				 {
				      "title": "Subscription Term",
				      "propertyIdentifier": "_orderitem.sku.eventStartDateTime",
				      "isVisible": true,
				      "isDeletable": true
				 },
 				{
				      "title": "Product Description",
				      "propertyIdentifier": "_orderitem.sku.options",
				      "isVisible": true,
				      "isDeletable": true
				},
				{
				      "title": "Product Description",
				      "propertyIdentifier": "_orderitem.sku.options.optionGroup",
				      "isVisible": true,
				      "isDeletable": true
				},
			    {
			      "title": "Qty.",
			      "propertyIdentifier": "_orderitem.quantity",
			      "isVisible": true,
			      "isDeletable": true
			      },
			      	{
 				      "title": "Fulfillment Method Name",
 				      "propertyIdentifier": "_orderitem.orderFulfillment.fulfillmentMethod.fulfillmentMethodName",
 				      "isVisible": true,
 				      "isDeletable": true
 				    },
 					{
	 				      "title": "Fulfillment ID",
	 				      "propertyIdentifier": "_orderitem.orderFulfillment.orderFulfillmentID",
	 				      "isVisible": true,
	 				      "isDeletable": true
	 				    },
 				   {
	 				    "title": "Fulfillment Method Type",
	 				    "propertyIdentifier": "_orderitem.orderFulfillment.fulfillmentMethod.fulfillmentMethodType",
	 				    "isVisible": true,
	 				    "isDeletable": true
 				   },
 				  {
	 				    "propertyIdentifier": "_orderitem.orderFulfillment.pickupLocation.primaryAddress.address",
	 				    "isVisible": true,
	 				    "isDeletable": true
				   },
			    {
			      "title": "Street Address",
			      "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.streetAddress",
			      "isVisible": true,
			      "isDeletable": true
			    },
			    {
			      "title": "Street Address 2",
			      "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.street2Address",
			      "isVisible": true,
			      "isDeletable": true
			    },
			    {
			      "title": "Postal Code",
			      "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.postalCode",
			      "isVisible": true,
			      "isDeletable": true
			    },
			    {
			      "title": "City",
			      "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.city",
			      "isVisible": true,
			      "isDeletable": true
			    },
			    {
			      "title": "State",
			      "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.stateCode",
			      "isVisible": true,
			      "isDeletable": true
			    },
			    {
			      "title": "Country",
			      "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.countryCode",
			      "isVisible": true,
			      "isDeletable": true
			    },
			    {
			      "title": "Image File Name",
			      "propertyIdentifier": "_orderitem.sku.imageFile",
			      "isVisible": true,
			      "isDeletable": true
			    },
			    {
			      "title": "Total",
			      "propertyIdentifier": "_orderitem.itemTotal",
			      "persistent":false
			    },
			    {
			      "title": "Discount Amount",
			      "propertyIdentifier": "_orderitem.discountAmount",
			      "persistent":false
			    }
			    
			    
			];
			
			//add attributes to the column config
			angular.forEach(scope.attributes,function(attribute){
				var attributeColumn = {
					propertyIdentifier:"_orderitem."+attribute.attributeCode,
					attributeID:attribute.attributeID,
			         attributeSetObject:"orderItem"
				};
				columnsConfig.push(attributeColumn);
			});
		
			var filterGroupsConfig =[
			    {
			      "filterGroup": [
			        {
			          "propertyIdentifier": "_orderitem.parentOrderItem.orderItemID",
			          "comparisonOperator": "=",
			          "value": scope.orderItem.$$getID(),
			        }
			      ]
			    }
			  ];
			
			var options = {
				columnsConfig:angular.toJson(columnsConfig),
				filterGroupsConfig:angular.toJson(filterGroupsConfig),
				allRecords:true
			};
			
			//Create a list of order items.
			scope.childOrderItems = [];
			scope.orderItem.depth = 1;
			
			/**
			 * Hide orderItem children on clicking the details link.
			 */
			scope.hideChildren = function(orderItem){
				
				//Set all child order items to clicked = false.
				angular.forEach(scope.childOrderItems, function(child){
					console.log("hideing");
					console.dir(child);
					child.hide = !child.hide;
					scope.orderItem.clicked = !scope.orderItem.clicked;
				});
			}
			
			//scope.orderItem.childItemsRetrieved = false;
			/**
			 * Gets a list of child order items if they exist.
			 */
			scope.getChildOrderItems = function(){
				if(!scope.orderItem.childItemsRetrieved){
					scope.orderItem.clicked = !scope.orderItem.clicked;
					scope.orderItem.hide = !scope.orderItem.hide;
					scope.orderItem.childItemsRetrieved = true;
					var orderItemsPromise = $slatwall.getEntity('orderItem', options);
					orderItemsPromise.then(function(value){
						var collectionConfig = {};
						collectionConfig.columns = columnsConfig;
						collectionConfig.baseEntityName = 'SlatwallOrderItem';
						collectionConfig.baseEntityAlias = '_orderitem';
						var childOrderItems = $slatwall.populateCollection(value.records,collectionConfig);
						angular.forEach(childOrderItems,function(childOrderItem){
							//childOrderItem.hide = false;
							childOrderItem.depth = scope.orderItem.depth+1;
							scope.childOrderItems.push(childOrderItem);
						});
					});
				}else{
					//We already have the items so we just need to show them.
					angular.forEach(scope.childOrderItems, function(child){
						console.dir(child);
						child.hide = !child.hide;
						scope.orderItem.clicked = !scope.orderItem.clicked;
					});
					
				}
			}
		}
	};
} ]);

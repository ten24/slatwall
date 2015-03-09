angular.module('slatwalladmin')
.directive('swOrderItems', [
'$log',
'$timeout',
'$location',
'$slatwall',
'formService',
'partialsPath',
'paginationService',

	function(
	$log,
	$timeout,
	$location,
	$slatwall,
	formService,
	partialsPath,
	paginationService
	){
		return {
			restrict: 'E',
			scope:{
				orderId:"@"
			},
			templateUrl:partialsPath+"orderitemrows.html",
			
			link: function(scope, element, attrs){
				
				scope.currentPage= paginationService.getCurrentPage();
				scope.pageShow = paginationService.getPageShow();
				scope.pageStart = paginationService.getPageStart;
				scope.pageEnd = paginationService.getPageEnd;
				scope.recordsCount = paginationService.getRecordsCount;
				scope.autoScrollPage = 1;
				scope.autoScrollDisabled = false;
				
				scope.keywords = "";
				scope.loadingCollection = false;
				var searchPromise;
				scope.searchCollection = function($timout){
					if(searchPromise) {
						$timeout.cancel(searchPromise);
					}
					
					searchPromise = $timeout(function(){
						$log.debug('search with keywords');
						$log.debug(scope.keywords);
						//Set current page here so that the pagination does not break when getting collection
						paginationService.setCurrentPage(1);
						scope.loadingCollection = true;
						scope.getCollection();
					}, 500);
				};
				
				$log.debug('Init Order Item');
				$log.debug(scope.orderId);	
				
				//Setup the data needed for each order item object.
				scope.getCollection = function(){
					if(scope.pageShow === 'Auto'){
						scope.pageShow = 50;
					}
					
					var columnsConfig =[
					{
					   "isDeletable":false,
					   "isExportable":true,
					   "propertyIdentifier":"_orderitem.orderItemID",
					   "ormtype":"id",
					   "isVisible":true,
					   "isSearchable":true,
					   "title":"Order Item ID"
					},
					{
					   "title":"Order Item Type",
					   "propertyIdentifier":"_orderitem.orderItemType",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"Order Item Price",
					   "propertyIdentifier":"_orderitem.price",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"Sku Name",
					   "propertyIdentifier":"_orderitem.sku.skuName",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"Sku Price",
					   "propertyIdentifier":"_orderitem.skuPrice",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"Sku ID",
					   "propertyIdentifier":"_orderitem.sku.skuID",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"SKU Code",
					   "propertyIdentifier":"_orderitem.sku.skuCode",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"Product Bundle Group",
					   "propertyIdentifier":"_orderitem.productBundleGroup.productBundleGroupID",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"Product ID",
					   "propertyIdentifier":"_orderitem.sku.product.productID",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"Product Name",
					   "propertyIdentifier":"_orderitem.sku.product.productName",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"Product Type",
					   "propertyIdentifier":"_orderitem.sku.product.productType",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"Product Description",
					   "propertyIdentifier":"_orderitem.sku.product.productDescription",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"Event Start Date Time",
					   "propertyIdentifier":"_orderitem.sku.eventStartDateTime",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"Product Description",
					   "propertyIdentifier":"_orderitem.sku.options",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
						   "title":"Sku Location",
						   "propertyIdentifier":"_orderitem.sku.locations",
						   "isVisible":true,
						   "isDeletable":true,
						   "persistent":false
					},
					{
						   "title":"Subscription Term",
						   "propertyIdentifier":"_orderitem.sku.subscriptionTerm.subscriptionTermName",
						   "isVisible":true,
						   "isDeletable":true
					},
					{
						   "title":"Subscription Benefits",
						   "propertyIdentifier":"_orderitem.sku.subscriptionBenefits",
						   "isVisible":true,
						   "isDeletable":true
					},
					{
					   "title":"Qty.",
					   "propertyIdentifier":"_orderitem.quantity",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"Fulfillment Method Name",
					   "propertyIdentifier":"_orderitem.orderFulfillment.fulfillmentMethod.fulfillmentMethodName",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"Fulfillment ID",
					   "propertyIdentifier":"_orderitem.orderFulfillment.orderFulfillmentID",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"Fulfillment Method Type",
					   "propertyIdentifier":"_orderitem.orderFulfillment.fulfillmentMethod.fulfillmentMethodType",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"Street Address",
					   "propertyIdentifier":"_orderitem.orderFulfillment.pickupLocation.primaryAddress.address",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"Street Address",
					   "propertyIdentifier":"_orderitem.orderFulfillment.shippingAddress.streetAddress",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"Street Address 2",
					   "propertyIdentifier":"_orderitem.orderFulfillment.shippingAddress.street2Address",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"Postal Code",
					   "propertyIdentifier":"_orderitem.orderFulfillment.shippingAddress.postalCode",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"City",
					   "propertyIdentifier":"_orderitem.orderFulfillment.shippingAddress.city",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"State",
					   "propertyIdentifier":"_orderitem.orderFulfillment.shippingAddress.stateCode",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"Country",
					   "propertyIdentifier":"_orderitem.orderFulfillment.shippingAddress.countryCode",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"Image File Name",
					   "propertyIdentifier":"_orderitem.sku.imageFile",
					   "isVisible":true,
					   "isDeletable":true
					},
					{
					   "title":"Total",
					   "propertyIdentifier":"_orderitem.itemTotal",
					   "persistent":false
					},
					{
					   "title":"Discount Amount",
					   "propertyIdentifier":"_orderitem.discountAmount",
					   "persistent":false
					},
					{
					   "title":"Tax Amount",
					   "propertyIdentifier":"_orderitem.taxAmount",
					   "persistent":false
					},
					{
					   "propertyIdentifier":"_orderitem.extendedPrice",
					   "persistent":false
					},
					{
					   "propertyIdentifier":"_orderitem.productBundlePrice",
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
					          "propertyIdentifier": "_orderitem.order.orderID",
					          "comparisonOperator": "=",
					          "value": scope.orderId,
					        },
					        {
					        	"logicalOperator":"AND",
					          "propertyIdentifier": "_orderitem.parentOrderItem",
					          "comparisonOperator": "is",
					          "value": "null",
					        }
					      ]
					    }
					  ];
					
					var options = {
						columnsConfig:angular.toJson(columnsConfig),
						filterGroupsConfig:angular.toJson(filterGroupsConfig),
						currentPage:scope.currentPage,
						pageShow:scope.pageShow,
						keywords:scope.keywords
					};
					//Create a list of order items.
					//scope.orderItems = [];
					scope.orderAttributes = [];
					scope.attributeValues = [];
					console.log('getorderitem');
					console.log(scope.currentPage);
					var orderItemsPromise = $slatwall.getEntity('orderItem', options);
					orderItemsPromise.then(function(value){
						scope.collection = value;
						var collectionConfig = {};
						collectionConfig.columns = columnsConfig;
						collectionConfig.baseEntityName = 'SlatwallOrderItem';
						collectionConfig.baseEntityAlias = '_orderitem';
						scope.orderItems = $slatwall.populateCollection(value.pageRecords,collectionConfig);
						scope.loadingCollection = false;
					});
				};
				//get all possible attributes
				var attributesConfig = [  
                    {  
                        "propertyIdentifier":"_attribute.attributeID",
                        "ormtype":"id",
                        "title":"attributeID",
                     },
                     {  
                        "propertyIdentifier":"_attribute.attributeCode",
                        "ormtype":"string",
                        "title":"Attribute Code",
                     },
                     {  
                         "propertyIdentifier":"_attribute.attributeName",
                         "ormtype":"string",
                         "title":"Attribute Name",
                      }
                  ];	
				
				var attributesFilters =[
				    {
					    "filterGroup": [
	     			        {
	     			          "propertyIdentifier": "_attribute.displayOnOrderDetailFlag",
	     			          "comparisonOperator": "=",
	     			          "value": true
	     			        },
	     			       {
	     			        	"logicalOperator":"AND",
	     			          "propertyIdentifier": "_attribute.activeFlag",
	     			          "comparisonOperator": "=",
	     			          "value": true
	     			        }
     			      ]
     			    }
     			];
				var attributeOptions = {
						columnsConfig:angular.toJson(attributesConfig),
						filterGroupsConfig:angular.toJson(attributesFilters),
						allRecords:true
					};
				var attItemsPromise = $slatwall.getEntity('attribute', attributeOptions);
				attItemsPromise.then(function(value){
					scope.attributes = [];
					angular.forEach(value.records, function(attributeItemData){
						//Use that custom attribute name to get the value.
						scope.attributes.push(attributeItemData);
						
					});
					scope.getCollection();
				});
				
				//Add claim function and cancel function
				
				
				scope.appendToCollection = function(){
					if(scope.pageShow === 'Auto'){
						$log.debug('AppendToCollection');
						if(scope.autoScrollPage < scope.collection.totalPages){
							scope.autoScrollDisabled = true;
							scope.autoScrollPage++;
							
							var appendOptions = {};
							angular.extend(appendOptions,options);
							appendOptions.pageShow = 50;
							appendOptions.currentPage = scope.autoScrollPage;
							
							var collectionListingPromise = $slatwall.getEntity('orderItem', appendOptions);
							collectionListingPromise.then(function(value){
								scope.collection.pageRecords = scope.collection.pageRecords.concat(value.pageRecords);
								scope.autoScrollDisabled = false;
							},function(reason){
							});
						}
					}
				};
				
			}//<--End link
		};
	}
]);
	

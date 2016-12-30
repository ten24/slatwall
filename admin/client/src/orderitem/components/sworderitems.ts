/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOrderItems{
	public static Factory(){
		var directive = (
			$log,
			$timeout,
			$location,
			$hibachi,
            collectionConfigService,
			formService,
			orderItemPartialsPath,
			slatwallPathBuilder,
			paginationService
		)=> new SWOrderItems(
			$log,
			$timeout,
			$location,
			$hibachi,
            collectionConfigService,
			formService,
			orderItemPartialsPath,
			slatwallPathBuilder,
			paginationService
		);
		directive.$inject = [
			'$log',
			'$timeout',
			'$location',
			'$hibachi',
            'collectionConfigService',
			'formService',
			'orderItemPartialsPath',
			'slatwallPathBuilder',
			'paginationService'
		];
		return directive;
	}
    //@ngInject
	constructor(
		$log,
		$timeout,
		$location,
		$hibachi,
        collectionConfigService,
		formService,
		orderItemPartialsPath,
		slatwallPathBuilder,
		paginationService
	){
		return {
			restrict: 'E',
			scope:{
				orderId:"@"
			},
			templateUrl:slatwallPathBuilder.buildPartialsPath(orderItemPartialsPath)+"orderitems.html",

			link: function(scope, element, attrs){
				var options:any = {};
				scope.keywords = "";
				scope.loadingCollection = false;
				var searchPromise;
				scope.searchCollection = function(){
					if(searchPromise) {
						$timeout.cancel(searchPromise);
					}

					searchPromise = $timeout(function(){
						$log.debug('search with keywords');
						$log.debug(scope.keywords);
						//Set current page here so that the pagination does not break when getting collection
						scope.paginator.setCurrentPage(1);
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

					var orderItemCollection = collectionConfigService.newCollectionConfig('OrderItem');
 					orderItemCollection.setDisplayProperties(
 						`orderItemID,currencyCode,sku.skuName
                         ,price,skuPrice,sku.skuID,sku.skuCode,productBundleGroup.productBundleGroupID,sku.product.productID
 						,sku.product.productName,sku.product.productDescription,sku.eventStartDateTime
 						,quantity,orderFulfillment.fulfillmentMethod.fulfillmentMethodName,orderFulfillment.orderFulfillmentID
 						,orderFulfillment.shippingAddress.streetAddress
     					,orderFulfillment.shippingAddress.street2Address,orderFulfillment.shippingAddress.postalCode,orderFulfillment.shippingAddress.city,orderFulfillment.shippingAddress.stateCode
 						,orderFulfillment.shippingAddress.countryCode
                         ,orderItemType.systemCode,orderFulfillment.fulfillmentMethod.fulfillmentMethodType
                         ,orderFulfillment.pickupLocation.primaryAddress.address.streetAddress,orderFulfillment.pickupLocation.primaryAddress.address.street2Address
                         ,orderFulfillment.pickupLocation.primaryAddress.address.city,orderFulfillment.pickupLocation.primaryAddress.address.stateCode
                         ,orderFulfillment.pickupLocation.primaryAddress.address.postalCode
 						,itemTotal,discountAmount,taxAmount,extendedPrice,productBundlePrice,sku.baseProductType
                         ,sku.subscriptionBenefits
                         ,sku.product.productType.systemCode,sku.options,sku.locations
 						,sku.subscriptionTerm.subscriptionTermName
 						,sku.imageFile,
                        stock.location.locationName`
 					   
                      )
 					.addFilter('order.orderID',scope.orderId)
 					.addFilter('parentOrderItem','null','IS')
 					.setKeywords(scope.keywords)
 					.setPageShow(scope.paginator.getPageShow())
 					;

					//add attributes to the column config
					angular.forEach(scope.attributes,function(attribute){
						var attributeColumn:any = {
							propertyIdentifier:"_orderitem."+attribute.attributeCode,
							attributeID:attribute.attributeID,
					         attributeSetObject:"orderItem"
						};
						orderItemCollection.columns.push(attributeColumn);
					});


					var orderItemsPromise = orderItemCollection.getEntity();
					orderItemsPromise.then(function(value){
						scope.collection = value;
						var collectionConfig:any = {};
						scope.orderItems = $hibachi.populateCollection(value.pageRecords,orderItemCollection);
                         for (var orderItem in scope.orderItems){
                             $log.debug("OrderItem Product Type");
                             $log.debug(scope.orderItems);
                             //orderItem.productType = orderItem.data.sku.data.product.data.productType.$$getParentProductType();

                         }
                        scope.paginator.setPageRecordsInfo(scope.collection);

						scope.loadingCollection = false;
					},function(value){
                         scope.orderItems = [];
                    });
				};
				var attributesCollection = collectionConfigService.newCollectionConfig('Attribute');
 				attributesCollection.setDisplayProperties('attributeID,attributeCode,attributeName')
 				.addFilter('displayOnOrderDetailFlag',true)
 				.addFilter('activeFlag',true)
 				.setAllRecords(true);

 				var attItemsPromise = attributesCollection.getEntity();
				attItemsPromise.then(function(value){
					scope.attributes = [];
					angular.forEach(value.records, function(attributeItemData){
						//Use that custom attribute name to get the value.
						scope.attributes.push(attributeItemData);

					});
					scope.getCollection();
				});

				//Add claim function and cancel function

				/*scope.appendToCollection = function(){
					if(scope.pageShow === 'Auto'){
						$log.debug('AppendToCollection');
						if(scope.paginator.autoScrollPage < scope.collection.totalPages){
							scope.paginator.autoScrollDisabled = true;
							scope.paginator.autoScrollPage++;

							var appendOptions:any = {};
							angular.extend(appendOptions,options);
							appendOptions.pageShow = 50;
							appendOptions.currentPage = scope.paginator.autoScrollPage;

							var collectionListingPromise = $hibachi.getEntity('orderItem', appendOptions);
							collectionListingPromise.then(function(value){
								scope.collection.pageRecords = scope.collection.pageRecords.concat(value.pageRecords);
								scope.autoScrollDisabled = false;
							},function(reason){
                                scope.collection.pageRecords = [];
							});
						}
					}
				};*/

                scope.paginator = paginationService.createPagination();
                scope.paginator.collection = scope.collection;
                scope.paginator.getCollection = scope.getCollection;
                
                
                //set up custom event as temporary fix to update when new sku is adding via jquery ajax instead of angular scope
                $( document ).on( "listingDisplayUpdate", {
                }, ( event, arg1, arg2 )=> {
                    scope.orderItems = undefined;
                    scope.getCollection();
                });
			}//<--End link
		};
	}
}
export{
	SWOrderItems
}

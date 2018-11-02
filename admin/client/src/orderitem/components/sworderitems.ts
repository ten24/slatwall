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
			paginationService,
			observerService
		)=> new SWOrderItems(
			$log,
			$timeout,
			$location,
			$hibachi,
            collectionConfigService,
			formService,
			orderItemPartialsPath,
			slatwallPathBuilder,
			paginationService,
			observerService
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
			'paginationService',
			'observerService'
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
		paginationService,
		observerService
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
				
				scope.$watch('recordsCount', function (newValue, oldValue, scope) {
				    
				    //Do anything with $scope.letters
				    if (oldValue != undefined && newValue != undefined && newValue.length > oldValue.length){
				    	//refresh so order totals refresh.
				    	window.location.reload();
				    }
				});
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
                         ,price,skuPrice,sku.skuID,sku.skuCode,productBundleGroup.productBundleGroupID
						 ,sku.product.productID
 						 ,sku.product.productName,sku.product.productDescription
						 ,sku.eventStartDateTime
 						 ,quantity
						 ,orderFulfillment.fulfillmentMethod.fulfillmentMethodName
						 ,orderFulfillment.orderFulfillmentID
 						 ,orderFulfillment.shippingAddress.streetAddress
     					 ,orderFulfillment.shippingAddress.street2Address
						 ,orderFulfillment.shippingAddress.postalCode
						 ,orderFulfillment.shippingAddress.city,orderFulfillment.shippingAddress.stateCode
 						 ,orderFulfillment.shippingAddress.countryCode
                         ,orderItemType.systemCode
						 ,orderFulfillment.fulfillmentMethod.fulfillmentMethodType
                         ,orderFulfillment.pickupLocation.primaryAddress.address.streetAddress
						 ,orderFulfillment.pickupLocation.primaryAddress.address.street2Address
                         ,orderFulfillment.pickupLocation.primaryAddress.address.city
						 ,orderFulfillment.pickupLocation.primaryAddress.address.stateCode
                         ,orderFulfillment.pickupLocation.primaryAddress.address.postalCode
						 ,orderReturn.orderReturnID
 						 ,orderReturn.returnLocation.primaryAddress.address.streetAddress
						 ,orderReturn.returnLocation.primaryAddress.address.street2Address
                         ,orderReturn.returnLocation.primaryAddress.address.city
						 ,orderReturn.returnLocation.primaryAddress.address.stateCode
                         ,orderReturn.returnLocation.primaryAddress.address.postalCode
						 ,itemTotal,discountAmount,taxAmount,extendedPrice,productBundlePrice,sku.baseProductType
                         ,sku.subscriptionBenefits
						 ,sku.product.productType.systemCode
						 ,sku.bundleFlag 
						 ,sku.options
						 ,sku.locations
 						 ,sku.subscriptionTerm.subscriptionTermName
 						 ,sku.imageFile
                         ,stock.location.locationName`
 					   
                      )
 					.addFilter('order.orderID',scope.orderId)
 					.addFilter('parentOrderItem','null','IS')
 					.setKeywords(scope.keywords)
 					.setPageShow(scope.paginator.getPageShow())
					.setCurrentPage(scope.paginator.getCurrentPage())
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
						scope.recordsCount = value.pageRecords;
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
                scope.paginator.notifyById = false;
                scope.paginator.collection = scope.collection;
                scope.paginator.getCollection = scope.getCollection;
                
                
                //set up custom event as temporary fix to update when new sku is adding via jquery ajax instead of angular scope
                $( document ).on( "listingDisplayUpdate", {
                }, ( event, arg1, arg2 )=> {
                    scope.orderItems = undefined;
                    scope.getCollection();
                });

				observerService.attach(scope.getCollection,'swPaginationAction');

			}//<--End link
		};
	}
}
export{
	SWOrderItems
}

import { Component, Input, Inject, OnInit } from '@angular/core';
import { $Hibachi } from '../../../../../org/Hibachi/client/src/core/services/hibachiservice';
import { CollectionConfig } from '../../../../../org/Hibachi/client/src/collection/services/collectionconfigservice';
import { PaginationService } from '../../../../../org/Hibachi/client/src/pagination/services/paginationservice';
import { ObserverService } from '../../../../../org/Hibachi/client/src/core/services/observerservice';
import { CurrencyService } from '../../../../../org/Hibachi/client/src/core/services/currencyservice';

@Component({
    selector   : 'sw-order-items',
    templateUrl: '/admin/client/src/orderitem/components/orderitems.html'
})
export class SwOrderItems implements OnInit {
    
    @Input() orderid: string;
    keywords = "";
    loadingCollection = false;
    searchPromise: any;
    paginator: any;
    pageShow: any;
    collection: any;
    recordsCount: any;
    orderitems: any;
    attributes: any = [];
    
    constructor(
        @Inject('$timeout') private $timeout:any,
        private $hibachi: $Hibachi,
        private collectionConfigService: CollectionConfig,
        private paginationService: PaginationService,
        private observerService: ObserverService,
        private currencyService: CurrencyService
    ) {
        
    }
    
    ngOnInit() {
        this.currencyService.getCurrencySymbols();
        var attributesCollection = this.collectionConfigService.newCollectionConfig('Attribute');
        attributesCollection.setDisplayProperties('attributeID,attributeCode,attributeName')
            .addFilter('displayOnOrderDetailFlag',true)
            .addFilter('activeFlag',true)
            .setAllRecords(true);

        var attItemsPromise = attributesCollection.getEntity();
        attItemsPromise.then((value) => {
            this.attributes = [];
            angular.forEach(value.records, (attributeItemData) => {
                //Use that custom attribute name to get the value.
                this.attributes.push(attributeItemData);
            });
            this.getCollection();
        });
                
        this.paginator = this.paginationService.createPagination();
        this.paginator.notifyById = false;
        this.paginator.collection = this.collection;
        this.paginator.getCollection = this.getCollection;
                
                
        //set up custom event as temporary fix to update when new sku is adding via jquery ajax instead of angular scope
        $( document ).on( "listingDisplayUpdate", {
            }, ( event, arg1, arg2 )=> {
                this.orderitems = undefined;
                this.getCollection();
        });

        this.observerService.attach(this.getCollection,'swPaginationAction');        
    }
    
    searchCollection = function(){
        if(this.searchPromise) {
            this.$timeout.cancel(this.searchPromise);
        }

        this.searchPromise = this.$timeout(() => {
            this.paginator.setCurrentPage(1);
            this.loadingCollection = true;
            this.getCollection();
        }, 500);
    };
    
    //Setup the data needed for each order item object.
    getCollection = function(){
        if(this.pageShow === 'Auto'){
            this.pageShow = 50;
        }

     var orderItemCollection = this.collectionConfigService.newCollectionConfig('OrderItem');
     orderItemCollection.setDisplayProperties(
        `orderItemID,currencyCode,sku.skuName
        ,price,skuPrice,sku.skuID,sku.skuCode,productBundleGroup.productBundleGroupID
        ,sku.product.productID
        ,sku.product.productName,sku.product.productDescription
        ,sku.eventStartDateTime
        ,quantity
        ,orderFulfillment.fulfillmentMethod.fulfillmentMethodName
        ,orderFulfillment.orderFulfillmentID
        ,orderFulfillment.shippingAddress.streetAddress
        ,orderFulfillment.shippingAddress.street2Address
        ,orderFulfillment.shippingAddress.postalCode
        ,orderFulfillment.shippingAddress.city,orderFulfillment.shippingAddress.stateCode
        ,orderFulfillment.shippingAddress.countryCode
        ,orderItemType.systemCode
        ,orderFulfillment.fulfillmentMethod.fulfillmentMethodType
        ,orderFulfillment.pickupLocation.primaryAddress.address.streetAddress
        ,orderFulfillment.pickupLocation.primaryAddress.address.street2Address
        ,orderFulfillment.pickupLocation.primaryAddress.address.city
        ,orderFulfillment.pickupLocation.primaryAddress.address.stateCode
        ,orderFulfillment.pickupLocation.primaryAddress.address.postalCode
        ,orderReturn.orderReturnID
        ,orderReturn.returnLocation.primaryAddress.address.streetAddress
        ,orderReturn.returnLocation.primaryAddress.address.street2Address
        ,orderReturn.returnLocation.primaryAddress.address.city
        ,orderReturn.returnLocation.primaryAddress.address.stateCode
        ,orderReturn.returnLocation.primaryAddress.address.postalCode
        ,itemTotal,discountAmount,taxAmount,extendedPrice,productBundlePrice,sku.baseProductType
        ,sku.subscriptionBenefits
        ,sku.product.productType.systemCode
        ,sku.bundleFlag 
        ,sku.options
        ,sku.locations
        ,sku.subscriptionTerm.subscriptionTermName
        ,sku.imageFile
        ,stock.location.locationName`
                       
        )
        .addFilter('order.orderID',this.orderid)
        .addFilter('parentOrderItem','null','IS')
        .setKeywords(this.keywords)
        .setPageShow(this.paginator.getPageShow())
        .setCurrentPage(this.paginator.getCurrentPage())
        ;

        //add attributes to the column config
        angular.forEach(this.attributes,(attribute) => {
            var attributeColumn:any = {
                propertyIdentifier:"_orderitem."+attribute.attributeCode,
                    attributeID:attribute.attributeID,
                    attributeSetObject:"orderItem"
             };
             orderItemCollection.columns.push(attributeColumn);
        });


        var orderItemsPromise = orderItemCollection.getEntity();
        orderItemsPromise.then((value) => {
            this.collection = value;
            var collectionConfig:any = {};
            this.recordsCount = value.pageRecords;
            this.orderitems = this.$hibachi.populateCollection(value.pageRecords,orderItemCollection);
            for (var orderItem in this.orderitems){

                //orderItem.productType = orderItem.data.sku.data.product.data.productType.$$getParentProductType();
                            
            }
            this.paginator.setPageRecordsInfo(this.collection);
            this.loadingCollection = false;
        },(value) => {
            this.orderitems = [];
        });
    };   
}
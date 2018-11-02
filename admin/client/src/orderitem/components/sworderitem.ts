/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOrderItem{
	public static Factory(){
		var directive = (
            $log,
			$compile,
			$http,
			$templateCache,
			$hibachi,
			$timeout,
			collectionConfigService,
			orderItemPartialsPath,
			slatwallPathBuilder
		)=> new SWOrderItem(
			$log,
			$compile,
			$http,
			$templateCache,
			$hibachi,
			$timeout,
			collectionConfigService,
			orderItemPartialsPath,
			slatwallPathBuilder
	  	);
		directive.$inject = [
			'$log',
			'$compile',
			'$http',
			'$templateCache',
			'$hibachi',
			'$timeout',
			'collectionConfigService',
			'orderItemPartialsPath',
			'slatwallPathBuilder'
		];
		return directive;
	}
    //@ngInject
	constructor(
		$log,
		$compile,
		$http,
		$templateCache,
		$hibachi,
		$timeout,
		collectionConfigService,
		orderItemPartialsPath,
		slatwallPathBuilder
	){
		return {
			restrict : "A",
			scope:{
				orderItem:"=",
				orderId:"@",
				attributes:"=",
                paginator:"=?"
			},
			templateUrl:slatwallPathBuilder.buildPartialsPath(orderItemPartialsPath)+"orderitem.html",
			link : function(scope, element, attr) {
                $log.debug('order item init');
				$log.debug(scope.orderItem);
				scope.orderItem.clicked = false; //Never been clicked
				scope.orderItem.details = [];
				scope.orderItem.events = [];
				scope.orderItem.queuePosition;
				scope.orderItem.onWaitlist 		= false;
				scope.orderItem.isPending 		= false;
				scope.orderItem.isRegistered  = false;
				var foundPosition = false;
				if(scope.orderItem.data.sku.data.product.data.productType.data.systemCode === 'event'){
					var eventRegistrationPromise = scope.orderItem.$$getEventRegistrations();
					eventRegistrationPromise.then(function(){
						angular.forEach(scope.orderItem.data.eventRegistrations,function(eventRegistration){
							$log.debug(eventRegistration);
							var eventRegistrationPromise = eventRegistration.$$getEventRegistrationStatusType();
							eventRegistrationPromise.then(function(rec){
								$log.debug(rec);
								angular.forEach(rec.records, function(record){
									$log.debug("Records");
									$log.debug(record.eventRegistrationStatusType);
									angular.forEach(record.eventRegistrationStatusType, function(statusType){
										if ((angular.isDefined(statusType.systemCode) && statusType.systemCode !== null) && statusType.systemCode === "erstWaitlisted"){
												scope.orderItem.onWaitlist = true;  $log.debug("Found + " + statusType.systemCode);
												//Because the customer is waitlisted, we need to get the number of customers ahead of them in the queue.
												var position = getPositionInQueueFor(scope.orderItem);
												scope.orderItem.queuePosition = position;
										}else if ((angular.isDefined(statusType.systemCode) && statusType.systemCode !== null) && statusType.systemCode === "erstRegistered"){
												scope.orderItem.isRegistered = true; $log.debug("Found + " + statusType.systemCode);
										}else if ((angular.isDefined(statusType.systemCode) && statusType.systemCode !== null) && statusType.systemCode === "erstPendingApproval"){
												scope.orderItem.isPending = true; $log.debug("Found + " + statusType.systemCode);
										}else {
												$log.error("Couldn't resolve a status type for: " + statusType.systemCode);
										}
									});
								});
							});
						});
					});
				}

				/**
				* Returns the current position in the queue for an orderItem that's on the waiting list.
				*/
				var getPositionInQueueFor = function(orderItem){
					$log.debug("Retrieving position in Queue: ");
					var queueConfig =[
										{
										"propertyIdentifier":"_eventregistration.waitlistQueuePositionStruct",
										"isVisible":true,
										"persistent":false,
										"title":"Event Registrations"
										}];
					var queueGroupsConfig =[
											{
											"filterGroup": [
												{
												"propertyIdentifier": "_eventregistration.orderItem.orderItemID",
												"comparisonOperator": "=",
												"value": orderItem.$$getID(),
												}
											]
											}
										];
					var queueOptions = {
											columnsConfig:angular.toJson(queueConfig),
											filterGroupsConfig:angular.toJson(queueGroupsConfig),
											allRecords:true
										};
					var positionPromise = $hibachi.getEntity('EventRegistration', queueOptions);
							$log.debug(positionPromise);
							positionPromise.then(function(value){
								angular.forEach(value.records,function(position){
									$log.debug("Position: " + position.waitlistQueuePositionStruct);
									if (position.waitlistQueuePositionStruct !== -1){
										scope.orderItem.queuePosition = position.waitlistQueuePositionStruct;//Use the value.
										return position.waitlistQueuePositionStruct;
									}
								});
							});

				};
				//define how we get child order items
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
							"propertyIdentifier":"_orderitem.sku.baseProductType",
							"persistent":false
						},
						{
						"title":"Event Start Date",
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
							"propertyIdentifier":"_orderitem.skuPrice",
							"ormtype":"string"
						},
						{
						"title":"Image File Name",
						"propertyIdentifier":"_orderitem.sku.imageFile",
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
						"title":"Order Return ID",
						"propertyIdentifier":"_orderitem.orderReturn.orderReturnID",
						"isVisible":true,
						"isDeletable":true
						},
						{
						"title":"Return Street Address",
						"propertyIdentifier":"_orderitem.orderReturn.returnLocation.primaryAddress.address.streetAddress",
						"isVisible":true,
						"isDeletable":true
						},
						{
						"title":"Return Street Address 2",
						"propertyIdentifier":"_orderitem.orderReturn.returnLocation.primaryAddress.address.street2Address",
						"isVisible":true,
						"isDeletable":true
						},
						{
						"title":"Return City",
						"propertyIdentifier":"_orderitem.orderReturn.returnLocation.primaryAddress.address.city",
						"isVisible":true,
						"isDeletable":true
						},
						{
						"title":"Return State",
						"propertyIdentifier":"_orderitem.orderReturn.returnLocation.primaryAddress.address.stateCode",
						"isVisible":true,
						"isDeletable":true
						},
						{
						"title":"Return Postal Code",
						"propertyIdentifier":"_orderitem.orderReturn.returnLocation.primaryAddress.address.postalCode",
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
						"propertyIdentifier" : "_orderitem.orderFulfillment.pickupLocation.primaryAddress.address",
						"isVisible": true,
						"isDeletable": true
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
							"propertyIdentifier":"_orderitem.productBundleGroup.amount",
							"ormtype":"big_decimal"
						},
						{
							"propertyIdentifier":"_orderitem.productBundleGroup.amountType",
							"ormtype":"string"
						},
						{
							"propertyIdentifier":"_orderitem.productBundleGroupPrice",
							"persistent":false
						},
						{
							"propertyIdentifier":"_orderitem.productBundlePrice",
							"persistent":false
						}
					];
				//Add attributes to the column configuration
				angular.forEach(scope.attributes,function(attribute){
					var attributeColumn:any = {
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
						$log.debug("hideing");
						child.hide = !child.hide;
						scope.orderItem.clicked = !scope.orderItem.clicked;
					});
				};

				//Delete orderItem
				scope.deleteEntity = function(){                   
					$log.debug("Deleting");
					$log.debug(scope.orderItem);
					var deletePromise = scope.orderItem.$$delete();
					deletePromise.then(function(result){
 						if(!result.errors || !Object.keys(result.errors).length){
 							delete scope.orderItem;
							window.location.reload();
 						}
                        scope.paginator.getCollection();
					});

				};

				/**
				* Gets a list of child order items if they exist.
				*/
				scope.getChildOrderItems = ()=>{
                    if(!scope.orderItem.childItemsRetrieved){
						scope.orderItem.clicked = !scope.orderItem.clicked;
						scope.orderItem.hide = !scope.orderItem.hide;
						scope.orderItem.childItemsRetrieved = true;

						if(scope.orderItem.sku.bundleFlag === 'Yes ' || scope.orderItem.sku.bundleFlag === 1){
							var skuBundleCollection = collectionConfigService.newCollectionConfig('SkuBundle');
				            skuBundleCollection.setDisplayProperties('bundledQuantity, bundledSku.skuCode, bundledSku.price, bundledSku.product.productName');
				            skuBundleCollection.addFilter('sku.skuID',scope.orderItem.sku.skuID); 
				           
				          
				            
				            var skuBundleCollectionPromise = skuBundleCollection.getEntity().then((data)=>{ 
				                if(data.pageRecords.length){
                                    var childOrderItems = $hibachi.populateCollection(data.pageRecords,skuBundleCollection);
                                    angular.forEach(childOrderItems,function(childOrderItem){
										childOrderItem.depth = scope.orderItem.depth+1;
										scope.childOrderItems.push(childOrderItem);
										childOrderItem.data.productBundleGroupPercentage = 1;
                                        if(childOrderItem.data.productBundleGroup.data.amountType === 'skuPricePercentageIncrease'){
											childOrderItem.data.productBundleGroupPercentage = 1 + childOrderItem.data.productBundleGroup.data.amount/100;
										}else if(childOrderItem.data.productBundleGroup.data.amountType === 'skuPricePercentageDecrease'){
											childOrderItem.data.productBundleGroupPercentage = 1 - childOrderItem.data.productBundleGroup.data.amount/100;
										}
									});	
				
				                }
				            });							
							
						}else{
							var orderItemsPromise = $hibachi.getEntity('orderItem', options);						
							orderItemsPromise.then(function(value){
								var collectionConfig:any = {};
								collectionConfig.columns = columnsConfig;
								collectionConfig.baseEntityName = 'SlatwallOrderItem';
								collectionConfig.baseEntityAlias = '_orderitem';
								
								var childOrderItems = $hibachi.populateCollection(value.records,collectionConfig);
								angular.forEach(childOrderItems,function(childOrderItem){
									childOrderItem.depth = scope.orderItem.depth+1;
									scope.childOrderItems.push(childOrderItem);
									childOrderItem.data.productBundleGroupPercentage = 1;
									if(childOrderItem.data.productBundleGroup.data.amountType === 'skuPricePercentageIncrease'){
										childOrderItem.data.productBundleGroupPercentage = 1 + childOrderItem.data.productBundleGroup.data.amount/100;
									}else if(childOrderItem.data.productBundleGroup.data.amountType === 'skuPricePercentageDecrease'){
										childOrderItem.data.productBundleGroupPercentage = 1 - childOrderItem.data.productBundleGroup.data.amount/100;
									}
								});
							});							
						}								
						
					}else{
                        //We already have the items so we just need to show them.
						angular.forEach(scope.childOrderItems, function(child){
							child.hide = !child.hide;
							scope.orderItem.clicked = !scope.orderItem.clicked;
						});

					}
				};

			}
		};
	}

}
export{
	SWOrderItem
}

import { Component, Input, OnInit } from '@angular/core';
import { $Hibachi } from '../../../../../org/Hibachi/client/src/core/services/hibachiservice';
import { CollectionConfig } from '../../../../../org/Hibachi/client/src/collection/services/collectionconfigservice';

@Component({
    selector    : '[sw-order-item]',
    templateUrl : '/admin/client/src/orderitem/components/orderitem.html'
})
export class SwOrderItem implements OnInit {
    @Input() orderitem: any;
    @Input() orderid: any;
    @Input() attributes: any;
    @Input() paginator: any;

    filterGroupsConfig:any;
    options:any;
    childorderitems = [];
    //define how we get child order items
    columnsConfig = [
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
            "title": "Order Item Type",
            "propertyIdentifier": "_orderitem.orderItemType",
            "isVisible": true,
            "isDeletable": true
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
            "propertyIdentifier": "_orderitem.sku.baseProductType",
            "persistent": false
        },
        {
            "title": "Event Start Date",
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
            "propertyIdentifier": "_orderitem.skuPrice",
            "ormtype": "string"
        },
        {
            "title": "Image File Name",
            "propertyIdentifier": "_orderitem.sku.imageFile",
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
            "title": "Order Return ID",
            "propertyIdentifier": "_orderitem.orderReturn.orderReturnID",
            "isVisible": true,
            "isDeletable": true
        },
        {
            "title": "Return Street Address",
            "propertyIdentifier": "_orderitem.orderReturn.returnLocation.primaryAddress.address.streetAddress",
            "isVisible": true,
            "isDeletable": true
        },
        {
            "title": "Return Street Address 2",
            "propertyIdentifier": "_orderitem.orderReturn.returnLocation.primaryAddress.address.street2Address",
            "isVisible": true,
            "isDeletable": true
        },
        {
            "title": "Return City",
            "propertyIdentifier": "_orderitem.orderReturn.returnLocation.primaryAddress.address.city",
            "isVisible": true,
            "isDeletable": true
        },
        {
            "title": "Return State",
            "propertyIdentifier": "_orderitem.orderReturn.returnLocation.primaryAddress.address.stateCode",
            "isVisible": true,
            "isDeletable": true
        },
        {
            "title": "Return Postal Code",
            "propertyIdentifier": "_orderitem.orderReturn.returnLocation.primaryAddress.address.postalCode",
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
            "propertyIdentifier": "_orderitem.orderFulfillment.pickupLocation.primaryAddress.address",
            "isVisible": true,
            "isDeletable": true
        },
        {
            "title": "Total",
            "propertyIdentifier": "_orderitem.itemTotal",
            "persistent": false
        },
        {
            "title": "Discount Amount",
            "propertyIdentifier": "_orderitem.discountAmount",
            "persistent": false
        },
        {
            "title": "Tax Amount",
            "propertyIdentifier": "_orderitem.taxAmount",
            "persistent": false
        },
        {
            "propertyIdentifier": "_orderitem.extendedPrice",
            "persistent": false
        },
        {
            "propertyIdentifier": "_orderitem.productBundleGroup.amount",
            "ormtype": "big_decimal"
        },
        {
            "propertyIdentifier": "_orderitem.productBundleGroup.amountType",
            "ormtype": "string"
        },
        {
            "propertyIdentifier": "_orderitem.productBundleGroupPrice",
            "persistent": false
        },
        {
            "propertyIdentifier": "_orderitem.productBundlePrice",
            "persistent": false
        }
    ];

    constructor(private $hibachi: $Hibachi, private collectionConfigService: CollectionConfig) {
    
    }

    ngOnInit() {
        this.orderitem.clicked = false; //Never been clicked
        this.orderitem.details = [];
        this.orderitem.events = [];
        this.orderitem.queuePosition;
        this.orderitem.onWaitlist = false;
        this.orderitem.isPending = false;
        this.orderitem.isRegistered = false;
        var foundPosition = false;
        if (this.orderitem.data.sku.data.product.data.productType.data.systemCode === 'event') {
            var eventRegistrationPromise = this.orderitem.$$getEventRegistrations();
            eventRegistrationPromise.then(() => {
                angular.forEach(this.orderitem.data.eventRegistrations, (eventRegistration) => {
                    var eventRegistrationPromise = eventRegistration.$$getEventRegistrationStatusType();
                    eventRegistrationPromise.then((rec) => {
                        angular.forEach(rec.records, (record) => {
                            angular.forEach(record.eventRegistrationStatusType, (statusType) => {
                                if ((angular.isDefined(statusType.systemCode) && statusType.systemCode !== null) && statusType.systemCode === "erstWaitlisted") {
                                    this.orderitem.onWaitlist = true;
                                    //Because the customer is waitlisted, we need to get the number of customers ahead of them in the queue.
                                    let position = this.getPositionInQueueFor(this.orderitem);
                                    this.orderitem.queuePosition = position;
                                } else if ((angular.isDefined(statusType.systemCode) && statusType.systemCode !== null) && statusType.systemCode === "erstRegistered") {
                                    this.orderitem.isRegistered = true;
                                } else if ((angular.isDefined(statusType.systemCode) && statusType.systemCode !== null) && statusType.systemCode === "erstPendingApproval") {
                                    this.orderitem.isPending = true;
                                } else {
                                    console.error("Couldn't resolve a status type for: " + statusType.systemCode);
                                }
                            });
                        });
                    });
                });
            });
        }


        //Add attributes to the column configuration
        angular.forEach(this.attributes, (attribute) => {
            var attributeColumn: any = {
                propertyIdentifier: "_orderitem." + attribute.attributeCode,
                attributeID: attribute.attributeID,
                attributeSetObject: "orderItem"
            };
            this.columnsConfig.push(attributeColumn);
        });

        this.filterGroupsConfig = [
            {
                "filterGroup": [
                    {
                        "propertyIdentifier": "_orderitem.parentOrderItem.orderItemID",
                        "comparisonOperator": "=",
                        "value": this.orderitem.$$getID(),
                    }
                ]
            }
        ];

        this.options = {
            columnsConfig: angular.toJson(this.columnsConfig),
            filterGroupsConfig: angular.toJson(this.filterGroupsConfig),
            allRecords: true
        };
        //Create a list of order items.        
        this.orderitem.depth = 1;
    }

    /**
     * Returns the current position in the queue for an orderItem that's on the waiting list.
     */
    getPositionInQueueFor = function(orderItem) {
        let queueConfig = [
            {
                "propertyIdentifier": "_eventregistration.waitlistQueuePositionStruct",
                "isVisible": true,
                "persistent": false,
                "title": "Event Registrations"
            }];
        let queueGroupsConfig = [
            {
                "filterGroup": [
                    {
                        "propertyIdentifier": "_eventregistration.orderItem.orderItemID",
                        "comparisonOperator": "=",
                        "value": this.orderitem.$$getID(),
                    }
                ]
            }
        ];
        let queueOptions = {
            columnsConfig: angular.toJson(queueConfig),
            filterGroupsConfig: angular.toJson(queueGroupsConfig),
            allRecords: true
        };
        let positionPromise = this.$hibachi.getEntity('EventRegistration', queueOptions);
        positionPromise.then((value) => {
            angular.forEach(value.records, (position) => {
                if (position.waitlistQueuePositionStruct !== -1) {
                    this.orderitem.queuePosition = position.waitlistQueuePositionStruct;//Use the value.
                    return position.waitlistQueuePositionStruct;
                }
            });
        });

    };

    /**
     * Hide orderItem children on clicking the details link.
     */
    hideChildren = function(orderItem) {
        //Set all child order items to clicked = false.
        angular.forEach(this.childorderitems, (child) => {
            child.hide = !child.hide;
            this.orderitem.clicked = !this.orderitem.clicked;
        });
    };

    //Delete orderItem
    deleteEntity = function() {
        let deletePromise = this.orderitem.$$delete();
        deletePromise.then((result) => {
            if (!result.errors || !Object.keys(result.errors).length) {
                delete this.orderitem;
                window.location.reload();
            }
            this.paginator.getCollection();
        });

    };
    
    /**
     * Gets a list of child order items if they exist.
     */
    getChildOrderItems = function() {
        if (!this.orderitem.childItemsRetrieved) {
            this.orderitem.clicked = !this.orderitem.clicked;
            this.orderitem.hide = !this.orderitem.hide;
            this.orderitem.childItemsRetrieved = true;
            if (this.orderitem.sku.bundleFlag === 'Yes ' || this.orderitem.sku.bundleFlag === 1) {
                let skuBundleCollection = this.collectionConfigService.newCollectionConfig('SkuBundle');
                skuBundleCollection.setDisplayProperties('bundledQuantity, bundledSku.skuCode, bundledSku.price, bundledSku.product.productName');
                skuBundleCollection.addFilter('sku.skuID', this.orderitem.sku.skuID);
                let skuBundleCollectionPromise = skuBundleCollection.getEntity().then((data) => {
                    if (data.pageRecords.length) {
                        var childOrderItems = this.$hibachi.populateCollection(data.pageRecords, skuBundleCollection);
                        angular.forEach(childOrderItems, (childOrderItem) => {
                            childOrderItem.depth = this.orderitem.depth + 1;
                            this.childorderitems.push(childOrderItem);
                            childOrderItem.data.productBundleGroupPercentage = 1;
                            if( childOrderItem.data.productBundleGroup ){
                                if(childOrderItem.data.productBundleGroup.data.amountType === 'skuPricePercentageIncrease'){
                                    childOrderItem.data.productBundleGroupPercentage = 1 + childOrderItem.data.productBundleGroup.data.amount/100;
                                }else if(childOrderItem.data.productBundleGroup.data.amountType === 'skuPricePercentageDecrease'){
                                    childOrderItem.data.productBundleGroupPercentage = 1 - childOrderItem.data.productBundleGroup.data.amount/100;
                                }
                            }
                        });

                    }
                });

            } else {
                let orderItemsPromise = this.$hibachi.getEntity('orderItem', this.options);
                orderItemsPromise.then((value) => {
                    let collectionConfig: any = {};
                    collectionConfig.columns = this.columnsConfig;
                    collectionConfig.baseEntityName = 'SlatwallOrderItem';
                    collectionConfig.baseEntityAlias = '_orderitem';

                    let childOrderItems = this.$hibachi.populateCollection(value.records, this.collectionConfig);
                    angular.forEach(childOrderItems, (childOrderItem) => {
                        childOrderItem.depth = this.orderitem.depth + 1;
                        this.childorderitems.push(childOrderItem);
                        childOrderItem.data.productBundleGroupPercentage = 1;
                        if (childOrderItem.data.productBundleGroup.data.amountType === 'skuPricePercentageIncrease') {
                            childOrderItem.data.productBundleGroupPercentage = 1 + childOrderItem.data.productBundleGroup.data.amount / 100;
                        } else if (childOrderItem.data.productBundleGroup.data.amountType === 'skuPricePercentageDecrease') {
                            childOrderItem.data.productBundleGroupPercentage = 1 - childOrderItem.data.productBundleGroup.data.amount / 100;
                        }
                    });
                });
            }

        } else {
            //We already have the items so we just need to show them.
            angular.forEach(this.childorderitems, (child) => {
                child.hide = !child.hide;
                this.orderitem.clicked = !this.orderitem.clicked;
            });

        }
    };
}
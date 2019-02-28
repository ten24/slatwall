/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

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
        //this.currencyService.getCurrencySymbols();
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
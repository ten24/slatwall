/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWChildOrderItem{
  public static Factory(){
    var directive = (
      $log,
      $http,
      $compile,
      $templateCache,
      $hibachi,
      orderItemPartialsPath,
      slatwallPathBuilder
    )=> new SWChildOrderItem(
      $log,
      $http,
      $compile,
      $templateCache,
      $hibachi,
      orderItemPartialsPath,
      slatwallPathBuilder
    );
    directive.$inject = [
      '$log',
      '$http',
      '$compile',
      '$templateCache',
      '$hibachi',
      'orderItemPartialsPath',
      'slatwallPathBuilder'
    ];
    return directive;
  }
  constructor(
    $log,
    $http,
    $compile,
    $templateCache,
    $hibachi,
    orderItemPartialsPath,
    slatwallPathBuilder
  ){
    return {
      restrict : "A",
      scope:{
        orderItem:"=",
        orderId:"@",
        childOrderItems:"=",
        attributes:"="
      },
      templateUrl:slatwallPathBuilder.buildPartialsPath(orderItemPartialsPath)+"childorderitem.html",
      link:function(scope, element, attr) {

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
                "title":"Product Description",
                "propertyIdentifier":"_orderitem.sku.product.productDescription",
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
                "propertyIdentifier":"_orderitem.sku.skuPrice",
                "ormtype":"string"
              },
              {
                "title":"Product Type",
                "propertyIdentifier":"_orderitem.sku.product.productType",
                "isVisible":true,
                "isDeletable":true
              },
              {
                  "propertyIdentifier":"_orderitem.sku.baseProductType",
                  "persistent":false
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
                "propertyIdentifier":"_orderitem.extendedPrice",
                "persistent":false
              },
              {
                "propertyIdentifier":"_orderitem.productBundleGroup.amount"
              },
              {
                "title":"Product Bundle Group",
                "propertyIdentifier":"_orderitem.productBundleGroup.productBundleGroupID",
                "isVisible":true,
                "isDeletable":true
              },
              {
                "propertyIdentifier":"_orderitem.productBundleGroup.amountType"
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
        //hide the children on click
        scope.hideChildren = function(orderItem){

          //Set all child order items to clicked = false.
          angular.forEach(scope.childOrderItems, function(child){

            console.dir(child);
            child.hide = !child.hide;
            scope.orderItem.clicked = !scope.orderItem.clicked;
          });
        };
              /**
              * Returns a list of child order items.
              */
        scope.getChildOrderItems = function(orderItem){
          orderItem.clicked = true;
          if(!scope.orderItem.childItemsRetrieved){
            scope.orderItem.childItemsRetrieved = true;
            var orderItemsPromise = $hibachi.getEntity('orderItem', options);
            orderItemsPromise.then(function(value){
              var collectionConfig:any = {};
              collectionConfig.columns = columnsConfig;
              collectionConfig.baseEntityName = 'SlatwallOrderItem';
              collectionConfig.baseEntityAlias = '_orderitem';
              var childOrderItems = $hibachi.populateCollection(value.records,collectionConfig);
              angular.forEach(childOrderItems,function(childOrderItem){
                childOrderItem.hide = false;
                childOrderItem.depth = orderItem.depth+1;
                childOrderItem.data.parentOrderItem = orderItem;
                childOrderItem.data.parentOrderItemQuantity = scope.orderItem.data.quantity / scope.orderItem.data.parentOrderItemQuantity;
                scope.childOrderItems.splice(scope.childOrderItems.indexOf(orderItem)+1,0,childOrderItem);

                childOrderItem.data.productBundleGroupPercentage = 1;
                if(childOrderItem.data.productBundleGroup.data.amountType === 'skuPricePercentageIncrease'){
                  childOrderItem.data.productBundleGroupPercentage = 1 + childOrderItem.data.productBundleGroup.data.amount/100;
                }else if(childOrderItem.data.productBundleGroup.data.amountType === 'skuPricePercentageDecrease'){
                  childOrderItem.data.productBundleGroupPercentage = 1 - childOrderItem.data.productBundleGroup.data.amount/100;
                }

              });

            });
          }
        };
      }
    }
  }
}
export{
  SWChildOrderItem
}
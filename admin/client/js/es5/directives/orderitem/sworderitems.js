"use strict";
angular.module('slatwalladmin').directive('swOrderItems', ['$log', '$timeout', '$location', '$slatwall', 'formService', 'partialsPath', 'paginationService', function($log, $timeout, $location, $slatwall, formService, partialsPath, paginationService) {
  return {
    restrict: 'E',
    scope: {orderId: "@"},
    templateUrl: partialsPath + "orderitemrows.html",
    link: function(scope, element, attrs) {
      scope.currentPage = paginationService.getCurrentPage();
      scope.pageShow = paginationService.getPageShow();
      scope.pageStart = paginationService.getPageStart;
      scope.pageEnd = paginationService.getPageEnd;
      scope.recordsCount = paginationService.getRecordsCount;
      scope.autoScrollPage = 1;
      scope.autoScrollDisabled = false;
      scope.keywords = "";
      scope.loadingCollection = false;
      var searchPromise;
      scope.searchCollection = function($timout) {
        if (searchPromise) {
          $timeout.cancel(searchPromise);
        }
        searchPromise = $timeout(function() {
          $log.debug('search with keywords');
          $log.debug(scope.keywords);
          paginationService.setCurrentPage(1);
          scope.loadingCollection = true;
          scope.getCollection();
        }, 500);
      };
      $log.debug('Init Order Item');
      $log.debug(scope.orderId);
      scope.getCollection = function() {
        if (scope.pageShow === 'Auto') {
          scope.pageShow = 50;
        }
        var columnsConfig = [{
          "isDeletable": false,
          "isExportable": true,
          "propertyIdentifier": "_orderitem.orderItemID",
          "ormtype": "id",
          "isVisible": true,
          "title": "Order Item ID",
          "isSearchable": true
        }, {
          "title": "Order Item Type",
          "propertyIdentifier": "_orderitem.orderItemType",
          "isVisible": true
        }, {
          "title": "Order Item Price",
          "propertyIdentifier": "_orderitem.price",
          "isVisible": true
        }, {
          "title": "Sku Name",
          "propertyIdentifier": "_orderitem.sku.skuName",
          "isVisible": true,
          "ormtype": "string",
          "isSearchable": true
        }, {
          "title": "Sku Price",
          "propertyIdentifier": "_orderitem.skuPrice",
          "isVisible": true
        }, {
          "title": "Sku ID",
          "propertyIdentifier": "_orderitem.sku.skuID",
          "isVisible": true
        }, {
          "title": "SKU Code",
          "propertyIdentifier": "_orderitem.sku.skuCode",
          "isVisible": true,
          "ormtype": "string",
          "isSearchable": true
        }, {
          "title": "Product Bundle Group",
          "propertyIdentifier": "_orderitem.productBundleGroup.productBundleGroupID",
          "isVisible": true
        }, {
          "title": "Product ID",
          "propertyIdentifier": "_orderitem.sku.product.productID",
          "isVisible": true
        }, {
          "title": "Product Name",
          "propertyIdentifier": "_orderitem.sku.product.productName",
          "isVisible": true
        }, {
          "title": "Product Type",
          "propertyIdentifier": "_orderitem.sku.product.productType",
          "isVisible": true
        }, {
          "propertyIdentifier": "_orderitem.sku.baseProductType",
          "persistent": false
        }, {
          "title": "Product Description",
          "propertyIdentifier": "_orderitem.sku.product.productDescription",
          "isVisible": true
        }, {
          "title": "Event Start Date Time",
          "propertyIdentifier": "_orderitem.sku.eventStartDateTime",
          "isVisible": true
        }, {
          "title": "Product Description",
          "propertyIdentifier": "_orderitem.sku.options",
          "isVisible": true
        }, {
          "title": "Sku Location",
          "propertyIdentifier": "_orderitem.sku.locations",
          "isVisible": true,
          "persistent": false
        }, {
          "title": "Subscription Term",
          "propertyIdentifier": "_orderitem.sku.subscriptionTerm.subscriptionTermName",
          "isVisible": true
        }, {
          "title": "Subscription Benefits",
          "propertyIdentifier": "_orderitem.sku.subscriptionBenefits",
          "isVisible": true
        }, {
          "title": "Qty.",
          "propertyIdentifier": "_orderitem.quantity",
          "isVisible": true
        }, {
          "title": "Fulfillment Method Name",
          "propertyIdentifier": "_orderitem.orderFulfillment.fulfillmentMethod.fulfillmentMethodName",
          "isVisible": true
        }, {
          "title": "Fulfillment ID",
          "propertyIdentifier": "_orderitem.orderFulfillment.orderFulfillmentID",
          "isVisible": true
        }, {
          "title": "Fulfillment Method Type",
          "propertyIdentifier": "_orderitem.orderFulfillment.fulfillmentMethod.fulfillmentMethodType",
          "isVisible": true
        }, {
          "title": "Street Address",
          "propertyIdentifier": "_orderitem.orderFulfillment.pickupLocation.primaryAddress.address",
          "isVisible": true,
          "ormtype": "string",
          "isSearchable": true
        }, {
          "title": "Street Address",
          "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.streetAddress",
          "isVisible": true,
          "ormtype": "string",
          "isSearchable": true
        }, {
          "title": "Street Address 2",
          "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.street2Address",
          "isVisible": true,
          "ormtype": "string",
          "isSearchable": true
        }, {
          "title": "Postal Code",
          "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.postalCode",
          "isVisible": true,
          "ormtype": "string",
          "isSearchable": true
        }, {
          "title": "City",
          "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.city",
          "isVisible": true,
          "ormtype": "string",
          "isSearchable": true
        }, {
          "title": "State",
          "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.stateCode",
          "isVisible": true,
          "ormtype": "string",
          "isSearchable": true
        }, {
          "title": "Country",
          "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.countryCode",
          "isVisible": true,
          "ormtype": "string",
          "isSearchable": true
        }, {
          "title": "Image File Name",
          "propertyIdentifier": "_orderitem.sku.imageFile",
          "isVisible": true
        }, {
          "title": "Total",
          "propertyIdentifier": "_orderitem.itemTotal",
          "persistent": false
        }, {
          "title": "Discount Amount",
          "propertyIdentifier": "_orderitem.discountAmount",
          "persistent": false
        }, {
          "title": "Tax Amount",
          "propertyIdentifier": "_orderitem.taxAmount",
          "persistent": false
        }, {
          "propertyIdentifier": "_orderitem.extendedPrice",
          "persistent": false
        }, {
          "propertyIdentifier": "_orderitem.productBundlePrice",
          "persistent": false
        }];
        angular.forEach(scope.attributes, function(attribute) {
          var attributeColumn = {
            propertyIdentifier: "_orderitem." + attribute.attributeCode,
            attributeID: attribute.attributeID,
            attributeSetObject: "orderItem"
          };
          columnsConfig.push(attributeColumn);
        });
        var filterGroupsConfig = [{"filterGroup": [{
            "propertyIdentifier": "_orderitem.order.orderID",
            "comparisonOperator": "=",
            "value": scope.orderId
          }, {
            "logicalOperator": "AND",
            "propertyIdentifier": "_orderitem.parentOrderItem",
            "comparisonOperator": "is",
            "value": "null"
          }]}];
        var options = {
          columnsConfig: angular.toJson(columnsConfig),
          filterGroupsConfig: angular.toJson(filterGroupsConfig),
          currentPage: scope.currentPage,
          pageShow: scope.pageShow,
          keywords: scope.keywords
        };
        scope.orderAttributes = [];
        scope.attributeValues = [];
        var orderItemsPromise = $slatwall.getEntity('orderItem', options);
        orderItemsPromise.then(function(value) {
          scope.collection = value;
          var collectionConfig = {};
          collectionConfig.columns = columnsConfig;
          collectionConfig.baseEntityName = 'SlatwallOrderItem';
          collectionConfig.baseEntityAlias = '_orderitem';
          scope.orderItems = $slatwall.populateCollection(value.pageRecords, collectionConfig);
          for (var orderItem in scope.orderItems) {
            $log.debug("OrderItem Product Type");
            $log.debug(scope.orderItems);
          }
          scope.loadingCollection = false;
        });
      };
      var attributesConfig = [{
        "propertyIdentifier": "_attribute.attributeID",
        "ormtype": "id",
        "title": "attributeID"
      }, {
        "propertyIdentifier": "_attribute.attributeCode",
        "ormtype": "string",
        "title": "Attribute Code"
      }, {
        "propertyIdentifier": "_attribute.attributeName",
        "ormtype": "string",
        "title": "Attribute Name"
      }];
      var attributesFilters = [{"filterGroup": [{
          "propertyIdentifier": "_attribute.displayOnOrderDetailFlag",
          "comparisonOperator": "=",
          "value": true
        }, {
          "logicalOperator": "AND",
          "propertyIdentifier": "_attribute.activeFlag",
          "comparisonOperator": "=",
          "value": true
        }]}];
      var attributeOptions = {
        columnsConfig: angular.toJson(attributesConfig),
        filterGroupsConfig: angular.toJson(attributesFilters),
        allRecords: true
      };
      var attItemsPromise = $slatwall.getEntity('attribute', attributeOptions);
      attItemsPromise.then(function(value) {
        scope.attributes = [];
        angular.forEach(value.records, function(attributeItemData) {
          scope.attributes.push(attributeItemData);
        });
        scope.getCollection();
      });
      scope.appendToCollection = function() {
        if (scope.pageShow === 'Auto') {
          $log.debug('AppendToCollection');
          if (scope.autoScrollPage < scope.collection.totalPages) {
            scope.autoScrollDisabled = true;
            scope.autoScrollPage++;
            var appendOptions = {};
            angular.extend(appendOptions, options);
            appendOptions.pageShow = 50;
            appendOptions.currentPage = scope.autoScrollPage;
            var collectionListingPromise = $slatwall.getEntity('orderItem', appendOptions);
            collectionListingPromise.then(function(value) {
              scope.collection.pageRecords = scope.collection.pageRecords.concat(value.pageRecords);
              scope.autoScrollDisabled = false;
            }, function(reason) {});
          }
        }
      };
    }
  };
}]);

//# sourceMappingURL=../../directives/orderitem/sworderitems.js.map
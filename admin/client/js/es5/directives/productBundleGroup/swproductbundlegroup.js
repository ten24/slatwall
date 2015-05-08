"use strict";
'use strict';
angular.module('slatwalladmin').directive('swProductBundleGroup', ['$http', '$log', '$timeout', '$slatwall', 'productBundlePartialsPath', 'productBundleService', 'collectionService', 'metadataService', 'utilityService', function($http, $log, $timeout, $slatwall, productBundlePartialsPath, productBundleService, collectionService, metadataService, utilityService) {
  return {
    require: "^swProductBundleGroups",
    restrict: 'E',
    templateUrl: productBundlePartialsPath + "productbundlegroup.html",
    scope: {
      productBundleGroup: "=",
      index: "=",
      addProductBundleGroup: "&",
      formName: "@"
    },
    link: function(scope, element, attrs, productBundleGroupsController) {
      var timeoutPromise;
      scope.$id = 'productBundleGroup';
      $log.debug('productBundleGroup');
      $log.debug(scope.productBundleGroup);
      scope.showAdvanced = false;
      scope.openCloseAndRefresh = function() {
        scope.showAdvanced = !scope.showAdvanced;
        $log.debug("OpenAndCloseAndRefresh");
        $log.debug(scope.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup);
        $log.debug("Length:" + scope.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup.length);
        if (scope.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup.length) {
          scope.getCollection();
        }
      };
      scope.removeProductBundleGroup = function() {
        productBundleGroupsController.removeProductBundleGroup(scope.index);
        scope.productBundleGroup.$$delete();
      };
      scope.deleteEntity = function(type) {
        if (angular.isNumber(type)) {
          $log.debug("Deleting filter");
          this.removeProductBundleGroupFilter(type);
        } else {
          $log.debug("Removing bundle group");
          this.removeProductBundleGroup();
        }
      };
      scope.collection = {
        baseEntityName: "Sku",
        baseEntityAlias: "_sku",
        collectionConfig: scope.productBundleGroup.data.skuCollectionConfig,
        collectionObject: 'Sku'
      };
      scope.getCollection = function() {
        var options = {
          filterGroupsConfig: angular.toJson(scope.productBundleGroup.data.skuCollectionConfig.filterGroups),
          columnsConfig: angular.toJson(scope.productBundleGroup.data.skuCollectionConfig.columns),
          currentPage: 1,
          pageShow: 10
        };
        var collectionPromise = $slatwall.getEntity('Sku', options);
        collectionPromise.then(function(response) {
          scope.collection = response;
          $log.debug("Collection Response");
          $log.debug(scope.collection);
        });
      };
      scope.getCollection();
      scope.navigation = {
        value: 'Basic',
        setValue: function(value) {
          this.value = value;
        }
      };
      scope.searchOptions = {
        options: [{
          name: "All",
          value: "All"
        }, {
          name: "Product Type",
          value: "productType"
        }, {
          name: "Brand",
          value: "brand"
        }, {
          name: "Products",
          value: "product"
        }, {
          name: "Skus",
          value: "sku"
        }],
        selected: {
          name: "All",
          value: "All"
        },
        setSelected: function(searchOption) {
          this.selected = searchOption;
          scope.productBundleGroupFilters.getFiltersByTerm(scope.productBundleGroupFilters.keyword, searchOption);
        }
      };
      scope.filterTemplatePath = productBundlePartialsPath + "productbundlefilter.html";
      scope.productBundleGroupFilters = {};
      scope.productBundleGroupFilters.value = [];
      if (angular.isUndefined(scope.productBundleGroup.productBundleGroupFilters)) {
        scope.productBundleGroup.productBundleGroupFilters = [];
      }
      function arrayContains(array, item) {
        var iterator = array.length;
        while (iterator--) {
          if (array[iterator].name === item.name) {
            return true;
          }
        }
        return false;
      }
      scope.productBundleGroupFilters.getFiltersByTerm = function(keyword, filterTerm) {
        scope.loading = true;
        var _loadingCount;
        if (timeoutPromise) {
          $timeout.cancel(timeoutPromise);
        }
        timeoutPromise = $timeout(function() {
          if (filterTerm.value === 'All') {
            scope.productBundleGroupFilters.value = [];
            _loadingCount = scope.searchOptions.options.length - 1;
            for (var i in scope.searchOptions.options) {
              if (i > 0) {
                var option = scope.searchOptions.options[i];
                (function(keyword, option) {
                  $slatwall.getEntity(scope.searchOptions.options[i].value, {
                    keywords: keyword,
                    deferKey: 'getProductBundleGroupFilterByTerm' + option.value
                  }).then(function(value) {
                    var formattedProductBundleGroupFilters = productBundleService.formatProductBundleGroupFilters(value.pageRecords, option);
                    for (var j in formattedProductBundleGroupFilters) {
                      if (!arrayContains(scope.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup, formattedProductBundleGroupFilters[j])) {
                        scope.productBundleGroupFilters.value.push(formattedProductBundleGroupFilters[j]);
                      }
                    }
                    _loadingCount--;
                    if (_loadingCount == 0) {
                      scope.productBundleGroupFilters.value = utilityService.arraySorter(scope.productBundleGroupFilters.value, "type");
                      $log.debug(scope.productBundleGroupFilters.value);
                      scope.loading = false;
                    }
                  });
                })(keyword, option);
              }
            }
          } else {
            $slatwall.getEntity(filterTerm.value, {
              keywords: keyword,
              deferKey: 'getProductBundleGroupFilterByTerm' + filterTerm.value
            }).then(function(value) {
              $log.debug('getFiltersByTerm');
              $log.debug(value);
              scope.productBundleGroupFilters.value = productBundleService.formatProductBundleGroupFilters(value.pageRecords, filterTerm) || [];
              scope.loading = false;
              $log.debug('productBundleGroupFilters');
              $log.debug(scope.productBundleGroupFilters);
            });
          }
        }, 500);
      };
      scope.addFilterToProductBundle = function(filterItem, include, index) {
        $log.debug('addFilterToProductBundle');
        $log.debug(filterItem);
        filterItem.displayPropertyIdentifier = filterItem.type;
        filterItem.propertyIdentifier = filterItem.propertyIdentifier;
        filterItem.displayValue = filterItem[filterItem.entityType.charAt(0).toLowerCase() + filterItem.entityType.slice(1) + 'ID'];
        filterItem.value = filterItem[filterItem.entityType.charAt(0).toLowerCase() + filterItem.entityType.slice(1) + 'ID'];
        if (include === false) {
          filterItem.comparisonOperator = '!=';
        } else {
          filterItem.comparisonOperator = '=';
        }
        if (scope.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup.length > 0) {
          filterItem.logicalOperator = 'OR';
        }
        scope.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup.push(filterItem);
        scope.productBundleGroupFilters.value.splice(index, 1);
        scope.productBundleGroup.forms[scope.formName].skuCollectionConfig.$setDirty();
      };
      if (angular.isUndefined(scope.filterPropertiesList)) {
        scope.filterPropertiesList = {};
        var filterPropertiesPromise = $slatwall.getFilterPropertiesByBaseEntityName('_sku');
        filterPropertiesPromise.then(function(value) {
          metadataService.setPropertiesList(value, '_sku');
          scope.filterPropertiesList['_sku'] = metadataService.getPropertiesListByBaseEntityAlias('_sku');
          metadataService.formatPropertiesList(scope.filterPropertiesList['_sku'], '_sku');
        });
      }
      scope.removeProductBundleGroupFilter = function(index) {
        scope.productBundleGroupFilters.value.push(scope.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup[index]);
        scope.productBundleGroupFilters.value = utilityService.arraySorter(scope.productBundleGroupFilters.value, "type");
        scope.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup.splice(index, 1);
        scope.productBundleGroup.forms[scope.formName].skuCollectionConfig.$setDirty();
      };
    }
  };
}]);

//# sourceMappingURL=../../directives/productBundleGroup/swproductbundlegroup.js.map
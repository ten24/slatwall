"use strict";
'use strict';
angular.module('slatwalladmin').directive('swDisplayItem', ['$http', '$compile', '$templateCache', '$log', '$slatwall', '$filter', 'collectionPartialsPath', 'collectionService', 'metadataService', function($http, $compile, $templateCache, $log, $slatwall, $filter, collectionPartialsPath, collectionService, metadataService) {
  return {
    require: '^swDisplayOptions',
    restrict: 'A',
    scope: {
      selectedProperty: "=",
      propertiesList: "=",
      breadCrumbs: "=",
      selectedPropertyChanged: "&"
    },
    templateUrl: collectionPartialsPath + "displayitem.html",
    link: function(scope, element, attrs, displayOptionsController) {
      scope.showDisplayItem = false;
      scope.selectedDisplayOptionChanged = function(selectedDisplayOption) {
        var breadCrumb = {
          entityAlias: scope.selectedProperty.name,
          cfc: scope.selectedProperty.cfc,
          propertyIdentifier: scope.selectedProperty.propertyIdentifier
        };
        scope.breadCrumbs.push(breadCrumb);
        scope.selectedPropertyChanged({selectedProperty: selectedDisplayOption});
      };
      scope.$watch('selectedProperty', function(selectedProperty) {
        if (angular.isDefined(selectedProperty)) {
          if (selectedProperty === null) {
            scope.showDisplayItem = false;
            return ;
          }
          if (selectedProperty.$$group !== 'drilldown') {
            scope.showDisplayItem = false;
            return ;
          }
          if (selectedProperty.$$group === 'drilldown') {
            if (angular.isUndefined(scope.propertiesList[selectedProperty.propertyIdentifier])) {
              var filterPropertiesPromise = $slatwall.getFilterPropertiesByBaseEntityName(selectedProperty.cfc);
              filterPropertiesPromise.then(function(value) {
                metadataService.setPropertiesList(value, selectedProperty.propertyIdentifier);
                scope.propertiesList[selectedProperty.propertyIdentifier] = metadataService.getPropertiesListByBaseEntityAlias(selectedProperty.propertyIdentifier);
                metadataService.formatPropertiesList(scope.propertiesList[selectedProperty.propertyIdentifier], selectedProperty.propertyIdentifier);
              }, function(reason) {});
            }
          }
          scope.showDisplayItem = true;
        }
      });
    }
  };
}]);

//# sourceMappingURL=../../directives/collection/swdisplayitem.js.map
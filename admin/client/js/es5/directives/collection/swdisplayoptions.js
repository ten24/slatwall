"use strict";
angular.module('slatwalladmin').directive('swDisplayOptions', ['$http', '$compile', '$templateCache', '$log', '$slatwall', 'collectionService', 'collectionPartialsPath', function($http, $compile, $templateCache, $log, $slatwall, collectionService, collectionPartialsPath) {
  return {
    restrict: 'E',
    transclude: true,
    scope: {
      orderBy: "=",
      columns: '=',
      propertiesList: "=",
      saveCollection: "&",
      baseEntityAlias: "=",
      baseEntityName: "="
    },
    templateUrl: collectionPartialsPath + "displayoptions.html",
    controller: ['$scope', '$element', '$attrs', function($scope, $element, $attrs) {
      $log.debug('display options initialize');
      this.removeColumn = function(columnIndex) {
        $log.debug('parent remove column');
        $log.debug($scope.columns);
        if ($scope.columns.length) {
          $scope.columns.splice(columnIndex, 1);
        }
      };
      this.getPropertiesList = function() {
        return $scope.propertiesList;
      };
      $scope.addDisplayDialog = {
        isOpen: false,
        toggleDisplayDialog: function() {
          $scope.addDisplayDialog.isOpen = !$scope.addDisplayDialog.isOpen;
        }
      };
      var getTitleFromPropertyIdentifier = function(propertyIdentifier) {
        var baseEntityCfcName = $scope.baseEntityName.replace('Slatwall', '').charAt(0).toLowerCase() + $scope.baseEntityName.replace('Slatwall', '').slice(1);
        var title = '';
        var propertyIdentifierArray = propertyIdentifier.split('.');
        var currentEntity;
        var currentEntityInstance;
        var prefix = 'entity.';
        angular.forEach(propertyIdentifierArray, function(propertyIdentifierItem, key) {
          if (key !== 0) {
            if (key === 1) {
              currentEntityInstance = $slatwall['new' + $scope.baseEntityName.replace('Slatwall', '')]();
              currentEntity = currentEntityInstance.metaData[propertyIdentifierArray[key]];
              title += $slatwall.getRBKey(prefix + baseEntityCfcName + '.' + propertyIdentifierItem);
            } else {
              var currentEntityInstance = $slatwall['new' + currentEntity.cfc.charAt(0).toUpperCase() + currentEntity.cfc.slice(1)]();
              currentEntity = currentEntityInstance.metaData[propertyIdentifierArray[key]];
              title += $slatwall.getRBKey(prefix + currentEntityInstance.metaData.className + '.' + currentEntity.name);
            }
            if (key < propertyIdentifierArray.length - 1) {
              title += ' | ';
            }
          }
        });
        return title;
      };
      $scope.addColumn = function(selectedProperty, closeDialog) {
        $log.debug('add Column');
        $log.debug(selectedProperty);
        if (selectedProperty.$$group === 'simple' || 'attribute') {
          $log.debug($scope.columns);
          if (angular.isDefined(selectedProperty)) {
            var column = {};
            column.title = getTitleFromPropertyIdentifier(selectedProperty.propertyIdentifier);
            column.propertyIdentifier = selectedProperty.propertyIdentifier;
            column.isVisible = true;
            column.isDeletable = true;
            if (angular.isDefined(selectedProperty.attributeID)) {
              column.attributeID = selectedProperty.attributeID;
              column.attributeSetObject = selectedProperty.attributeSetObject;
            }
            $scope.columns.push(column);
            $scope.saveCollection();
            if (angular.isDefined(closeDialog) && closeDialog === true) {
              $scope.addDisplayDialog.toggleDisplayDialog();
            }
          }
        }
      };
      $scope.selectBreadCrumb = function(breadCrumbIndex) {
        var removeCount = $scope.breadCrumbs.length - 1 - breadCrumbIndex;
        $scope.breadCrumbs.splice(breadCrumbIndex + 1, removeCount);
        $scope.selectedPropertyChanged(null);
      };
      var unbindBaseEntityAlias = $scope.$watch('baseEntityAlias', function(newValue, oldValue) {
        if (newValue !== oldValue) {
          $scope.breadCrumbs = [{
            entityAlias: $scope.baseEntityAlias,
            cfc: $scope.baseEntityAlias,
            propertyIdentifier: $scope.baseEntityAlias
          }];
          unbindBaseEntityAlias();
        }
      });
      $scope.selectedPropertyChanged = function(selectedProperty) {
        $log.debug('selectedPropertyChanged');
        $log.debug(selectedProperty);
        $scope.selectedProperty = selectedProperty;
      };
      jQuery(function($) {
        var panelList = angular.element($element).children('ul');
        panelList.sortable({
          handle: '.s-pannel-name',
          update: function(event, ui) {
            var tempColumnsArray = [];
            $('.s-pannel-name', panelList).each(function(index, elem) {
              var newIndex = $(elem).attr('j-column-index');
              var columnItem = $scope.columns[newIndex];
              tempColumnsArray.push(columnItem);
            });
            $scope.$apply(function() {
              $scope.columns = tempColumnsArray;
            });
            $scope.saveCollection();
          }
        });
      });
    }]
  };
}]);

//# sourceMappingURL=../../directives/collection/swdisplayoptions.js.map
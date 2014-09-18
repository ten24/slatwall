'use strict';
angular.module('slatwalladmin')
.directive('swDisplayItem', 
['$http',
'$compile',
'$templateCache',
'partialsPath',
'$log',
'slatwallService',
'collectionService',
'metadataService',
'$filter',
function($http,
$compile,
$templateCache,
partialsPath,
$log,
slatwallService,
collectionService,
metadataService,
$filter){
	return {
		require:'^swDisplayOptions',
		restrict: 'A',
		scope:{
			selectedProperty:"=",
			propertiesList:"=",
			breadCrumbs:"=",
			selectedPropertyChanged:"&"
			
		},
		templateUrl:partialsPath+"displayitem.html",
		link: function(scope, element,attrs,displayOptionsController){
			console.log('displayItem ');
			console.log(scope.selectedProperty);
			scope.showDisplayItem = false;
			
			scope.selectedDisplayOptionChanged = function(selectedDisplayOption){
				
				var breadCrumb = {
						entityAlias:scope.selectedProperty.name,
						cfc:scope.selectedProperty.cfc,
						propertyIdentifier:scope.selectedProperty.propertyIdentifier
				};
				console.log('add breadCrumb');
				console.log(breadCrumb);
				scope.breadCrumbs.push(breadCrumb);
				//scope.selectedProperty.selectedDisplayOption = selectedDisplayOption;
				console.log(selectedDisplayOption);
				scope.selectedPropertyChanged({selectedProperty:selectedDisplayOption});
			};
			
			scope.$watch('selectedProperty', function(selectedProperty) {
				if(angular.isDefined(selectedProperty)){
					if(selectedProperty === null){
						scope.showDisplayItem = false;
						return;
					}
					
					if(selectedProperty.$$group !== 'drilldown'){
						scope.showDisplayItem = false;
						return;
					}
					
					if(selectedProperty.$$group === 'drilldown'){
						if(angular.isUndefined(scope.propertiesList[selectedProperty.propertyIdentifier])){
							var filterPropertiesPromise = slatwallService.getFilterPropertiesByBaseEntityName(selectedProperty.cfc);
							filterPropertiesPromise.then(function(value){
								/*var breadCrumb = scope.breadCrumbs[scope.breadCrumbs.length - 1];
								console.log('breadCrumb');
								console.log(breadCrumb);*/
								metadataService.setPropertiesList(value,selectedProperty.propertyIdentifier);
								scope.propertiesList[selectedProperty.propertyIdentifier] = metadataService.getPropertiesListByBaseEntityAlias(selectedProperty.propertyIdentifier);
								metadataService.formatPropertiesList(scope.propertiesList[selectedProperty.propertyIdentifier],selectedProperty.propertyIdentifier);
								//var entityAliasArrayFromString = scope.filterItem.propertyIdentifier.split('.');
								//entityAliasArrayFromString.pop();
								
								//entityAliasArrayFromString = entityAliasArrayFromString.join('.').trim();
									/*for(var i in scope.filterPropertiesList[entityAliasArrayFromString].data){
										var filterProperty = scope.filterPropertiesList[entityAliasArrayFromString].data[i];
										if(filterProperty.propertyIdentifier === scope.filterItem.propertyIdentifier){
											//selectItem from drop down
											scope.selectedFilterProperty = filterProperty;
											//decorate with value and comparison Operator so we can use it in the Condition section
											scope.selectedFilterProperty.value = scope.filterItem.value;
											scope.selectedFilterProperty.comparisonOperator = scope.filterItem.comparisonOperator;
										}
									}*/
									
								//scope.selectedFilterPropertyChanged({selectedFilterProperty:scope.selectedFilterProperty.selectedCriteriaType});
							}, function(reason){
								
							});
						}
					}
					scope.showDisplayItem = true;
					console.log(selectedProperty);
					
				}
			});
		}
	};
}]);
	

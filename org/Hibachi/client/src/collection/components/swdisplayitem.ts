/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWDisplayItem{
	public static Factory():ng.IDirectiveFactory{
		var directive:ng.IDirectiveFactory = (
			$hibachi,
			collectionPartialsPath,
			metadataService,
			hibachiPathBuilder
		)=> new SWDisplayItem(
			$hibachi,
			collectionPartialsPath,
			metadataService,
			hibachiPathBuilder
		);
		directive.$inject = [
			'$hibachi',
			'collectionPartialsPath',
			'metadataService',
			'hibachiPathBuilder'
		];
		return directive
	}

	//@ngInject
	constructor(
		$hibachi,
		collectionPartialsPath,
		metadataService,
		hibachiPathBuilder
	){
		return{
			require:'^swDisplayOptions',
			restrict: 'A',
			scope:{
				selectedProperty:"=",
				propertiesList:"=",
				breadCrumbs:"=",
				selectedPropertyChanged:"&"

			},
			templateUrl:hibachiPathBuilder.buildPartialsPath(collectionPartialsPath)+"displayitem.html",
			link: function(scope, element,attrs,displayOptionsController){
				scope.showDisplayItem = false;

				scope.selectedDisplayOptionChanged = function(selectedDisplayOption){

					var breadCrumb = {
							entityAlias:scope.selectedProperty.name,
							cfc:scope.selectedProperty.cfc,
							propertyIdentifier:scope.selectedProperty.propertyIdentifier
					};
					scope.breadCrumbs.push(breadCrumb);
					scope.selectedPropertyChanged({selectedProperty:selectedDisplayOption});
				};

				scope.$watch('selectedProperty', function(selectedProperty) {
					if(angular.isDefined(selectedProperty)){

                        if(angular.isUndefined(scope.propertiesList[selectedProperty.propertyIdentifier])){
                            var filterPropertiesPromise = $hibachi.getFilterPropertiesByBaseEntityName(selectedProperty.cfc);
                            filterPropertiesPromise.then(function(value){
                                metadataService.setPropertiesList(value,selectedProperty.propertyIdentifier);
                                scope.propertiesList[selectedProperty.propertyIdentifier] = metadataService.getPropertiesListByBaseEntityAlias(selectedProperty.propertyIdentifier);
                                metadataService.formatPropertiesList(scope.propertiesList[selectedProperty.propertyIdentifier],selectedProperty.propertyIdentifier);
                            }, function(reason){

                            });
                        }
                    }
				});
			}
		}
	}
}
export{
	SWDisplayItem
}


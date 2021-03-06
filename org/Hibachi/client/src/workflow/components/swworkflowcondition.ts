/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWWorkflowCondition{
    
    public template = require("./workflowcondition.html");
    public restrict = 'E';
	public scope = {
    	workflowCondition:"=",
		workflowConditionIndex:"=",
		workflow:"=",
		filterPropertiesList:"="
	};
	
	public static Factory(){
		return /** @ngInject */ ($log, $hibachi, metadataService)=> new this($log, $hibachi, metadataService);
	}
	// @ngInject
	constructor(private $log, private $hibachi, private metadataService){}
	
	public link: ng.IDirectiveLinkFn = (scope, element,attrs) => {
	    this.$log.debug('workflowCondition init');
		this.$log.debug(scope);

		scope.selectBreadCrumb = (breadCrumbIndex) => {
			//splice out array items above index
			var removeCount = scope.filterItem.breadCrumbs.length - 1 - breadCrumbIndex;
			scope.filterItem.breadCrumbs.splice(breadCrumbIndex + 1,removeCount);
			scope.selectedFilterPropertyChanged(null);

		};

		scope.selectedFilterPropertyChanged = (selectedFilterProperty) => {
			this.$log.debug('selectedFilterProperty');
			this.$log.debug(selectedFilterProperty);

			scope.selectedFilterProperty = selectedFilterProperty;
		};
		
		if(angular.isUndefined(scope.workflowCondition.breadCrumbs) ){
			scope.workflowCondition.breadCrumbs = [];
			if(scope.workflowCondition.propertyIdentifier === ""){

				scope.workflowCondition.breadCrumbs = [{
             		entityAlias:scope.workflow.data.workflowObject,
             		cfc:scope.workflow.data.workflowObject,
             		propertyIdentifier:scope.workflow.data.workflowObject
             	}];
			}
			else {
				var entityAliasArrayFromString = scope.workflowCondition.propertyIdentifier.split('.');
				entityAliasArrayFromString.pop();
				for(var i in entityAliasArrayFromString){
					var breadCrumb = {
							entityAlias:entityAliasArrayFromString[i],
							cfc:entityAliasArrayFromString[i],
							propertyIdentifier:entityAliasArrayFromString[i]
					};
					scope.workflowCondition.breadCrumbs.push(breadCrumb);
				}
			}
		}
		else {
		    
			angular.forEach(scope.workflowCondition.breadCrumbs, (breadCrumb,key) => {
			    
				if(angular.isUndefined(scope.filterPropertiesList[breadCrumb.propertyIdentifier]) ){
				    
					var filterPropertiesPromise = this.$hibachi.getFilterPropertiesByBaseEntityName(breadCrumb.cfc, true);
					filterPropertiesPromise.then( (value) => {
						
						this.metadataService.setPropertiesList(value,breadCrumb.propertyIdentifier);
						scope.filterPropertiesList[breadCrumb.propertyIdentifier] = this.metadataService.getPropertiesListByBaseEntityAlias(breadCrumb.propertyIdentifier);
						this.metadataService.formatPropertiesList(scope.filterPropertiesList[breadCrumb.propertyIdentifier],breadCrumb.propertyIdentifier);
						var entityAliasArrayFromString = scope.workflowCondition.propertyIdentifier.split('.');
						entityAliasArrayFromString.pop();

						entityAliasArrayFromString = entityAliasArrayFromString.join('.').trim();
						if(angular.isDefined(scope.filterPropertiesList[entityAliasArrayFromString]) ){
							for(var i in scope.filterPropertiesList[entityAliasArrayFromString].data ){
								var filterProperty = scope.filterPropertiesList[entityAliasArrayFromString].data[i];
								if(filterProperty.propertyIdentifier === scope.workflowCondition.propertyIdentifier){
									//selectItem from drop down
									scope.selectedFilterProperty = filterProperty;
									//decorate with value and comparison Operator so we can use it in the Condition section
									scope.selectedFilterProperty.value = scope.workflowCondition.value;
									scope.selectedFilterProperty.comparisonOperator = scope.workflowCondition.comparisonOperator;
								}
							}
						}
					});
				}
				else {
					var entityAliasArrayFromString = scope.workflowCondition.propertyIdentifier.split('.');
					entityAliasArrayFromString.pop();

					entityAliasArrayFromString = entityAliasArrayFromString.join('.').trim();
					if(angular.isDefined(scope.filterPropertiesList[entityAliasArrayFromString]) ){
					    
						for(var i in scope.filterPropertiesList[entityAliasArrayFromString].data ){
							var filterProperty = scope.filterPropertiesList[entityAliasArrayFromString].data[i];
							if(filterProperty.propertyIdentifier === scope.workflowCondition.propertyIdentifier){
								//selectItem from drop down
								scope.selectedFilterProperty = filterProperty;
								//decorate with value and comparison Operator so we can use it in the Condition section
								scope.selectedFilterProperty.value = scope.workflowCondition.value;
								scope.selectedFilterProperty.comparisonOperator = scope.workflowCondition.comparisonOperator;
							}
						}
						
					}
				}

			});
		}
	}

}
export{
	SWWorkflowCondition
}




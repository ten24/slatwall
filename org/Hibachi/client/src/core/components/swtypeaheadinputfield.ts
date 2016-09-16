/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWTypeaheadInputFieldController {
    
    public fieldName:string; 
    public entityName:string;
    public typeaheadCollectionConfig; 
    public modelValue; 
    public columns = []; 
    public filters = [];
    public propertiesToLoad; 
    public placeholderRbKey;
    public propertyToSave;
    public propertyToShow;
    public initialEntityId:string; 
    public searchText:string;
    public validateRequired:boolean; 
    
    // @ngInject
	constructor(private $scope, 
                private $q, 
                private $transclude, 
                private $hibachi, 
                private $timeout:ng.ITimeoutService, 
                private utilityService, 
                private collectionConfigService
    ){
        
        if(angular.isDefined(this.entityName)){
            this.typeaheadCollectionConfig = collectionConfigService.newCollectionConfig(this.entityName); 
        }
        if(angular.isUndefined(this.propertyToSave)){
            throw("You must select a property to save for the input field directive")
        }
                  
        //get the collection config
        this.$transclude($scope,()=>{});
           
        if(angular.isDefined(this.propertiesToLoad)){
            this.typeaheadCollectionConfig.addDisplayProperty(this.propertiesToLoad);
        }
        
        angular.forEach(this.columns, (column)=>{
                this.typeaheadCollectionConfig.addDisplayProperty(column.propertyIdentifier, '', column);
        });
        
        angular.forEach(this.filters, (filter)=>{
                this.typeaheadCollectionConfig.addFilter(filter.propertyIdentifier, filter.comparisonValue, filter.comparisonOperator, filter.logicalOperator, filter.hidden);
        }); 
        
        if(angular.isDefined(this.initialEntityId) && this.initialEntityId.length){
            this.modelValue = this.initialEntityId;
        }
    }
    
    public addFunction = (value:any) => {
        this.modelValue = value[this.propertyToSave]; 
    }

}

class SWTypeaheadInputField implements ng.IDirective{

	public templateUrl;
    public transclude=true; 
	public restrict = "EA";
	public scope = {};
    public priority = 100;

	public bindToController = {
        fieldName:"@",
        entityName:"@",
        propertiesToLoad:"@?",
        placeholderRbKey:"@?",
        propertyToShow:"@",
        propertyToSave:"@",
        initialEntityId:"@",
        validateRequired:"@?"
	};
	public controller=SWTypeaheadInputFieldController;
	public controllerAs="swTypeaheadInputField";

    // @ngInject
	constructor(private corePartialsPath,hibachiPathBuilder){
		this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "typeaheadinputfield.html";
	}

	public static Factory(){
		var directive:ng.IDirectiveFactory = (
			corePartialsPath
            ,hibachiPathBuilder

		)=> new SWTypeaheadInputField(
            corePartialsPath
            ,hibachiPathBuilder
		);
		directive.$inject = ["corePartialsPath",'hibachiPathBuilder'];
		return directive;
	}
}
export{
	SWTypeaheadInputField,
	SWTypeaheadInputFieldController
}
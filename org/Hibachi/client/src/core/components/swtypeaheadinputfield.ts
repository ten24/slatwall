/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWTypeaheadInputFieldController {
    
    public fieldName; 
    public entityName;
    public typeaheadCollectionConfig; 
    public modelValue; 
    public displayList = []; 
    public propertiesToDisplay; 
    public placeholderRbKey;
    
    // @ngInject
	constructor(private $scope, private $q, private $transclude, private $hibachi, private $timeout:ng.ITimeoutService, private utilityService, private collectionConfigService){
       
        if(angular.isDefined(this.propertiesToDisplay)){
            var propertyArray = this.propertiesToDisplay.split(",");
            for(var i=0; i < propertyArray.length; i++){
                this.displayList.push({identifier:propertyArray[i], binding:"item."+propertyArray[i]});
            }
        }
        
        if(angular.isUndefined(this.entityName)){
            throw("The typeahead input field directive requires an entity name.");
        }
               
        this.typeaheadCollectionConfig = collectionConfigService.newCollectionConfig(this.entityName); 
    }
    
    public addFunction = (value:any) => {
        this.modelValue = value; 
    }

}

class SWTypeaheadInputField implements ng.IDirective{

	public static $inject=["$hibachi", "$timeout", "collectionConfigService", "corePartialsPath",
			'hibachiPathBuilder'];
	public templateUrl;
    public transclude=true; 
	public restrict = "EA";
	public scope = {};

	public bindToController = {
        fieldName:"@",
        entityName:"@",
        propertiesToDisplay:"@",
        placeholderRbKey:"@"
	};
	public controller=SWTypeaheadInputFieldController;
	public controllerAs="swTypeaheadInputField";

	constructor(private $hibachi, public $compile, private $timeout:ng.ITimeoutService, private utilityService, private collectionConfigService, private corePartialsPath,hibachiPathBuilder){
		this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "typeaheadinputfield.html";
	}

	public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any, controller:any, transclude:any) =>{
        
	};

	public static Factory(){
		var directive:ng.IDirectiveFactory = (
			$hibachi
            ,$compile
			,$timeout
            ,utilityService
			,collectionConfigService
			,corePartialsPath
            ,hibachiPathBuilder

		)=> new SWTypeaheadInputField(
			$hibachi
            ,$compile
			,$timeout
            ,utilityService
			,collectionConfigService
			,corePartialsPath
            ,hibachiPathBuilder
		);
		directive.$inject = ["$hibachi", "$compile", "$timeout", "utilityService", "collectionConfigService", "corePartialsPath",
			'hibachiPathBuilder'];
		return directive;
	}
}
export{
	SWTypeaheadInputField,
	SWTypeaheadInputFieldController
}

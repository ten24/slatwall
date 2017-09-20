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
    public action:string;
    public eventListeners;
    public variables;
    public titleText;
    private collectionConfig;
    private $root;
    
    // @ngInject
    constructor(private $scope,
                private $transclude,
                private collectionConfigService,
                private typeaheadService,
                private $rootScope,
                private observerService
    ){
        this.$root = $rootScope;

        if( angular.isUndefined(this.typeaheadCollectionConfig)){
            if(angular.isDefined(this.entityName)){
                this.typeaheadCollectionConfig = collectionConfigService.newCollectionConfig(this.entityName);
            } else {
                throw("You did not pass the correct collection config data to swTypeaheadInputField");
            }
        }
        
        if(angular.isUndefined(this.validateRequired)){
            this.validateRequired = false;
        }

        //get the collection config
        this.$transclude($scope,()=>{});

        if(angular.isUndefined(this.propertyToSave)){
            throw("You must select a property to save for the input field directive")
        }

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

        if(this.eventListeners){
            for(var key in this.eventListeners){
                observerService.attach(this.eventListeners[key], key)
            }
        }
    }
    
    public addFunction = (value:any) => {
        this.typeaheadService.typeaheadStore.dispatch({
            "type": "TYPEAHEAD_USER_SELECTION",
            "payload":{
                name: this.fieldName || "",
                data: value[this.propertyToSave] || ""
            }
        })
        this.modelValue = value[this.propertyToSave]; 

        if(this.action){
            var data = {};
            if(this.variables){
                data = this.variables();
            }
            data['value'] = this.modelValue;
            this.$root.slatwall.doAction(this.action, data);
        }
    }
}

class SWTypeaheadInputField implements ng.IDirective{

    public templateUrl;
    public transclude=true; 
    public restrict = "EA";
    public scope = {};

    public bindToController = {
        fieldName:"@",
        entityName:"@",
        typeaheadCollectionConfig:"=?",
        propertiesToLoad:"@?",
        placeholderRbKey:"@?",
        propertyToShow:"@",
        propertyToSave:"@",
        initialEntityId:"@",
        allRecords:"=?",
        validateRequired:"=?", 
        maxRecords:"@",
        action:"@",
        variables:'&?',
        eventListeners:'=?',
        placeholderText:'@?',
        searchEndpoint:'@?',
        titleText:'@?'
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

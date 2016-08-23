/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOptionsForOptionGroupController {
    
    public optionGroupId; 
    public optionCollectionConfig;
    public optionGroupCollectionConfig; 
    
    public optionGroup; 
    public options; 
    public usedOptions; 
    
    public selectedOption; 
 
    // @ngInject
    constructor(private $hibachi, private $timeout, 
                private collectionConfigService, 
                private observerService
    ){
        
        this.optionGroupCollectionConfig = collectionConfigService.newCollectionConfig("OptionGroup");
        this.optionGroupCollectionConfig.getEntity(this.optionGroupId).then((response)=>{
            this.optionGroup = response;
        });
        
        this.optionCollectionConfig = collectionConfigService.newCollectionConfig("Option");
        this.optionCollectionConfig.setDisplayProperties("optionID, optionName, optionGroup.optionGroupID");
        this.optionCollectionConfig.addFilter("optionGroup.optionGroupID", this.optionGroupId); 
        this.optionCollectionConfig.setOrderBy('sortOrder|ASC');
        this.optionCollectionConfig.setAllRecords(true); 
        
        this.optionCollectionConfig.getEntity().then((response)=>{
            this.options = response.records; 
        });	
    }
    
    public validateChoice = () => {
        this.observerService.notify("validateOptions", [this.selectedOption, this.optionGroup]);
    }
}

class SWOptionsForOptionGroup implements ng.IDirective{
    
    public templateUrl; 
    public restrict = "EA"; 
    public scope = {}	
    
    public bindToController = {
        optionGroupId:"@",
        usedOptions:"="
    }
    public controller=SWOptionsForOptionGroupController;
    public controllerAs="swOptionsForOptionGroup";
    
        public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
            $hibachi, 
            $timeout, 
            collectionConfigService, 
            observerService,
            optionGroupPartialsPath,
            slatwallPathBuilder
        ) => new SWOptionsForOptionGroup(
            $hibachi, 
            $timeout, 
            collectionConfigService, 
            observerService,
            optionGroupPartialsPath,
            slatwallPathBuilder
        );
        directive.$inject = [
            '$hibachi', 
            '$timeout', 
            'collectionConfigService',
            'observerService', 
            'optionGroupPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    }
    // @ngInject
    constructor(private $hibachi, private $timeout, 
                private collectionConfigService, 
                private observerService, private optionGroupPartialsPath, slatwallPathBuilder
    ){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(optionGroupPartialsPath) + "optionsforoptiongroup.html";	
    }

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{ 
    }
}

export {
    SWOptionsForOptionGroupController,
	SWOptionsForOptionGroup
};

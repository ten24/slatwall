/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class optionWithGroup {
    constructor(
        public optionID:string,
        public optionGroupID:string,
        public match:boolean
    ){
        
    }
    
    public toString = () => {
        return this.optionID;
    }
}

class SWAddOptionGroupController {
    
    public optionGroups;
    public optionGroupIds; 
    public productId; 
    public product; 
    public productTypeID; 
    public productCollectionConfig;
    public skuCollectionConfig;
    public skus; 
    public usedOptions; 
    public selection; 
    public selectedOptionList;
    public showValidFlag; 
    public showInvalidFlag; 
    
    // @ngInject
    constructor(private $hibachi, private $timeout, 
                private collectionConfigService, 
                private observerService,
                private utilityService
    ){
        
        this.optionGroupIds = this.optionGroups.split(",");
        this.optionGroupIds.sort(); 
        
        this.selection = [];
        
        this.showValidFlag = false; 
        this.showInvalidFlag = false;
        
        for(var i=0; i<this.optionGroupIds.length; i++){
            this.selection.push(new optionWithGroup("", this.optionGroupIds[i], false)); 
        } 
        
        
        this.productCollectionConfig = collectionConfigService.newCollectionConfig("Product");
        this.productCollectionConfig.addDisplayProperty("productID, productName, productType.productTypeID");
        
        this.productCollectionConfig.getEntity(this.productId).then((response)=>{
            
            this.product = response; 				
            this.productTypeID = response.productType_productTypeID;
            
            this.skuCollectionConfig = collectionConfigService.newCollectionConfig("Sku");
            this.skuCollectionConfig.addDisplayProperty("skuID, skuCode, product.productID"); 
            this.skuCollectionConfig.addFilter("product.productID", this.productId);
            this.skuCollectionConfig.setAllRecords(true);
            
            this.usedOptions = [];
            
            this.skuCollectionConfig.getEntity().then((response)=>{
                this.skus = response.records; 	
                angular.forEach(this.skus, (sku)=>{
                    
                    var optionCollectionConfig = collectionConfigService.newCollectionConfig("Option");
                    
                    optionCollectionConfig.addDisplayProperty("optionID, optionName, optionCode, optionGroup.optionGroupID");
                    optionCollectionConfig.setAllRecords(true);
                    optionCollectionConfig.addFilter("skus.skuID", sku.skuID);
                    
                    optionCollectionConfig.getEntity().then((response)=>{
                        this.usedOptions.push(
                            utilityService.arraySorter(response.records, ["optionGroup_optionGroupID"])
                        );
                    });
                });
            }); 
        }); 
        
        this.observerService.attach(this.validateOptions, "validateOptions");			
    }
    
    public getOptionList = () => {
        return this.utilityService.arrayToList(this.selection);  
    }
    
    public validateOptions = (args:Array<any>) => {

        this.addToSelection(args[0], args[1].optionGroupID); 		
        
        if( this.hasCompleteSelection() ){
            if(this.validateSelection()){
                this.selectedOptionList = this.getOptionList();
                this.showValidFlag = true; 
                this.showInvalidFlag = false; 
            } else { 
                this.showValidFlag = false; 
                this.showInvalidFlag = true; 
            }
        }
    }
    
    private validateSelection = () => {
        var valid = true; 
        angular.forEach(this.usedOptions, (combination) => {
            if(valid){
                var counter = 0;
                angular.forEach(combination, (usedOption) => {
                    if(this.selection[counter].optionGroupID === usedOption.optionGroup_optionGroupID
                        && this.selection[counter].optionID != usedOption.optionID
                    ){
                        this.selection[counter].match = true; 
                    }
                    counter++; 
                });
                if(!this.allSelectionFieldsValidForThisCombination()){
                    valid = false; 
                } 
            }
        }); 
        
        return valid; 
    }	
    
    private allSelectionFieldsValidForThisCombination = () =>{
        var matches = 0; 
        angular.forEach(this.selection, (pair)=>{
            if(!pair.match){
                matches++; 
            }
            //reset 
            pair.match = false; 
        }); 
        return matches != this.selection.length; 
    }
        
    private hasCompleteSelection = () =>{ 
        var answer = true; 
        angular.forEach(this.selection, (pair)=>{
            if(pair.optionID.length === 0){
                answer = false; 
            }
        });
        return answer;
    }
    
    private addToSelection = (optionId:string, optionGroupId:string) => { 
        angular.forEach(this.selection, (pair)=>{
            if(pair.optionGroupID === optionGroupId){
                pair.optionID = optionId; 
                return true; 
            }
        });
        return false; 
    }
    
}

class SWAddOptionGroup implements ng.IDirective{

    public templateUrl; 
    public restrict = "EA"; 
    public scope = {}	
    
    public bindToController = {
        productId:"@", 
        optionGroups:"="
    }
    public controller=SWAddOptionGroupController;
    public controllerAs="swAddOptionGroup";
     
    public static Factory():ng.IDirectiveFactory{
		var directive:ng.IDirectiveFactory = (
            $hibachi, 
            $timeout, 
            collectionConfigService,
            observerService,
			optionGroupPartialsPath,
			slatwallPathBuilder
		) => new SWAddOptionGroup(
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
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(optionGroupPartialsPath) + "addoptiongroup.html";	
    }

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{  
    }
}




export {
    optionWithGroup,
    SWAddOptionGroupController,
	SWAddOptionGroup
};
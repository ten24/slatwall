/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var md5 = require('md5');
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
    public optionCollectionConfig;
    public skus;
    public skuId;
    public usedOptions;
    public selection;
    public selectedOptionList;
    public showValidFlag;
    public showInvalidFlag;
    public skusProcessing;

    public possibleComboHashes;
    public savedOptions;

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

        //get current selections
        this.optionCollectionConfig = collectionConfigService.newCollectionConfig("Option");
        this.optionCollectionConfig.setDisplayProperties('optionID,optionGroup.optionGroupID');
        this.optionCollectionConfig.addFilter('skus.skuID',this.skuId);

        this.optionCollectionConfig.setAllRecords(true)
        this.optionCollectionConfig.getEntity().then((response)=>{
            this.savedOptions={};

            if(response.records){
                for(var kk in response.records){
                    var record = response.records[kk];
                    this.savedOptions[record['optionGroup_optionGroupID']]=record['optionID'];
                    this.addToSelection(record['optionID'], record['optionGroup_optionGroupID']);
                }
            }

        });

        this.observerService.attach(this.validateOptions, "validateOptions");
    }

    public getOptionList = () => {
        this.selection.sort();
        return this.utilityService.arrayToList(this.selection);
    }

    public validateOptions = (args:Array<any>) => {

        this.addToSelection(args[0], args[1].optionGroupId);

        if( this.hasCompleteSelection() ){
            this.validateSelection();
        }
    }

    private validateSelection = () => {

        var optionList = this.getOptionList();
        var validateSkuCollectionConfig = this.collectionConfigService.newCollectionConfig("Sku");
        if(this.optionGroupIds.length > 1){
            validateSkuCollectionConfig.addDisplayProperty("calculatedOptionsHash");
            validateSkuCollectionConfig.addFilter("product.productID", this.productId);
            validateSkuCollectionConfig.addFilter("skuID",this.skuId,"!=")
            validateSkuCollectionConfig.addFilter("calculatedOptionsHash",md5(optionList));
            validateSkuCollectionConfig.setAllRecords(true);
            validateSkuCollectionConfig.getEntity().then((response)=>{
                if(response.records && response.records.length == 0){
                    this.selectedOptionList = this.getOptionList();
                    this.showValidFlag = true;
                    this.showInvalidFlag = false;
                } else {
                    this.showValidFlag = false;
                    this.showInvalidFlag = true;
                }
            });
        }else{
            validateSkuCollectionConfig.addFilter("product.productID", this.productId);
            validateSkuCollectionConfig.addFilter("options.optionID",optionList);
            validateSkuCollectionConfig.setAllRecords(true);
            validateSkuCollectionConfig.getEntity().then((response)=>{
                if(response.records && response.records.length == 0){
                    this.selectedOptionList = this.getOptionList();
                    this.showValidFlag = true;
                    this.showInvalidFlag = false;
                } else {
                    this.showValidFlag = false;
                    this.showInvalidFlag = true;
                }
            });
        }
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
        skuId:"@",
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

    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
        // element used for when jquery is deleting DOM instead of angular such as a jQuery('#adminModal').html(html);
        element.on('$destroy', ()=> {
            this.observerService.detachByEvent('validateOptions');
        });
        scope.$on('$destroy', ()=> {
            this.observerService.detachByEvent('validateOptions');
        });
    }
}

export {
    optionWithGroup,
    SWAddOptionGroupController,
	SWAddOptionGroup
};
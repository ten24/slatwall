/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWTypeaheadMultiselectController {
      
    public selections:any[];
    public showSelections:boolean; 
    public singleSelection:any;
    public dataTarget:any; 
    public dataTargetIndex:number; 
    public placeholderRbKey:string;
    public typeaheadDataKey:string; 
    public multiselectMode:boolean;
    public collectionConfig:any; 
    public addButtonFunction; 
    public hasAddButtonFunction:boolean;
    public viewFunction;
    public hasViewFunction:boolean;
    public inListingDisplay:boolean; 
    public listingId:string; 
      
    // @ngInject
	constructor(private $scope, 
                private $transclude, 
                private $hibachi, 
                private listingService, 
                private typeaheadService,
                private utilityService, 
                private collectionConfigService
    ){
        //supporting the original selection view
        if(angular.isUndefined(this.showSelections)){
            this.showSelections = false; 
        }
        if(angular.isUndefined(this.multiselectMode)){
            this.multiselectMode = true; 
        }
        if(angular.isUndefined(this.typeaheadDataKey)){
            this.typeaheadDataKey = this.utilityService.createID(32); 
        }
        if(angular.isUndefined(this.hasAddButtonFunction)){
            this.hasAddButtonFunction = false; 
        }
        if(angular.isUndefined(this.hasViewFunction)){
            this.hasViewFunction = false; 
        }
    }
    
    //do these need to be passed in? 
    public addSelection = (item) => {
        this.typeaheadService.addSelection(this.typeaheadDataKey, item);
        if(this.inListingDisplay){
            this.listingService.insertListingPageRecord(this.listingId, item);
        }
    }
    
    public removeSelection = (index) => {
        var itemRemoved = this.typeaheadService.removeSelection(this.typeaheadDataKey, index);
        console.log("itemRemoved", itemRemoved)
        if(this.inListingDisplay){
            this.listingService.removeListingPageRecord(this.listingId, itemRemoved); 
        }
    }
    
    public getSelections = () =>{
        return this.typeaheadService.getData(this.typeaheadDataKey);
    }
}

class SWTypeaheadMultiselect implements ng.IDirective{

	public templateUrl;
    public transclude=true; 
	public restrict = "EA";
	public scope = {};

	public bindToController = {
        placeholderRbKey:"@"
        ,collectionConfig:"=?"
        ,typeaheadDataKey:"@?"
        ,multiselectModeOn:"=?multiselectMode"
        ,showSelections:"=?"
        ,dataTarget:"=?"
        ,dataTargetIndex:"=?"
        ,addButtonFunction:"&?" 
        ,viewFunction:"&?"
        ,inListingDisplay:"=?"
        ,listingId:"@?"
	};
    
	public controller=SWTypeaheadMultiselectController;
	public controllerAs="swTypeaheadMultiselect";

    // @ngInject
	constructor(public $compile, public scopeService, public typeaheadService, private corePartialsPath,hibachiPathBuilder){
		this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "typeaheadmultiselect.html";
	}

	public static Factory(){
		var directive:ng.IDirectiveFactory = (
            $compile
            ,scopeService
            ,typeaheadService
			,corePartialsPath
            ,hibachiPathBuilder

		)=> new SWTypeaheadMultiselect(
            $compile
            ,scopeService
            ,typeaheadService
            ,corePartialsPath
            ,hibachiPathBuilder
		);
		directive.$inject = ["$compile","scopeService","typeaheadService","corePartialsPath",'hibachiPathBuilder'];
		return directive;
	}
    
    public compile = (element: JQuery, attrs: angular.IAttributes, transclude: any) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: any) => {
                //because callbacks are defined even when they're not passed in, this needs to be communicated to the typeahead
                if(angular.isDefined(attrs.addButtonFunction)){
                    $scope.swTypeaheadMultiselect.hasAddButtonFunction = true;  
                } else {
                    $scope.swTypeaheadMultiselect.hasAddButtonFunction = false; 
                }
                
                if(angular.isDefined(attrs.viewFunction)){
                    $scope.swTypeaheadMultiselect.viewFunction = true;  
                } else {
                    $scope.swTypeaheadMultiselect.viewFunction = false; 
                }
                if(angular.isUndefined( $scope.swTypeaheadMultiselect.inListingDisplay)){
                    $scope.swTypeaheadMultiselect.inListingDisplay = false; 
                }
                if($scope.swTypeaheadMultiselect.inListingDisplay && this.scopeService.hasParentScope($scope, "swListingDisplay")) {
                    $scope.swTypeaheadMultiselect.listingId = this.scopeService.locateParentScope( $scope, "swListingDisplay").tableID;
                }
            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
                
				var target = element.find(".s-selected-list");
                var selectedItemTemplate  = angular.element('<div class="alert s-selected-item" ng-repeat="item in swTypeaheadMultiselect.getSelections() track by $index">');
                var closeButton = angular.element('<button ng-click="swTypeaheadMultiselect.removeSelection($index)" type="button" class="close"><span>×</span><span class="sr-only" sw-rbkey="&apos;define.close&apos;"></span></button>'); 
				
               selectedItemTemplate.append(closeButton);
               selectedItemTemplate.append(this.typeaheadService.stripTranscludedContent(transclude($scope,()=>{})));
               target.append(this.$compile(selectedItemTemplate)($scope));               
            }
        };
    }
}
export{
	SWTypeaheadMultiselect,
	SWTypeaheadMultiselectController
}

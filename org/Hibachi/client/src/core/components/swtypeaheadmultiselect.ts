/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWTypeaheadMultiselectController {
      
    public selections:any[];
    public singleSelection:any;
    public placeholderRbKey:string;
    public multiselectModeOn:boolean;
      
    // @ngInject
	constructor(private $scope, 
                private $q, 
                private $transclude, 
                private $hibachi, 
                private $timeout:ng.ITimeoutService, 
                private utilityService, 
                private collectionConfigService
    ){
        this.selections = [];
        if(angular.isUndefined(this.multiselectModeOn)){
            this.multiselectModeOn = true; 
        }
    }
    
    public addSelection = (item) => {
        if(this.multiselectModeOn){
            this.selections.push(item);
        } else  {
            this.singleSelection = item;
        }
    }
    
    public removeSelection = (index) => {
        if(this.multiselectModeOn){
            this.selections.splice(index,1);
        } else {
            this.singleSelection = null;
        }
    }
}

class SWTypeaheadMultiselect implements ng.IDirective{

	public templateUrl;
    public transclude=true; 
	public restrict = "EA";
	public scope = {};

	public bindToController = {
        placeholderRbKey:"@",
        multiselectModeOn:"=?"
	};
    
	public controller=SWTypeaheadMultiselectController;
	public controllerAs="swTypeaheadMultiselect";

    // @ngInject
	constructor(public $compile, private corePartialsPath,hibachiPathBuilder){
		this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "typeaheadmultiselect.html";
	}

	public static Factory(){
		var directive:ng.IDirectiveFactory = (
            $compile,
			corePartialsPath
            ,hibachiPathBuilder

		)=> new SWTypeaheadMultiselect(
            $compile,
            corePartialsPath
            ,hibachiPathBuilder
		);
		directive.$inject = ["$compile","corePartialsPath",'hibachiPathBuilder'];
		return directive;
	}
    
    public compile = (element: JQuery, attrs: angular.IAttributes, transclude: any) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {},
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
                
				var target = element.find(".s-selected-list");
                var selectedItemTemplate  = angular.element('<div class="alert s-selected-item" ng-repeat="item in swTypeaheadMultiselect.selections track by $index">');
                var closeButton = angular.element('<button ng-click="swTypeaheadMultiselect.removeSelection($index)" type="button" class="close"><span>×</span><span class="sr-only" sw-rbkey="&apos;define.close&apos;"></span></button>'); 
                var transcludeContent = transclude($scope,()=>{});
                
				//strip out the ng-transclude if this typeahead exists inside typeaheadinputfield directive
				for(var i=0; i < transcludeContent.length; i++){
					if(angular.isDefined(transcludeContent[i].localName) && 
					transcludeContent[i].localName == 'ng-transclude'
					){
						transcludeContent = transcludeContent.children();
					}
				}
				
				//prevent collection config from being recompiled
				for(var i=0; i < transcludeContent.length; i++){
					if(angular.isDefined(transcludeContent[i].localName) && 
					transcludeContent[i].localName == 'sw-collection-config'
					){
						transcludeContent.splice(i,1);
					}
				}
               selectedItemTemplate.append(closeButton);
               selectedItemTemplate.append(transcludeContent);
               target.append(this.$compile(selectedItemTemplate)($scope));

                
            }
        };
    }
}
export{
	SWTypeaheadMultiselect,
	SWTypeaheadMultiselectController
}
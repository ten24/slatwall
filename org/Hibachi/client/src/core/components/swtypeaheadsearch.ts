/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWTypeaheadSearchController {

	public collectionConfig; 
	public entity:string;
	public properties:string;
	public propertiesToDisplay:string;
	public filterGroupsConfig:any;
	public allRecords:boolean;
	public placeholderText:string;
	public searchText:string;
	public results;
	public addFunction;
    public validateRequired:boolean; 
    public displayList = [];
	public addButtonFunction;
	public hideSearch:boolean;
	public clickOutsideArguments;
    public resultsPromise;
    public resultsDeferred; 
    
	private _timeoutPromise; 
	private entityList;
	private typeaheadCollectionConfig;
	private typeaheadCollectionConfigs;
    
    // @ngInject
	constructor(private $scope, private $q, private $transclude, private $hibachi, private $timeout:ng.ITimeoutService, private utilityService, private collectionConfigService){

        this.resultsDeferred = $q.defer();
        this.resultsPromise = this.resultsDeferred.promise;
        
        if(angular.isUndefined(this.searchText)){
            this.searchText = "";
        }
        
        if(angular.isUndefined(this.results)){
            this.results = []; 
        }
        
        if(angular.isUndefined(this.validateRequired)){
            this.validateRequired = false; 
        }
        if(angular.isUndefined(this.hideSearch)){ 
            this.hideSearch = true; 
        }

        if(angular.isDefined(this.collectionConfig)){
            this.typeaheadCollectionConfig = this.collectionConfig; 
        } else if (angular.isDefined(this.entity)){ 
            this.typeaheadCollectionConfig = collectionConfigService.newCollectionConfig(this.entity);
        } else { 
            throw("You did not pass the correct collection config data to swTypeaheadSearch");
        }
        
		if(angular.isDefined(this.propertiesToDisplay)){
			this.displayList = this.propertiesToDisplay.split(",");
		} 

        //init timeoutPromise for link
        this._timeoutPromise = this.$timeout(()=>{},500);

        //populate the displayList
        this.$transclude = this.$transclude;
        this.$transclude($scope,()=>{});
        
        this.typeaheadCollectionConfig.addDisplayProperty(this.utilityService.arrayToList(this.displayList));

		if(angular.isDefined(this.allRecords)){
			this.typeaheadCollectionConfig.setAllRecords(this.allRecords);
		} else {
			this.typeaheadCollectionConfig.setAllRecords(true);
		}
	}
    
    public clearSearch = () =>{
        this.searchText = "";
        this.hideSearch = true; 
    }
    
    public toggleOptions = () =>{
        if(this.hideSearch && !this.searchText.length){
            this.search(this.searchText); 
        } else { 
            this.hideSearch = !this.hideSearch; 
        }
    }

	public search = (search:string)=>{
        if(this._timeoutPromise){
			this.$timeout.cancel(this._timeoutPromise);
		}

        this.typeaheadCollectionConfig.setKeywords(search);

        if(angular.isDefined(this.filterGroupsConfig)){
            //allows for filtering on search text
            var filterConfig = this.filterGroupsConfig.replace("replaceWithSearchString", search);
            filterConfig = filterConfig.trim();
            this.typeaheadCollectionConfig.loadFilterGroups(JSON.parse(filterConfig));
        }
         
        this._timeoutPromise = this.$timeout(()=>{

            var promise = this.typeaheadCollectionConfig.getEntity();

            promise.then( (response) =>{
                if(angular.isDefined(this.allRecords) && this.allRecords == false){
                    this.results = response.pageRecords;
                } else {
                    this.results = response.records;
                }
            }).finally(()=>{
                this.resultsDeferred.resolve();
                this.hideSearch = (this.results.length == 0);
            });
        }, 500);
	}

	public addItem = (item)=>{

		if(!this.hideSearch){
			this.hideSearch = true;
		}

		if(angular.isDefined(this.displayList)){
			this.searchText = item[this.displayList[0]];
		}
        
		if(angular.isDefined(this.addFunction)){
			this.addFunction()(item);
		}
	}

	public addButtonItem = ()=>{

		if(!this.hideSearch){
			this.hideSearch = true;
		}
        
		if(angular.isDefined(this.addButtonFunction)){
			this.addButtonFunction()(this.searchText);
		}
	}

	public closeThis = (clickOutsideArgs) =>{

		this.hideSearch = true;

		if(angular.isDefined(clickOutsideArgs)){
			for(var callBackAction in clickOutsideArgs.callBackActions){
				clickOutsideArgs.callBackActions[callBackAction]();
			}
		}

	};

}

class SWTypeaheadSearch implements ng.IDirective{

	public static $inject=["$hibachi", "$timeout", "collectionConfigService", "corePartialsPath",
			'hibachiPathBuilder'];
	public templateUrl;
    public transclude=true; 
	public restrict = "EA";
	public scope = {}

	public bindToController = {
        collectionConfig:"=?",
		entity:"@?",
		properties:"@?",
		propertiesToDisplay:"@?",
		filterGroupsConfig:"@?",
		placeholderText:"@?",
		searchText:"=?",
		results:"=?",
		addFunction:"&?",
		addButtonFunction:"&?",
        validateRequired:"=?",
        clickOutsideArguments:"=?",
		hideSearch:"=?"
	}
	public controller=SWTypeaheadSearchController;
	public controllerAs="swTypeaheadSearch";

	constructor(private $hibachi, public $compile, private $timeout:ng.ITimeoutService, private utilityService, private collectionConfigService, private corePartialsPath,hibachiPathBuilder){
		this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "typeaheadsearch.html";
	}

	public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any, controller:any, transclude:any) =>{
        var target = element.find(".dropdown-menu");
        var listItemTemplate = angular.element('<li ng-repeat="item in swTypeaheadSearch.results"></li>');
        var actionTemplate = angular.element('<a ng-click="swTypeaheadSearch.addItem(item)" ></a>');
        var transcludeContent = transclude(scope,()=>{});
        actionTemplate.append(transcludeContent); 
        listItemTemplate.append(actionTemplate); 
        
        scope.swTypeaheadSearch.resultsPromise.then(()=>{
            target.append(this.$compile(listItemTemplate)(scope));
        });
	}
    
 

	public static Factory(){
		var directive:ng.IDirectiveFactory = (
			$hibachi
            ,$compile
			,$timeout
            ,utilityService
			,collectionConfigService
			,corePartialsPath
            ,hibachiPathBuilder

		)=> new SWTypeaheadSearch(
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
	SWTypeaheadSearch,
	SWTypeaheadSearchController
}

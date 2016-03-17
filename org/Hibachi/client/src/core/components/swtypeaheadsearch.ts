/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWTypeaheadSearchController {

	public collectionConfig; 
	public entity:string;
	public properties:string;
	public propertiesToDisplay:string;
	public filterGroupsConfig:any;
	public allRecords:boolean;
	public searchText:string;
	public results;
	public addFunction;
    public validateRequired:boolean; 
    public displayList = [];
    public filters = [];
	public addButtonFunction;
    public viewFunction;
	public hideSearch:boolean;
    public resultsPromise;
    public resultsDeferred;
    public showAddButton;
    public placeholderText:string;
    public placeholderRbKey:string;

	private _timeoutPromise;
    public showViewButton;

    // @ngInject
	constructor(private $scope, private $q, private $transclude, private $hibachi, private $timeout:ng.ITimeoutService, private utilityService, private rbkeyService, private collectionConfigService){

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

        if(angular.isUndefined(this.collectionConfig)){
            if(angular.isDefined(this.entity)){
                this.collectionConfig = collectionConfigService.newCollectionConfig(this.entity);
            } else {
                throw("You did not pass the correct collection config data to swTypeaheadSearch");
            }
        }
        
        if(angular.isDefined(this.placeholderRbKey)){
            this.placeholderText = this.rbkeyService.getRBKey(this.placeholderRbKey);
        }

        if(angular.isDefined(this.addButtonFunction)){
            this.showAddButton = true;
        }

        if(angular.isDefined(this.viewFunction)){
            this.showViewButton = true;
        }

        //init timeoutPromise for link
        this._timeoutPromise = this.$timeout(()=>{},500);

        //populates the displayList and filters
        this.$transclude($scope,()=>{});

        if(angular.isDefined(this.propertiesToDisplay)){
            this.displayList = this.propertiesToDisplay.split(",");
        }
        
        if(this.displayList.length){
            this.collectionConfig.addDisplayProperty(this.utilityService.arrayToList(this.displayList));
        }
        angular.forEach(this.filters, (filter)=>{
                this.collectionConfig.addFilter(filter.propertyIdentifier, filter.comparisonValue, filter.comparisonOperator, filter.logicalOperator, filter.hidden);
        }); 

        if(angular.isDefined(this.allRecords)){
			this.collectionConfig.setAllRecords(this.allRecords);
		} else {
			this.collectionConfig.setAllRecords(true);
		}
	}

    public clearSearch = () =>{
        this.searchText = "";
        this.hideSearch = true;
        if(angular.isDefined(this.addFunction)){
            this.addFunction()(undefined);
        }
    };

    public toggleOptions = () =>{
        if(this.hideSearch && !this.searchText.length){
            this.search(this.searchText);
        } else {
            this.hideSearch = !this.hideSearch;
        }
    };

	public search = (search:string)=>{
        if(this._timeoutPromise){
			this.$timeout.cancel(this._timeoutPromise);
		}

        this.collectionConfig.setKeywords(search);

        if(angular.isDefined(this.filterGroupsConfig)){
            //allows for filtering on search text
            var filterConfig = this.filterGroupsConfig.replace("replaceWithSearchString", search);
            filterConfig = filterConfig.trim();
            this.collectionConfig.loadFilterGroups(JSON.parse(filterConfig));
        }

        this._timeoutPromise = this.$timeout(()=>{

            var promise = this.collectionConfig.getEntity();

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
	};

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
	};

	public addButtonItem = ()=>{

		if(!this.hideSearch){
			this.hideSearch = true;
		}

		if(angular.isDefined(this.addButtonFunction)){
			this.addButtonFunction()(this.searchText);
		}
	};

    public viewButtonClick = () =>{
        this.viewFunction()();
    };

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
	public scope = {};
    public terminal=true;

	public bindToController = {
        collectionConfig:"=?",
		entity:"@?",
		properties:"@?",
		propertiesToDisplay:"@?",
        displayList:"=?",
		filterGroupsConfig:"@?",
		placeholderText:"@?",
        placeholderRbKey:"@?",
		searchText:"=?",
		results:"=?",
		addFunction:"&?",
		addButtonFunction:"&?",
        viewFunction:"&?",
        validateRequired:"=?",
        clickOutsideArguments:"=?",
		hideSearch:"=?",
        disabled:"=?"
	};
	public controller=SWTypeaheadSearchController;
	public controllerAs="swTypeaheadSearch";

	constructor(private $hibachi, public $compile, private $timeout:ng.ITimeoutService, private utilityService, private collectionConfigService, private corePartialsPath,hibachiPathBuilder){
		this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "typeaheadsearch.html";
	}
    
    public compile = (element: JQuery, attrs: angular.IAttributes, transclude: any) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
                
            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
                var target = element.find(".dropdown-menu");
                var listItemTemplate = angular.element('<li ng-repeat="item in swTypeaheadSearch.results"></li>');
                var actionTemplate = angular.element('<a ng-click="swTypeaheadSearch.addItem(item)" ></a>');
                var transcludeContent = transclude($scope,()=>{});
                //strip out the ng-transclude if this typeahead exists inside typeaheadinputfield directive
                if(angular.isDefined(transcludeContent[1]) && angular.isDefined(transcludeContent[1].localName) && transcludeContent[1].localName == 'ng-transclude'){
                    transcludeContent = transcludeContent.children();
                }
                actionTemplate.append(transcludeContent); 
                listItemTemplate.append(actionTemplate); 
                $scope.swTypeaheadSearch.resultsPromise.then(()=>{
                    target.append(this.$compile(listItemTemplate)($scope));
                });
            }
        };
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

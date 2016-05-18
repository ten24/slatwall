/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWTypeaheadSearchController {

	public collectionConfig; 
	public entity:string;
	public properties:string;
	public propertiesToDisplay:string;
	public filterGroupsConfig:any;
	public allRecords:boolean;
	public maxRecords; 
	public searchText:string;
	public results;
	public addFunction;
    public validateRequired:boolean; 
    public columns = [];
    public filters = [];
	public addButtonFunction;
    public viewFunction;
	public hideSearch:boolean;
    public resultsPromise;
    public resultsDeferred;
    public showAddButton;
	public propertyToShow; 
    public placeholderText:string;
    public placeholderRbKey:string;

	private _timeoutPromise;
    public showViewButton;

    // @ngInject
	constructor(private $scope, 
                private $q,
                private $transclude, 
                private $hibachi, 
                private $timeout:ng.ITimeoutService, 
                private utilityService, 
                private rbkeyService, 
                private collectionConfigService
     ){
       
        //populates all needed variables
        this.$transclude($scope,()=>{});

        this.resultsDeferred = $q.defer();
        this.resultsPromise = this.resultsDeferred.promise;

        if(angular.isUndefined(this.searchText) || this.searchText == null){
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
        } else if (angular.isUndefined(this.placeholderText)){
            this.placeholderText = this.rbkeyService.getRBKey('define.search');
        }

        if(angular.isDefined(this.addButtonFunction)){
			console.warn("there is an add button function")
            this.showAddButton = true;
        }

        if(angular.isDefined(this.viewFunction)){
            this.showViewButton = true;
        }

        //init timeoutPromise for link
        this._timeoutPromise = this.$timeout(()=>{},500);

        if(angular.isDefined(this.propertiesToDisplay)){
            this.collectionConfig.addDisplayProperty(this.propertiesToDisplay.split(","));
        }
        
        angular.forEach(this.columns, (column)=>{
                this.collectionConfig.addDisplayProperty(column.propertyIdentifier, '', column);
        });
        
        angular.forEach(this.filters, (filter)=>{
                this.collectionConfig.addFilter(filter.propertyIdentifier, filter.comparisonValue, filter.comparisonOperator, filter.logicalOperator, filter.hidden);
        }); 

        if(angular.isDefined(this.allRecords)){
			this.collectionConfig.setAllRecords(this.allRecords);
		} else {
			this.collectionConfig.setAllRecords(true);
		}
		
		if(angular.isDefined(this.maxRecords)){
			this.collectionConfig.setPageShow(this.maxRecords);
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

		if(angular.isDefined(this.propertyToShow)){
			this.searchText = item[this.propertyToShow];
		} else if(angular.isDefined(this.columns) && 
           this.columns.length && 
           angular.isDefined(this.columns[0].propertyIdentifier)
        ){
			this.searchText = item[this.columns[0].propertyIdentifier];
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

	public templateUrl;
    public transclude=true; 
	public restrict = "EA";
	public scope = {};

	public bindToController = {
        collectionConfig:"=?",
		entity:"@?",
		properties:"@?",
		propertiesToDisplay:"@?",
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
		propertyToShow:"=?",
		hideSearch:"=?",
		allRecords:"=?",
		maxRecords:"=?",
        disabled:"=?"
	};
	public controller=SWTypeaheadSearchController;
	public controllerAs="swTypeaheadSearch";
    
    // @ngInject
	constructor(public $compile, private corePartialsPath,hibachiPathBuilder){
		this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "typeaheadsearch.html";
	}
    
    public compile = (element: JQuery, attrs: angular.IAttributes, transclude: any) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {},
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
                
				var target = element.find(".dropdown-menu");
                var listItemTemplate = angular.element('<li ng-repeat="item in swTypeaheadSearch.results"></li>');
                var actionTemplate = angular.element('<a ng-click="swTypeaheadSearch.addItem(item)" ></a>');
                var transcludeContent = transclude($scope,()=>{});
                
				//strip out the ng-transclude if this typeahead exists inside typeaheadinputfield directive (causes infinite compilation error)
				for(var i=0; i < transcludeContent.length; i++){
					if(angular.isDefined(transcludeContent[i].localName) && 
					transcludeContent[i].localName == 'ng-transclude'
					){
						transcludeContent = transcludeContent.children();
					}
				}
				
				//prevent collection config from being recompiled  (also causes infinite compilation error)
				for(var i=0; i < transcludeContent.length; i++){
					if(angular.isDefined(transcludeContent[i].localName) && 
					transcludeContent[i].localName == 'sw-collection-config'
					){
						transcludeContent.splice(i,1);
					}
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
            $compile
			,corePartialsPath
            ,hibachiPathBuilder

		)=> new SWTypeaheadSearch(
            $compile
			,corePartialsPath
            ,hibachiPathBuilder
		);
		directive.$inject = ["$compile","corePartialsPath",
			'hibachiPathBuilder'];
		return directive;
	}
}
export{
	SWTypeaheadSearch,
	SWTypeaheadSearchController
}
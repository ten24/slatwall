/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWTypeaheadSearchController {

	public collectionConfig:any; 
	public entity:string;
	public properties:string;
	public propertiesToDisplay:string;
	public filterGroupsConfig:any;
	public allRecords:boolean;
	public maxRecords; 
	public searchText:string;
	public results:any[];
    public validateRequired:boolean; 
    public columns = [];
    public filters = [];
    public addFunction;
	public addButtonFunction;
    public viewFunction;
	public hideSearch:boolean;
    public resultsPromise;
    public resultsDeferred;
    public multiselectMode:boolean; 
    public multiselectSelections:any[];
    public showAddButton:boolean;
    public showViewButton:boolean;
    public primaryIDPropertyName:string;
	public propertyToShow:string; 
    public placeholderText:string;
    public placeholderRbKey:string;
    public initialEntityId:string;
    public initialEntityCollectionConfig:any; 

	private _timeoutPromise;
    
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
        } else {
            this.search(this.searchText);
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
        if(angular.isDefined(this.collectionConfig)){
            this.primaryIDPropertyName = $hibachi.getPrimaryIDPropertyNameByEntityName(this.collectionConfig.baseEntityName);
        }
        
        if(angular.isDefined(this.placeholderRbKey)){
            this.placeholderText = this.rbkeyService.getRBKey(this.placeholderRbKey);
        } else if (angular.isUndefined(this.placeholderText)){
            this.placeholderText = this.rbkeyService.getRBKey('define.search');
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

        if(angular.isUndefined(this.allRecords)){
			this.allRecords = this.collectionConfig.allRecords;
		}

        this.collectionConfig.setAllRecords(this.allRecords);
		
		if(angular.isDefined(this.maxRecords)){
			this.collectionConfig.setPageShow(this.maxRecords);
		}
        
        if(angular.isDefined(this.initialEntityId) && this.initialEntityId.length){
            this.initialEntityCollectionConfig = collectionConfigService.newCollectionConfig(this.collectionConfig.baseEntityName);
            this.initialEntityCollectionConfig.loadColumns(this.collectionConfig.columns);
            var primaryIDProperty = $hibachi.getPrimaryIDPropertyNameByEntityName(this.initialEntityCollectionConfig.baseEntityName);
            this.initialEntityCollectionConfig.addFilter(primaryIDProperty,this.initialEntityId,"=");
           
            var promise = this.initialEntityCollectionConfig.getEntity();
            promise.then( (response) =>{
                this.results = response.pageRecords;
                if(this.results.length){
                    this.addItem(this.results[0]); 
                }
            });
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
        }
        this.hideSearch = !this.hideSearch;
        
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
                this.results = response.pageRecords || response.records;
                //check to see if we have any selections
                if(angular.isDefined(this.multiselectSelections) && this.multiselectSelections.length){
                    for(var j = 0; j < this.results.length; j++){
                        for(var i = 0; i < this.multiselectSelections.length; i++){
                            if(this.multiselectSelections[i][this.primaryIDPropertyName] == this.results[j][this.primaryIDPropertyName]){
                                this.results[j].selected = true;
                            }
                        }
                    }
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
        showAddButton:"=?",
        showViewButton:"=?",
        validateRequired:"=?",
        clickOutsideArguments:"=?",
		propertyToShow:"=?",
		hideSearch:"=?",
		allRecords:"=?",
		maxRecords:"=?",
        disabled:"=?",
        initialEntityId:"@",
        multiselectMode:"=?",
        multiselectSelections:"=?"
	};
	public controller=SWTypeaheadSearchController;
	public controllerAs="swTypeaheadSearch";
    
    // @ngInject
	constructor(public $compile, public typeaheadService, private corePartialsPath,hibachiPathBuilder){
		this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "typeaheadsearch.html";
	}
    
    public compile = (element: JQuery, attrs: angular.IAttributes, transclude: any) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: any) => {
                if(angular.isDefined(attrs.addButtonFunction) && angular.isUndefined(attrs.showAddButton)){
                    $scope.swTypeaheadSearch.showAddButton = true;  
                } else if(angular.isUndefined(attrs.showAddButton)) {
                    $scope.swTypeaheadSearch.showAddButton = false; 
                }
                
                if(angular.isDefined(attrs.viewFunction) && angular.isUndefined(attrs.showViewButton)){
                    $scope.swTypeaheadSearch.showViewButton = true;  
                } else if(angular.isUndefined(attrs.showViewButton)) {
                    $scope.swTypeaheadSearch.showViewButton = false; 
                }   
            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
                
				var target = element.find(".dropdown-menu");
                var listItemTemplateString = `
                    <li ng-repeat="item in swTypeaheadSearch.results" ng-class="{'s-selected':item.selected}"></li>
                `;
                
                var listItemTemplate = angular.element(listItemTemplateString);
                var actionTemplate = angular.element('<a ng-click="swTypeaheadSearch.addItem(item)"></a>');
               
                actionTemplate.append(this.typeaheadService.stripTranscludedContent(transclude($scope,()=>{}))); 
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
            ,typeaheadService
			,corePartialsPath
            ,hibachiPathBuilder

		)=> new SWTypeaheadSearch(
            $compile
            ,typeaheadService
			,corePartialsPath
            ,hibachiPathBuilder
		);
		directive.$inject = ["$compile","typeaheadService","corePartialsPath",
			'hibachiPathBuilder'];
		return directive;
	}
}
export{
	SWTypeaheadSearch,
	SWTypeaheadSearchController
}
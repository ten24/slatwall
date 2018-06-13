/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {PublicRequest} from "../model/transient/publicrequest";

class SWTypeaheadSearchController {

    public collectionConfig:any; 
    public disabled:boolean; 
    public entity:string;
    public properties:string;
    public propertiesToDisplay:string;
    public filterGroupsConfig:any;
    public allRecords:boolean;
    public maxRecords:number; 
    public searchText:string;
    public results:any[] = [];
    public validateRequired:boolean; 
    public uniqueResults:boolean;
    public columns:any[] = [];
    public filters:any[] = [];
    public addFunction;
    public removeFunction;
    public addButtonFunction;
    public viewFunction;
    public hideSearch:boolean;
    public resultsPromise;
    public resultsDeferred;
    public multiselectMode:boolean; 
    public searchableColumns:any[] = []; 
    public initialSearchableColumnsState:any[] = []; 
    public searchableColumnSelection:string='All';
    public showAddButton:boolean;
    public showViewButton:boolean;
    public typeaheadDataKey:string; 
    public primaryIDPropertyName:string;
    public propertyToShow:string; 
    public propertyToCompare:string; 
    public fallbackPropertiesToCompare:string; 
    public fallbackPropertyArray:any[] = [];
    public placeholderText:string;
    public placeholderRbKey:string;
    public initialEntityId:string;
    public initialEntityCollectionConfig:any; 
    public dropdownOpen:boolean;
    public searchEndpoint;
    public titleText;
    public loading:boolean;
    public searchOnLoad:boolean;

    private _timeoutPromise;
    
    // @ngInject
    constructor(private $scope, 
                private $q,
                private $transclude, 
                private $hibachi, 
                private $timeout:ng.ITimeoutService, 
                private utilityService, 
                private observerService, 
                private rbkeyService, 
                private collectionConfigService,
                private typeaheadService,
                private $http,
                private requestService
     ){
        this.dropdownOpen = false;
        
           this.requestService = requestService;
        //populates all needed variables
        this.$transclude($scope,()=>{});

        this.resultsDeferred = $q.defer();
        this.resultsPromise = this.resultsDeferred.promise;

        if( angular.isUndefined(this.typeaheadDataKey)){
            this.typeaheadDataKey = this.utilityService.createID(32); 
        }

        if( angular.isUndefined(this.disabled)){
            this.disabled = false; 
        }

        if( angular.isUndefined(this.multiselectMode)){
            this.multiselectMode = false; 
        }
        
        if( angular.isUndefined(this.searchOnLoad)){
            this.searchOnLoad = true; 
        }

        if( angular.isUndefined(this.searchText) || this.searchText == null){
            this.searchText = "";
        
        } else if( this.searchOnLoad ){
    
            this.search(this.searchText);
        }

        if( angular.isUndefined(this.validateRequired)){
            this.validateRequired = false;
        }
        if( angular.isUndefined(this.hideSearch)){
            this.hideSearch = true;
        }

        if( angular.isUndefined(this.collectionConfig)){
            if(angular.isDefined(this.entity)){
                this.collectionConfig = collectionConfigService.newCollectionConfig(this.entity);
            } else {
                throw("You did not pass the correct collection config data to swTypeaheadSearch");
            }
        }
        if( angular.isDefined(this.collectionConfig)){
            this.primaryIDPropertyName = $hibachi.getPrimaryIDPropertyNameByEntityName(this.collectionConfig.baseEntityName);
        }

        if( angular.isDefined(this.fallbackPropertiesToCompare) &&
            this.fallbackPropertiesToCompare.length
        ){
            this.fallbackPropertyArray = this.fallbackPropertiesToCompare.split(",")
        }

        if( angular.isDefined(this.placeholderRbKey)){
            this.placeholderText = this.rbkeyService.getRBKey(this.placeholderRbKey);
        } else if (angular.isUndefined(this.placeholderText)){
            this.placeholderText = this.rbkeyService.getRBKey('define.search');
        }

        //init timeoutPromise for link
        this._timeoutPromise = this.$timeout(()=>{},500);

        if( angular.isDefined(this.propertiesToDisplay)){
            this.collectionConfig.addDisplayProperty(this.propertiesToDisplay.split(","));
        }
        
        angular.forEach(this.columns, (column)=>{
            this.collectionConfig.addDisplayProperty(column.propertyIdentifier, '', column);
        });
        
        angular.forEach(this.filters, (filter)=>{
            this.collectionConfig.addFilter(filter.propertyIdentifier, filter.comparisonValue, filter.comparisonOperator, filter.logicalOperator, filter.hidden);
        }); 

        if( angular.isUndefined(this.allRecords)){
            this.allRecords = this.collectionConfig.allRecords;
        }

        this.collectionConfig.setAllRecords(this.allRecords);
        
        if( angular.isUndefined(this.maxRecords)){
            this.maxRecords = 10;    
        }

        this.collectionConfig.setPageShow(this.maxRecords);

        if( angular.isDefined(this.initialEntityId) && this.initialEntityId.length){
            this.initialEntityCollectionConfig = collectionConfigService.newCollectionConfig(this.collectionConfig.baseEntityName);
            this.initialEntityCollectionConfig.loadColumns(this.collectionConfig.columns);
            var primaryIDProperty = $hibachi.getPrimaryIDPropertyNameByEntityName(this.initialEntityCollectionConfig.baseEntityName);
            this.initialEntityCollectionConfig.addFilter(primaryIDProperty,this.initialEntityId,"=");
           
            var promise = this.initialEntityCollectionConfig.getEntity();
            promise.then( (response) =>{
                this.results = response.pageRecords;
                if(this.results.length){
                    this.addOrRemoveItem(this.results[0]); 
                }
            });
        }

        angular.forEach(this.collectionConfig.columns,(value,key)=>{
            if(value.isSearchable){
                this.searchableColumns.push(value);
            }
        }); 

        //need to insure that these changes are actually on the collectionconfig
        angular.copy(this.searchableColumns,this.initialSearchableColumnsState);

        this.typeaheadService.setTypeaheadState(this.typeaheadDataKey, this);

        this.observerService.attach(this.clearSearch, this.typeaheadDataKey + 'clearSearch');


        this.$http = $http;
    }

    public clearSearch = () =>{
        this.searchText = "";
        this.hideSearch = true;
        if(angular.isDefined(this.addFunction)){
            this.addFunction()(undefined);
        }
    };
    
    public toggleDropdown = ()=>{
        this.dropdownOpen = !this.dropdownOpen;    
    }

    public toggleOptions = () =>{
        if(this.hideSearch && (!this.searchText || !this.searchText.length)){
            this.search(this.searchText, true);
        }
        
        this.hideSearch = !this.hideSearch;
        
    };

    /**
     * The actionCreator function for searching.
     */
    public rSearch = (search:string) => {
        /**
         * Fire off an action that a search is happening.
         * Example action function. The dispatch takes a function, that sends data in a payload
         * to the reducer.
         */
        this.typeaheadService.typeaheadStore.dispatch({
                "type": "TYPEAHEAD_QUERY",
                "payload": {
                    "searchText": search
                }
            }
        )
    }
    

	public search = (search:string='',allowEmptyKeyword=false)=>{
	    
	    
	    if(!search.length && !allowEmptyKeyword){
 	        this.closeThis();
 	        return;
 	    }
 	    
        this.rSearch(search);
    
        if(this._timeoutPromise){

            this.$timeout.cancel(this._timeoutPromise);
            this.loading = false;
        }
        
        this.loading = true;
        this.collectionConfig.setKeywords(search);
        
        if(angular.isDefined(this.filterGroupsConfig)){
            //allows for filtering on search text
            var filterConfig = this.filterGroupsConfig.replace("replaceWithSearchString", search);
            filterConfig = filterConfig.trim();
            this.collectionConfig.loadFilterGroups(JSON.parse(filterConfig));
        }
        
        this._timeoutPromise = this.$timeout(()=>{
            var promise;
            if(this.searchEndpoint){
                promise = this.requestService.newPublicRequest(
                    '/' + this.searchEndpoint,
                    {
                        search:search,
                        options:this.collectionConfig.getOptions(),
                        entityName:this.collectionConfig.baseEntityName
                    },
                    'post',
                    {
                       'Content-Type': 'application/json'
                    }
                ).promise
            }else{
                promise = this.collectionConfig.getEntity();
            }

            promise.then( (response) =>{
                this.results = response.pageRecords || response.records; 
                this.updateSelections();               
            }).finally(()=>{
                this.resultsDeferred.resolve();
                this.hideSearch = (this.results.length == 0);
                this.loading = false;
            });

        }, 500);
    };

   public updateSelections = () =>{
       this.typeaheadService.updateSelections(this.typeaheadDataKey);
   }

    public updateSearchableProperties = (column) =>{
        if(angular.isString(column) && column == 'all'){
            angular.copy(this.initialSearchableColumnsState, this.searchableColumns);//need to insure that these changes are actually on the collectionconfig
            this.searchableColumnSelection = 'All';
        } else {
            angular.forEach(this.searchableColumns, (value,key) => {
                value.isSearchable = false; 
            }); 
            column.isSearchable = true; 
            this.searchableColumnSelection = column.title; 
        }
        //probably need to refetch the collection
    }

    public addOrRemoveItem = (item)=>{
        var remove = item.selected || false; 

        if(!this.hideSearch && !this.multiselectMode){
            this.hideSearch = true;
        }
        
        if(!this.multiselectMode){
            if( angular.isDefined(this.propertyToShow) ){
                this.searchText = item[this.propertyToShow];
            
            } else if( angular.isDefined(this.columns) && 
                       this.columns.length && 
                       angular.isDefined(this.columns[0].propertyIdentifier)
            ){
                this.searchText = item[this.columns[0].propertyIdentifier];
            } 
        }

        if(!remove && angular.isDefined(this.addFunction)){
            this.addFunction()(item);
        }

        if(remove && angular.isDefined(this.removeFunction)){
            this.removeFunction()(item.selectedIndex); 
            item.selected = false; 
            item.selectedIndex = undefined;
        }

        this.updateSelections();
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

    public closeThis = (clickOutsideArgs?) =>{

        this.hideSearch = true;

        if(angular.isDefined(clickOutsideArgs)){
            for(var callBackAction in clickOutsideArgs.callBackActions){
                clickOutsideArgs.callBackActions[callBackAction]();
            }
        }

    };

    public getSelections = () =>{
        return this.typeaheadService.getData(this.typeaheadDataKey);
    }

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
        propertyToCompare:"@?",
        fallbackPropertiesToCompare:"@?",
        searchText:"=?",
        searchOnLoad:"=?",
        results:"=?",
        addFunction:"&?",
        removeFunction:"&?",
        addButtonFunction:"&?",
        viewFunction:"&?",
        showAddButton:"=?",
        showViewButton:"=?",
        validateRequired:"=?",
        uniqueResults:"<?",
        clickOutsideArguments:"=?",
        propertyToShow:"=?",
        hideSearch:"=?",
        allRecords:"=?",
        maxRecords:"=?",
        disabled:"=?",
        initialEntityId:"@",
        multiselectMode:"=?",
        typeaheadDataKey:"@?",
        rightContentPropertyIdentifier:"@?",
        searchEndpoint:"@?",
        allResultsEndpoint:"@?",
        titleText:'@?',
        urlBase:'@?', 
        urlProperty:'@?'
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
                var uniqueFilter = '';
                if($scope.swTypeaheadSearch.uniqueResults){
                    uniqueFilter = ` | unique:'` + this.typeaheadService.getTypeaheadPrimaryIDPropertyName($scope.swTypeaheadSearch.typeaheadDataKey)+`'`;
                }
                var listItemTemplateString = `
                    <li ng-repeat="item in swTypeaheadSearch.results` + uniqueFilter + `" class="dropdown-item" ng-class="{'s-selected':item.selected}"></li>
                `;

                var anchorTemplateString = `
                    <a 
                `;

                if(angular.isDefined($scope.swTypeaheadSearch.urlBase) &&
                    angular.isDefined($scope.swTypeaheadSearch.urlProperty)){
                    anchorTemplateString += 'href="' + $scope.swTypeaheadSearch.urlBase + '{{item.' + $scope.swTypeaheadSearch.urlProperty + '}}">';
                } else {
                    anchorTemplateString += 'ng-click="swTypeaheadSearch.addOrRemoveItem(item)">';
                }

                if(angular.isDefined($scope.swTypeaheadSearch.rightContentPropertyIdentifier)){
                    var rightContentTemplateString = `
                        <span class="s-right-content" ng-bind="item[swTypeaheadSearch.rightContentPropertyIdentifier]"></span></a>
                    `;
                } else {
                    var rightContentTemplateString = "</a>";
                }

                if(angular.isDefined($scope.swTypeaheadSearch.allResultsEndpoint)){
                    var searchAllListItemTemplate = `
                        <li class="dropdown-item see-all-results" ng-if="swTypeaheadSearch.results.length == swTypeaheadSearch.maxRecords"><a href="{{swTypeaheadSearch.allResultsEndpoint}}?keywords={{swTypeaheadSearch.searchText}}">See All Results</a></li>
                    `
                }

                anchorTemplateString = anchorTemplateString + rightContentTemplateString; 
                var listItemTemplate = angular.element(listItemTemplateString);
                var anchorTemplate = angular.element(anchorTemplateString);
               
                anchorTemplate.append(this.typeaheadService.stripTranscludedContent(transclude($scope,()=>{}))); 
                listItemTemplate.append(anchorTemplate); 
                
                $scope.swTypeaheadSearch.resultsPromise.then(()=>{
                    
                    target.append(this.$compile(listItemTemplate)($scope));

                    if(searchAllListItemTemplate != null){
                        target.append(this.$compile(searchAllListItemTemplate)($scope));
                    }
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

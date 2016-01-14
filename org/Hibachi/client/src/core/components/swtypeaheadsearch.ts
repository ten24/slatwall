/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/slatwallTypescript.d.ts' />


class SWTypeaheadSearchController {

	public collectionConfig; 
	public entity:string;
	public properties:string;
	public propertiesToDisplay:string;
	public filterGroupsConfig:any;
	public allRecords:boolean;
	public placeholderText:string;
	public searchText:string;
	public results = [];
	public addFunction;
    public displayList;
	public addButtonFunction;
	public hideSearch;
	public modelBind;
	public clickOutsideArgs;
    public resultsPromise; 
   
    
	private _timeoutPromise;
    private resultsDefferred; 
	private entityList;
	private typeaheadCollectionConfig;
	private typeaheadCollectionConfigs;
    
    // @ngInject
	constructor(private $scope, private $q, private $transclude, private $hibachi, private $timeout:ng.ITimeoutService, private utilityService, private collectionConfigService){

        this.resultsDeferred = $q.defer();
        this.resultsPromise = this.resultsDeferred.promise;

        if(angular.isDefined(this.collectionConfig)){
            this.typeaheadCollectionConfig = this.collectionConfig; 
        } else if (angular.isDefined(this.entity) && angular.isDefined(this.properties)){ 
            this.typeaheadCollectionConfig = collectionConfigService.newCollectionConfig(this.entity);
            this.typeaheadCollectionConfig.setDisplayProperties(this.properties);
        } else { 
            throw("You did not pass the correct collection config data to swTypeaheadSearch");
        }
        
		if(angular.isDefined(this.propertiesToDisplay)){
			this.displayList = this.propertiesToDisplay.split(",");
		} else { 
            this.displayList = [];
        }

        //init timeoutPromise for link
        this._timeoutPromise = this.$timeout(()=>{{},500);

        //populate the displayList
        this.$transclude = this.$transclude;
        this.$transclude($scope,()=>{});
        
        this.typeaheadCollectionConfig.setDisplayProperties(this.utilityService.arrayToList(this.displayList));
        
        console.log("TypeaheadCollectionConfig", this.typeaheadCollectionConfig);
        
		if(angular.isDefined(this.allRecords)){
			this.typeaheadCollectionConfig.setAllRecords(this.allRecords);
		} else {
			this.typeaheadCollectionConfig.setAllRecords(true);
		}
	}

	public search = (search:string)=>{

		if(angular.isDefined(this.modelBind)){
			this.modelBind = search;
		}

		if(search.length > 2){

			if(this._timeoutPromise){
				this.$timeout.cancel(this._timeoutPromise);
			}

			this._timeoutPromise = this.$timeout(()=>{

				if(this.hideSearch){
					this.hideSearch = false;
				}
                
				this.typeaheadCollectionConfig.setKeywords(search);

				if(angular.isDefined(this.filterGroupsConfig)){
					//allows for filtering on search text
					var filterConfig = this.filterGroupsConfig.replace("replaceWithSearchString", search);
					filterConfig = filterConfig.trim();
					this.typeaheadCollectionConfig.loadFilterGroups(JSON.parse(filterConfig));
				} 

				var promise = this.typeaheadCollectionConfig.getEntity();

				promise.then( (response) =>{
						if(angular.isDefined(this.allRecords) && this.allRecords == false){
							console.log("setting Results")
                            this.results = response.pageRecords;
						} else {
                            console.log("setting Results")
							this.results = response.records;
						}
                        
						//Custom method for gravatar on accounts (non-persistant-property)
						//if(angular.isDefined(this.results) && this.entity == "Account"){
						//	angular.forEach(this.results,(account)=>{
						//		account.gravatar = "http://www.gravatar.com/avatar/" + md5(account.primaryEmailAddress_emailAddress.toLowerCase().trim());
						//	});
						//}

				}).finally(()=>{
                      this.resultsDeferred.resolve();
                });
			}, 500);
		} else {
			this.results = [];
			this.hideSearch = true;
		}
	}

	public addItem = (item)=>{

		if(!this.hideSearch){
			this.hideSearch = true;
		}

		if(angular.isDefined(this.displayList)){
			this.searchText = item[this.displayList[0]];
		}

		if(angular.isDefined(this.addFunction)){
			this.addFunction({item: item});
		}
	}

	public addButtonItem = ()=>{

		if(!this.hideSearch){
			this.hideSearch = true;
		}

		if(angular.isDefined(this.modelBind)){
			this.searchText = this.modelBind;
		} else {
			this.searchText = "";
		}

		if(angular.isDefined(this.addButtonFunction)){
			this.addButtonFunction({searchString: this.searchText});
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
			'pathBuilderConfig'];
	public templateUrl;
    public transclude=true; 
	public restrict = "EA";
	public scope = {}

	public bindToController = {
        collectionConfig:"=",
		entity:"@?",
		properties:"@?",
		propertiesToDisplay:"@?",
		filterGroupsConfig:"@?",
		placeholderText:"@?",
		searchText:"=?",
		results:"=?",
		addFunction:"&?",
		addButtonFunction:"&?",
		hideSearch:"=",
		modelBind:"=?",
		clickOutsideArgs:"@"
	}
	public controller=SWTypeaheadSearchController;
	public controllerAs="swTypeaheadSearch";

	constructor(private $hibachi, private $injector, private $timeout:ng.ITimeoutService, private utilityService, private collectionConfigService, private corePartialsPath,pathBuilderConfig){
		this.templateUrl = pathBuilderConfig.buildPartialsPath(corePartialsPath) + "typeaheadsearch.html";
	}

	public link:ng.IDirectiveLinkFn = (scope, element, attrs, controller, transclude) =>{
        console.log("prelinkHTML", element.html(), scope)
        var children = element.children();
        console.log("children", children)
        var listItemTemplate = angular.element('<li></li>');
        var actionTemplate = angular.element('<a ng-click="swTypeaheadSearch.addItem(item)" ></a>');
        var transcludeContent = transclude(scope,()=>{});
        console.log("trannyHtml", transcludeContent)
        actionTemplate.append(transcludeContent); 
        listItemTemplate.append(actionTemplate); 
        
        scope.swTypeaheadSearch.resultsPromise.then(()=>{
            console.log("THENNN")
            angular.forEach(scope.swTypeaheadSearch.results, (item,key)=>{
                console.log("itemkey",item,key)
            }); 
        });
            
        console.log("postlinkHTML", element.html(), scope)
	}
    
    /*public compile:ng.IDirectiveCompileFn = (tElement, tAttrs, tTransclude) => {
        
        // Extract the children from this instance of the directive
        console.log('beforeHTML', tElement.html());
        var children = tElement.children();
        var listTemplate = angular.element('<li ng-repeat="item in swTypeaheadSearch.results"></li>');
        var actionTemplate = angular.element('<a ng-click="swTypeaheadSearch.addItem(item)" ></a>');
        var rootScope:IScope = this.$injector.get("$rootScope");
        console.log(rootScope)
        //var transcludeContent = tTransclude(this.scope,()=>{});
        //console.log("TRANNY", transcludeContent)
        //actionTemplate.append(transcludeContent);
        listTemplate.append(actionTemplate); 
        children.append(listTemplate);
        tElement.html('');
        tElement.append(children);
         console.log('afterHTML', tElement.html());
      return {
        pre: function preLink(scope, tElement, iAttrs, crtl, transclude) {
            
        },
        post: function postLink(scope, iElement, iAttrs, controller, transclude) {
            console.log("beforepost",iElement.html())
            console.log("afterpost",iElement.html())
        }
        };
    }*/

	public static Factory(){
		var directive:ng.IDirectiveFactory = (
			$hibachi
            ,$injector
			,$timeout
            ,utilityService
			,collectionConfigService
			,corePartialsPath
            ,pathBuilderConfig

		)=> new SWTypeaheadSearch(
			$hibachi
            ,$injector
			,$timeout
            ,utilityService
			,collectionConfigService
			,corePartialsPath
            ,pathBuilderConfig
		);
		directive.$inject = ["$hibachi", "$injector", "$timeout", "utilityService", "collectionConfigService", "corePartialsPath",
			'pathBuilderConfig'];
		return directive;
	}
}
export{
	SWTypeaheadSearch,
	SWTypeaheadSearchController
}

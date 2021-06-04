/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWSiteSelectorController {

    public sites:any[];
    public sitesCollectionConfig:any;
    public filterPropertyIdentifier:string;
    public simpleFilterPropertyIdentifier:string;
    public collectionConfigToFilter:any;
    public selectedSite:string;
    public defaultSiteID:string;
    public defaultEstablished:boolean;
    public inListingDisplay:boolean;
    public withTypeahead:boolean;
    public typeaheadDataKey:string;
    public listingID:string;
    public disabled:boolean;

    //@ngInject
    constructor(
        private collectionConfigService,
        private listingService,
        private localStorageService,
        private typeaheadService,
        private utilityService
    ){
        if(angular.isUndefined(this.disabled)){
            this.disabled = false;
        }
        if(angular.isUndefined(this.simpleFilterPropertyIdentifier)){
            this.simpleFilterPropertyIdentifier = "siteID";
        }
        this.sitesCollectionConfig = collectionConfigService.newCollectionConfig("Site");
        this.sitesCollectionConfig.addDisplayProperty("siteID, siteName, siteCode");
        this.sitesCollectionConfig.setAllRecords(true);
        this.sitesCollectionConfig.getEntity().then(
            (data)=>{
                this.sites = data.records;
                if(this.sites[0]){
                    this.selectedSite = this.sites[0].siteID;
                }
            },
            (reason)=>{
                throw("SWProductListingPages had trouble fetching sites because of " + reason);
            }
        ).finally(()=>{
            this.selectSite();
        });
    }

    public selectSite = () =>{
        this.collectionConfigToFilter.removeFilterByDisplayPropertyIdentifier(this.simpleFilterPropertyIdentifier);
        console.log("selectSite", this.selectedSite)
        switch(this.selectedSite){
            case "all":
                //do nothing
                console.log("donothing")
                break;
            case "default":
                this.updateDefaultSiteID();
                if(this.defaultEstablished){
                    console.log("adding filter", this.defaultSiteID)
                    this.collectionConfigToFilter.addFilter(this.filterPropertyIdentifier, this.defaultSiteID, "=");
                }
                break;
            case undefined:
                //do nothing
                break;
            default:
                this.localStorageService.setItem("defaultSiteID", this.selectedSite);
                this.collectionConfigToFilter.addFilter(this.filterPropertyIdentifier, this.selectedSite, "=");
                break;
        }
        if(this.withTypeahead && this.typeaheadDataKey != null){
            this.typeaheadService.getData(this.typeaheadDataKey);
        }
        if(this.inListingDisplay && this.listingID != null){
            this.listingService.getCollection(this.listingID);
        }
    }

    private updateDefaultSiteID = () =>{
        console.log("updating default established")
        if(this.localStorageService.hasItem("defaultSiteID")){
            this.defaultEstablished = true;

            this.defaultSiteID = this.localStorageService.getItem("defaultSiteID");
        } else {
            console.log("default established false")
            this.defaultEstablished = false;
        }
    }

}

class SWSiteSelector implements ng.IDirective{

    public templateUrl;
    public restrict = "EA";
    public scope = {};

    public bindToController = {
        inListingDisplay:"=?",
        filterPropertyIdentifier:"@?",
        collectionConfigToFilter:"=?",
        withTypeahead:"=?",
        typeaheadDataKey:"@?",
        disabled:"=?"
    };

    public controller=SWSiteSelectorController;
    public controllerAs="swSiteSelector";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
            $http,
            $hibachi,
            listingService,
            scopeService,
		    contentPartialsPath,
			slatwallPathBuilder
        ) => new SWSiteSelector(
            $http,
            $hibachi,
            listingService,
            scopeService,
			contentPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            '$http',
            '$hibachi',
            'listingService',
            'scopeService',
			'contentPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }

    //@ngInject
	constructor(
		private $http,
        private $hibachi,
        private listingService,
        private scopeService,
	    private contentPartialsPath,
		private slatwallPathBuilder
	){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(contentPartialsPath) + "/siteselector.html";
    }

    public link:ng.IDirectiveLinkFn = ($scope:any, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
        if($scope.swSiteSelector.withTypeahead == null){
            $scope.swSiteSelector.withTypeahead = false;
        }
        if($scope.swSiteSelector.inListingDisplay == null){
            $scope.swSiteSelector.inListingDisplay = !$scope.swSiteSelector.withTypeahead;
        }
        if($scope.swSiteSelector.inListingDisplay == true && this.scopeService.hasParentScope($scope, "swListingDisplay")){
            var listingDisplayScope = this.scopeService.getRootParentScope($scope, "swListingDisplay")["swListingDisplay"];
            $scope.swSiteSelector.listingID = listingDisplayScope.tableID;
            if(listingDisplayScope.collectionConfig != null){
                $scope.swSiteSelector.collectionConfigToFilter = listingDisplayScope.collectionConfig;
            }
            this.listingService.attachToListingInitiated($scope.swSiteSelector.listingID, $scope.swSiteSelector.selectSite);
        } else {
            $scope.swSiteSelector.selectSite();
        }

    }
}

export {
	SWSiteSelectorController,
	SWSiteSelector
};

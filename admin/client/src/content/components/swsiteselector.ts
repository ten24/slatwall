/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWSiteSelectorController {

    //@ngInject
    constructor(
        private collectionConfigService,
        private listingService, 
        private utilityService
    ){

    }

}

class SWSiteSelector implements ng.IDirective{

    public templateUrl; 
    public restrict = "EA";
    public scope = {};  
    
    public bindToController = {

    };
    
    public controller=SWSiteSelectorController;
    public controllerAs="swSiteSelector";
    
	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
            $http,
            $hibachi,
            paginationService,
		    contentPartialsPath,
			slatwallPathBuilder
        ) => new SWSiteSelector(
            $http,
            $hibachi,
            paginationService,
			contentPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            '$http',
            '$hibachi',
            'paginationService',
			'contentPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    
    //@ngInject
	constructor(
		private $http,
        private $hibachi,
        private paginationService,
	    private contentPartialsPath,
		private slatwallPathBuilder
	){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(contentPartialsPath) + "/siteselector.html";
    }

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
    }
}

export {
	SWSiteSelectorController,
	SWSiteSelector
};

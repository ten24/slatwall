/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWReportMenuController{
	public collectionConfig: any;
	public persistedReportCollections: any;
    constructor(
        public $rootScope,
        private requestService,
        private accountService
    ){

    }

    public $onInit = () => {
    	if(this.collectionConfig){
	    	// this.getPersistedReports();
	    	this.getDashboardReports();
    	}else{
    		
    	}
    	
    }
    
    private getDashboardReports = () => {
    	console.log("getDashboardReports")
	    const data = {
	      slatAction: "admin:report.tomsreports",
	      accountID: this.accountService.accountID,
	    };
	
	    var promise = this.requestService.newPublicRequest("/", 
	    data, "post", {
	    //   "Content-Type": "application/json",
	    'Content-Type':"application/x-www-form-urlencoded",
	      'X-Hibachi-AJAX': true
	    }).promise;
	
	    promise.then((response) => {
	        console.log("getDashboardReports")
	        console.log(response)
	        this.persistedReportCollections = response
		});
    	
    }
    
    public getPersistedReports = () => {
    	console.log("collectionConfig 1")
    	console.log(this.collectionConfig)
        var persistedReportsCollectionList = this.collectionConfig.newCollectionConfig('Collection');
        persistedReportsCollectionList.setDisplayProperties('collectionID,collectionName,collectionConfig,collectionCode');
        persistedReportsCollectionList.addFilter('reportFlag',1);
        persistedReportsCollectionList.addFilter('collectionObject',this.collectionConfig.baseEntityName);
        persistedReportsCollectionList.addFilter('accountOwner.accountID',this.$rootScope.slatwall.account.accountID,'=','OR',true,true,false,'accountOwner');
        persistedReportsCollectionList.addFilter('accountOwner.accountID','NULL','IS','OR',true,true,false,'accountOwner');
        persistedReportsCollectionList.setAllRecords(true);
        persistedReportsCollectionList.getEntity().then((data)=>{
        	this.persistedReportCollections = data.records;
        });
    }
}

class SWReportMenu implements ng.IDirective {
	public restrict = "E";
	public controller = SWReportMenuController;
	public templateUrl;
	public controllerAs = "swReportMenu";
	public scope = {};
	public bindToController = {
			propertyDisplay : "=?",
            propertyIdentifier: "@?",
            name : "@?",
            class: "@?",
            collectionConfig:"<?"
	};
	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, transcludeFn:ng.ITranscludeFunction) =>{
            console.log("SWReportMenu IDirectiveLinkFn" )

	}



	/**
		* Handles injecting the partials path into this class
		*/
	public static Factory(){
		var directive = (
		 	reportPartialPath,
				hibachiPathBuilder
		)=>new SWReportMenu(
			reportPartialPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'reportPartialPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor (
		reportPartialPath,
		hibachiPathBuilder
	) {
		this.templateUrl = hibachiPathBuilder.buildPartialsPath(reportPartialPath)+ 'reportmenu.html';
	}
}

export{
	SWReportMenu
}

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWReportMenuController{
	public collectionConfig: any;
	public persistedReportCollections: any;
	public popularReports: any;
	public allReports: any;
	public myCustomReports: any;
    constructor(
        public $rootScope,
        private requestService,
        private accountService,
        private collectionConfigService,
    ){

    }

    public $onInit = () => {
    		    	this.getPopularReports();
	    	this.getAllReports();
	    	this.getMyCustomReports();
    	
    }
    
    public getPopularReports = () =>{
		var popularReports = this.collectionConfigService.newCollectionConfig('Collection');
    	popularReports.setDisplayProperties('collectionID,collectionName,collectionConfig,collectionCode,reportFlag,accountOwner.accountID');
    	popularReports.addFilter('reportFlag',1)
		popularReports.addFilter('accountOwner.accountID', 'null', 'is not');
		popularReports.setAllRecords(true);
        popularReports.getEntity().then((data)=>{
        	data.records.forEach((customRecord)=>{
        		customRecord.collectionConfig = JSON.parse(customRecord.collectionConfig)
        	})
        	this.popularReports = data.records;
        });
    }
    public getAllReports = () =>{
		var allReports = this.collectionConfigService.newCollectionConfig('Collection');
    	allReports.setDisplayProperties('collectionID,collectionName,collectionConfig,collectionCode,reportFlag');
    	allReports.addFilter('reportFlag',1)
    	allReports.setAllRecords(true);
        allReports.getEntity().then((data)=>{
        	data.records.forEach((customRecord)=>{
        		customRecord.collectionConfig = JSON.parse(customRecord.collectionConfig)
        	})
        	this.allReports = data.records;
        });
    }
    public getMyCustomReports = () =>{
		var myCustomReports = this.collectionConfigService.newCollectionConfig('Collection');
    	myCustomReports.setReportFlag(1)
    	myCustomReports.setDisplayProperties('collectionID,collectionName,collectionConfig,collectionCode,reportFlag');
		myCustomReports.addFilter('createdByAccountID', this.$rootScope.slatwall.account.accountID ,'=', 'OR', '', 'group1');
		myCustomReports.addFilter('accountOwner.accountID',this.$rootScope.slatwall.account.accountID ,'=','OR','', 'group1');
		myCustomReports.setAllRecords(true);
		myCustomReports.getEntity().then((data)=>{
			data.records.forEach((customRecord)=>{
        		customRecord.collectionConfig = JSON.parse(customRecord.collectionConfig)
        	})
        	this.myCustomReports = data.records;
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

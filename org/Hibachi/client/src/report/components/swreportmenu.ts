/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWReportMenuController{
	public collectionConfig: any;
	public persistedReportCollections: any;
    constructor(
        public $rootScope,
    ){}

    public $onInit = () => {
    	this.getPersistedReports();
    }
    
    public getPersistedReports = () => {
        var persistedReportsCollectionList = this.collectionConfig.newCollectionConfig('Collection');
        persistedReportsCollectionList.setDisplayProperties('collectionID,collectionName,collectionConfig,collectionCode');
        persistedReportsCollectionList.addFilter('reportFlag',1);
        persistedReportsCollectionList.addFilter('collectionObject',this.collectionConfig.baseEntityName);
        persistedReportsCollectionList.addFilter('accountOwner.accountID',this.$rootScope.slatwall.account.accountID,'=','OR',true,true,false,'accountOwner');
        persistedReportsCollectionList.addFilter('accountOwner.accountID','NULL','IS','OR',true,true,false,'accountOwner');
        persistedReportsCollectionList.setAllRecords(true);
        persistedReportsCollectionList.getEntity().then((data)=>{
            console.log(data)
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

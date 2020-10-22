/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWReportMenuController{
	public collectionConfig: any;
	public popularReports: any;
	public allReports: any;
	public myCustomReports: any;
	private slatwall: any;
    constructor(
    	private $scope,
        public $rootScope,
        private requestService,
        private accountService,
        private collectionConfigService,
    ){
    	this.slatwall = $rootScope.slatwall
    	$scope.$watch('slatwall.account.accountID',this.getMyCustomReports);
    	this.getPopularReports();
	    this.getAllReports();
    }

	public chunkify = (a, n, balanced) => {
    
    if (n < 2)
        return [a];

    var len = a.length,
            out = [],
            i = 0,
            size;

    if (len % n === 0) {
        size = Math.floor(len / n);
        while (i < len) {
            out.push(a.slice(i, i += size));
        }
    }

    else if (balanced) {
        while (i < len) {
            size = Math.ceil((len - i) / n--);
            out.push(a.slice(i, i += size));
        }
    }

    else {

        n--;
        size = Math.floor(len / n);
        if (len % size === 0)
            size--;
        while (i < size * n) {
            out.push(a.slice(i, i += size));
        }
        out.push(a.slice(size * n));

    }

    return out;
	}
    
    public getPopularReports = () =>{
		var popularReports = this.collectionConfigService.newCollectionConfig('Collection');
    	popularReports.setDisplayProperties('collectionID,collectionName,collectionConfig,collectionCode,reportFlag,accountOwner.accountID');
    	popularReports.addFilter('reportFlag',1)
		popularReports.addFilter('accountOwner.accountID', 'null', 'is not');
		popularReports.setOrderBy('collectionObject|ASC');
		popularReports.setAllRecords(true);
        popularReports.getEntity().then((data)=>{
        	data.records.forEach((customRecord)=>{
        		customRecord.collectionConfig = JSON.parse(customRecord.collectionConfig)
        	})
        	this.popularReports = this.chunkify(data.records, 3, true);
        });
    }
    public getAllReports = () =>{
		var allReports = this.collectionConfigService.newCollectionConfig('Collection');
    	allReports.setDisplayProperties('collectionID,collectionName,collectionConfig,collectionCode,reportFlag');
    	allReports.setOrderBy('collectionObject|ASC');
    	allReports.addFilter('reportFlag',1)
    	allReports.setAllRecords(true);
        allReports.getEntity().then((data)=>{
        	data.records.forEach((customRecord)=>{
        		customRecord.collectionConfig = JSON.parse(customRecord.collectionConfig)
        	})
        	this.allReports = this.chunkify(data.records, 3, true);
        });
    }
    

    public getMyCustomReports = () =>{
		var myCustomReports = this.collectionConfigService.newCollectionConfig('Collection');
    	myCustomReports.setDisplayProperties('collectionID,collectionName,collectionConfig,collectionCode,reportFlag');
    	myCustomReports.addFilter('reportFlag',1,'=', '' )
		myCustomReports.addFilterGroup([{
			propertyIdentifier: 'createdByAccountID',
			comparisonValue: 	this.slatwall.account.accountID,
			comparisonOperator: '=',
			logicalOperator: 'OR',
			hidden: false,
		},{
						propertyIdentifier: 'accountOwner.accountID',
			comparisonValue: 	this.slatwall.account.accountID,
			comparisonOperator: '=',
			logicalOperator: 'OR',
			hidden: false,
		}]);
		myCustomReports.setOrderBy('collectionObject|ASC');
		myCustomReports.setAllRecords(true);
		myCustomReports.getEntity().then((data)=>{
			data.records.forEach((customRecord)=>{
        		customRecord.collectionConfig = JSON.parse(customRecord.collectionConfig)
        	})
        	this.myCustomReports =  this.chunkify(data.records, 3, true);
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

/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWStatWidgetController{
	public collectionConfig: any;
	public siteId: any;
	public metric: any = 0 ;
	public metricCode: any;
	public period = "day";
	public startDateTime;
	public endDateTime;
    constructor(    
    	    private $scope,
			private collectionConfigService,
			public observerService
	){
		
		    this.observerService.attach((config)=>{
    	          this.period = config.period
    	          this.startDateTime =config.startDateTime
    	          this.endDateTime =config.endDateTime
    	          this.getMetrics()
    	        },'swReportConfigurationBar_PeriodUpdate', 'report-wiget');
    	        
		    this.observerService.attach((siteID)=>{
    	          this.siteId = siteID
    	          this.getMetrics()
    	        },'swReportConfigurationBar_SiteUpdate', 'report-wiget');
    	        
    	this.getMetrics()
     
    }
    public getMetrics = () => {
    			if(this.metricCode === 'accountCount'){
			this.getAccountCount()
		}else if(this.metricCode === 'orderCount'){
			this.getOrderCount()
		}else if(this.metricCode === 'avgSales'){
			this.getAverageSalesRevenue()
		}else if(this.metricCode === 'totalSales'){
			 this.getSalesRevenue()
		}
    }
    
        public getSalesRevenue = () => {
	        var metricCollection = this.collectionConfigService.newCollectionConfig('Order');
	        metricCollection.setReportFlag(true)
	    	if(this.siteId){
	    		metricCollection.addFilter('orderCreatedSite.siteID', this.siteId,'=');
	    	}else{
				metricCollection.addFilter('orderCreatedSite.siteID', 'NULL','IS');
	    	}
	    	metricCollection
			metricCollection.addFilter('orderStatusType.systemCode','ostNotPlaced','!=');
	        metricCollection.addDisplayAggregate('calculatedTotal','sum', "orderTotal");
	        metricCollection.addFilter('createdDateTime', this.startDateTime, '>=');
			metricCollection.addFilter('createdDateTime', this.endDateTime, '<=');
	        metricCollection.getEntity().then((data)=>{
	        	if(data["pageRecords"] && data["pageRecords"].length > 0){
					if(data["pageRecords"][0]["orderTotal"] !== " "){
		        		this.metric = data["pageRecords"][0]["orderTotal"]
					}else{
						this.metric = 0
					}
	        	}
	        });

        }
        
        public getOrderCount = () => {
	        var metricCollection = this.collectionConfigService.newCollectionConfig('Order');
	        metricCollection.setReportFlag(true)
	    	if(this.siteId){
	    		metricCollection.addFilter('orderCreatedSite.siteID', this.siteId,'=');
	    	}else{
				metricCollection.addFilter('orderCreatedSite.siteID', 'NULL','IS');
	    	}
			metricCollection.addFilter('orderStatusType.systemCode','ostNotPlaced','!=');
	        metricCollection.addDisplayAggregate('orderID','COUNT', "orderCount");
	        metricCollection.addFilter('createdDateTime', this.startDateTime, '>=');
			metricCollection.addFilter('createdDateTime', this.endDateTime, '<=');
	        metricCollection.getEntity().then((data)=>{
	        	if(data["pageRecords"] && data["pageRecords"].length > 0){
	        		if(data["pageRecords"][0]["orderTotal"] !== " "){
	        			this.metric = data["pageRecords"][0]["orderCount"];
					}else{
						this.metric = 0
					}
	        	}
	        });

        }
        
        public getAverageSalesRevenue = () => {
	        var metricCollection = this.collectionConfigService.newCollectionConfig('Order');
	        metricCollection.setReportFlag(true)
	    	if(this.siteId){
	    		metricCollection.addFilter('orderCreatedSite.siteID', this.siteId,'=');
	    	}else{
				metricCollection.addFilter('orderCreatedSite.siteID', 'NULL','IS');
	    	}
			metricCollection.addFilter('orderStatusType.systemCode','ostNotPlaced','!=');
	        metricCollection.addDisplayAggregate('calculatedTotal','AVG', "averageOrderTotal");
	        metricCollection.addFilter('createdDateTime', this.startDateTime, '>=');
			metricCollection.addFilter('createdDateTime', this.endDateTime, '<=');
	        metricCollection.getEntity().then((data)=>{
	        	if(data["pageRecords"] && data["pageRecords"].length > 0){
					if(data["pageRecords"][0]["averageOrderTotal"] !== " "){
	        			this.metric = data["pageRecords"][0]["averageOrderTotal"];
					}else{
						this.metric = 0
					}
	        	}
	        });

        }
        
        public getAccountCount = () => {
	        var metricCollection = this.collectionConfigService.newCollectionConfig('Account');
	        metricCollection.setReportFlag(true)
	    	if(this.siteId){
	    		metricCollection.addFilter('accountCreatedSite.siteID', this.siteId,'=');
	    	}else{
				metricCollection.addFilter('accountCreatedSite.siteID', 'NULL','IS');
	    	}
	        metricCollection.addDisplayAggregate('accountID','COUNT', "accountsTotal");
	        metricCollection.addFilter('createdDateTime', this.startDateTime, '>=');
			metricCollection.addFilter('createdDateTime', this.endDateTime, '<=');
	        metricCollection.getEntity().then((data)=>{
	        	
	        	if(data["pageRecords"] && data["pageRecords"].length > 0){
					if(data["pageRecords"][0]["orderTotal"] !== " "){
	        			this.metric = data["pageRecords"][0]["accountsTotal"];
					}else{
						this.metric = 0
					}	        		
	        	}
	        });

        }
}

class SWStatWidget implements ng.IDirective {
	public restrict = "E";
	public controller = SWStatWidgetController;
	public templateUrl;
	public controllerAs = "swStatWidget";
	public scope = {};
	public bindToController = {
			propertyDisplay : "=?",
            propertyIdentifier: "@?",
            name : "@?",
            class: "@?",
            startDateTime: "@?",
            endDateTime: "@?",
            siteId: "@?",
            errorClass: "@?",
            type: "@?",
            title: "@?",
            metricCode: "@",
            imgSrc: "@?",
            imgAlt: "@?",
            footerClass: "@?",
            collectionConfig:"<?"
	};
	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, transcludeFn:ng.ITranscludeFunction) =>{

	}



	/**
		* Handles injecting the partials path into this class
		*/
	public static Factory(){
		var directive = (
		 	widgetPartialPath,
				hibachiPathBuilder,
		)=>new SWStatWidget(
			widgetPartialPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'widgetPartialPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor (
		widgetPartialPath,
		hibachiPathBuilder
	) {
		this.templateUrl = hibachiPathBuilder.buildPartialsPath(widgetPartialPath)+ 'statwidget.html';
	}
}

export{
	SWStatWidget
}

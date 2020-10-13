/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWReportConfigurationBarController{
	public customToggle = false;
	public site;
    public startDateTime;
    public customReportStartDateTime;
    public customReporEndDateTime;
    public endDateTime;
    public name = "tom";
    public period = "day";
    public startOfToday 
    public endOfToday
    public startOfMonth
    public endOfMonth
    public endOfHour
    public startOfYear
    public endOfYear
    public lastTwentyFourHours
    public lastTwoWeeks
    public weekGrouping
    public monthGrouping
    public siteCollectionList
    
    
    
    
    constructor(    
    	    private $scope,
			public observerService
){

    	
    	const now = new Date()
		this.startOfToday = '{ts \'' + new Date(  now.getFullYear(),   now.getMonth(),  now.getDate(), 0).toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		let eodData = new Date( now.getFullYear(),  now.getMonth(), now.getDate(), 23,59,59)
		this.endOfToday ='{ts \'' +  eodData.toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		this.startOfMonth = '{ts \'' + new Date( now.getFullYear(),  now.getMonth() , 1).toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		let eomData = new Date(now.getFullYear(), now.getMonth() + 1, 1) //correct  this month
		this.endOfMonth = '{ts \'' + eomData.toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		let eohData =  new Date( now.getFullYear(),  now.getMonth(), now.getDate(),now.getHours(), 59,59) // correct
		this.endOfHour = '{ts \'' +  eohData.toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		this.startOfYear =  '{ts \'' + new Date( now.getFullYear()-10,  0).toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		this.endOfYear = '{ts \'' +  new Date( now.getFullYear() +1,  now.getMonth(), 1).toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		this.lastTwentyFourHours = '{ts \'' +   new Date(	eohData).addDays(-1).toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		this.lastTwoWeeks = '{ts \'' +   new Date(	eodData).addDays(-13).toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		this.weekGrouping =  '{ts \'' +  new Date(	eodData).addWeeks(-11).toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		this.monthGrouping = '{ts \'' +   new Date(	eomData).addMonths(-11).toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		$scope.$watch('swReportConfigurationBar.site', ()=>{
        	this.observerService.notify('swReportConfigurationBar_SiteUpdate', this.site.siteID);
		});
		this.customReportStartDateTime =  new Date(	eomData).addMonths(-11)
		this.customReporEndDateTime = eomData
    	this.site = this.siteCollectionList[0]

    }
        changeTimeRange = (period, startTime, endTime )=>{
        	this.startDateTime = startTime
        	this.endDateTime = endTime
        	this.period = period
        	this.customToggle = false
        	this.observerService.notify('swReportConfigurationBar_PeriodUpdate', {"startDateTime": this.startDateTime, "endDateTime": this.endDateTime, "period": this.period});
    }

    	startCustomRange = ($event) =>{
    	
		    	$event.preventDefault()
				$event.stopPropagation()
    			this.customToggle = !this.customToggle
    			this.period = "custom"
    			this.updateCustomPeriod()
    	}
    	
    	updateCustomPeriod = () =>{
       		this.startDateTime =  '{ts \'' +   this.customReportStartDateTime.toString('yyyy-MM-dd HH:mm:ss') + '\'}'
    		this.endDateTime =  '{ts \'' +   this.customReporEndDateTime.toString('yyyy-MM-dd HH:mm:ss') + '\'}'
    		let dynamicPeriod = 'hour'
	    	let diff =( this.customReporEndDateTime - this.customReportStartDateTime ) /(1000 * 3600 * 24)
	    	
	    	if(diff > 365){
	    		dynamicPeriod = "year"
	    	}else if(diff > 30 && diff <= 365){
	    		dynamicPeriod = "month"
	    	}else if(diff > 7 && diff <= 30){
	    		dynamicPeriod = "week"
	    	}else if(diff > 1 && diff <= 7){
	    		dynamicPeriod = "day"
	    	}
	    	this.observerService.notify('swReportConfigurationBar_PeriodUpdate', {"startDateTime": this.startDateTime, "endDateTime": this.endDateTime, "period": dynamicPeriod});

    	}
    
}

class SWReportConfigurationBar implements ng.IDirective {
	public restrict = "E";
	public controller = SWReportConfigurationBarController;
	public templateUrl;
	public controllerAs = "swReportConfigurationBar";
	public scope = {};
	public bindToController = {
            siteCollectionList: "=?",
            groupBy: "@?",
            name: "@?",
            startOfToday : "@?",
            endOfToday: "@?",
            startOfMonth : "@?",
            endOfMonth: "@?",
            endOfHour: "@?",
            startOfYear : "@?",
            endOfYear: "@?",
            lastTwentyFourHours: "@?",
            lastTwoWeeks: "@?",
            weekGrouping: "@?",
            monthGrouping: "@?",
            
	};
	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, transcludeFn:ng.ITranscludeFunction) =>{
        scope.swReportConfigurationBar.openCalendarStart = function($event) {
			$event.preventDefault();
			$event.stopPropagation();
		    scope.swReportConfigurationBar.openedCalendarStart = true;
		};
				
		scope.swReportConfigurationBar.openCalendarEnd = function($event) {
			$event.preventDefault();
			$event.stopPropagation();
		    scope.swReportConfigurationBar.openedCalendarEnd = true;
		};
		

	}

	/**
		* Handles injecting the partials path into this class
		*/
	public static Factory(){
		var directive = (
            scopeService,
		 	widgetPartialPath,
			hibachiPathBuilder
		)=>new SWReportConfigurationBar(
            scopeService,
			widgetPartialPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'scopeService',
			'widgetPartialPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor (
		scopeService,
		widgetPartialPath,
		hibachiPathBuilder
	) {
		this.templateUrl = hibachiPathBuilder.buildPartialsPath(widgetPartialPath)+ 'reportconfigurationbar.html';
	}
}

export{
	SWReportConfigurationBar
}

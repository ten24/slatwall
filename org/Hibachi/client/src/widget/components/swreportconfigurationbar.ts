/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWReportConfigurationBarController{
	public customToggle = false;
	public site;
    public startDateTime;
    public customReportStartDateTime;
    public customReporEndDateTime;
    public endDateTime;
    public period = "day";
    constructor(    
    	    private $scope,
			public observerService
){

    	
    	const now = new Date()
		$scope.startOfToday = '{ts \'' + new Date(  now.getFullYear(),   now.getMonth(),  now.getDate(), 0).toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		$scope.eodData = new Date( now.getFullYear(),  now.getMonth(), now.getDate(), 23,59,59)
		$scope.endOfToday ='{ts \'' +  $scope.eodData.toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		$scope.startOfMonth = '{ts \'' + new Date( now.getFullYear(),  now.getMonth() , 1).toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		$scope.eomData = new Date(now.getFullYear(), now.getMonth() + 1, 1) //correct  this month
		$scope.endOfMonth = '{ts \'' + $scope.eomData.toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		$scope.eohData =  new Date( now.getFullYear(),  now.getMonth(), now.getDate(),now.getHours(), 59,59) // correct
		$scope.endOfHour = '{ts \'' +  $scope.eohData.toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		$scope.startOfYear =  '{ts \'' + new Date( now.getFullYear()-10,  0).toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		$scope.endOfYear = '{ts \'' +  new Date( now.getFullYear() +1,  now.getMonth(), 1).toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		$scope.lastTwentyFourHours = '{ts \'' +   new Date(	$scope.eohData).addDays(-1).toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		$scope.lastTwoWeeks = '{ts \'' +   new Date(	$scope.eodData).addDays(-13).toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		$scope.weekGrouping =  '{ts \'' +  new Date(	$scope.eodData).addWeeks(-11).toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		$scope.monthGrouping = '{ts \'' +   new Date(	$scope.eomData).addMonths(-11).toString('yyyy-MM-dd HH:mm:ss') + '\'}'
		$scope.$watch('swReportConfigurationBar.site', ()=>{
        	this.observerService.notify('swReportConfigurationBar_SiteUpdate', this.site.siteID);
		});
		this.customReportStartDateTime =  new Date(	$scope.eomData).addMonths(-11)
		this.customReporEndDateTime = $scope.eomData
    	this.site = $scope.swReportConfigurationBar.siteCollectionList[0]

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
        	this.observerService.notify('swReportConfigurationBar_PeriodUpdate', {"startDateTime": this.startDateTime, "endDateTime": this.endDateTime, "period": 'month'});

    	}
    
}

class SWReportConfigurationBar implements ng.IDirective {
	public restrict = "E";
	public controller = SWReportConfigurationBarController;
	public templateUrl;
	public controllerAs = "swReportConfigurationBar";
	public scope = {};
	public bindToController = {
			// startOfToday : "@?",
   //         endOfToday: "@?",
   //         startOfMonth : "@?",
   //         endOfMonth: "@?",
   //         endOfHour: "@?",
   //         startOfYear : "@?",
   //         endOfYear: "@?",
   //         lastTwentyFourHours: "@?",
   //         lastTwoWeeks: "@?",
   //         weekGrouping: "@?",
   //         monthGrouping: "@?",
            siteCollectionList: "=?",
            groupBy: "@?"
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

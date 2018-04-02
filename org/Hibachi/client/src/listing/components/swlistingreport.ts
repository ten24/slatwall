/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWListingReportController {
    
    public periodColumns:any;
    public collectionConfig:any;
    public reportCollectionConfig:any;
    //key value for adding rbkeys later
    public periodIntervals=[{value:'Hour'},{value:'Day'},{value:'Week'},{value:'Month'},{value:'Year'}];
    public selectedPeriodColumn:any;
    public selectedPeriodInterval:any;
    public startDate:any;
    public endDate:any;
    
    //@ngInject
    constructor(
        public $hibachi,
        public metadataService,
        public listingService,
        public observerService,
    ) {
        var rootColumns = {};
        rootColumns[this.collectionConfig.baseEntityAlias] = angular.copy(metadataService.getPropertiesListByBaseEntityAlias(this.collectionConfig.baseEntityAlias));
        
        this.periodColumns = [];
        
        for(var i in rootColumns[this.collectionConfig.baseEntityAlias].data){
            var rootColumn = rootColumns[this.collectionConfig.baseEntityAlias].data[i];
            if(rootColumn.ormtype && rootColumn.ormtype == 'timestamp'){
                this.periodColumns.push(rootColumn);
            }
        }
    }

    public $onInit=()=>{
    }
    
    public updatePeriod = ()=>{
        //if we have all the info we need then we can make a report
        if(
            this.selectedPeriodColumn 
            && this.selectedPeriodInterval
            && this.startDate
            && this.endDate
        ){
            this.reportCollectionConfig = this.collectionConfig.clone();
            
            this.reportCollectionConfig.setPeriodInterval(this.selectedPeriodInterval.value);
            this.reportCollectionConfig.setReportFlag(true);
            this.reportCollectionConfig.addDisplayProperty(this.selectedPeriodColumn.propertyIdentifier,'',{isHidden:true,isPeriod:true,isVisible:false});
            this.reportCollectionConfig.setAllRecords(true);
            this.reportCollectionConfig.setOrderBy(this.selectedPeriodColumn.propertyIdentifier+'|ASC');
            
            //TODO:should add as a filterGroup
            this.reportCollectionConfig.addFilter(this.selectedPeriodColumn.propertyIdentifier,this.startDate,'>=');
            this.reportCollectionConfig.addFilter(this.selectedPeriodColumn.propertyIdentifier,this.endDate,'<=');
            
            
            this.reportCollectionConfig.getEntity().then((data)=>{
		
		
    			var data = {
        			labels:["January", "February", "March", "April", "May", "June", "July", "August"],
        			datasets: [{
        				backgroundColor: "rgba(255, 99, 132, 0.5)",
        				borderColor: "rgb(255, 99, 132)",
        				hidden:false,
        				data: [1,2,3,4,5,6,7,8],
        				label: 'D0'
        			}]
        		};
        
        		var options = {
        			maintainAspectRatio: false,
        			spanGaps: false,
        			elements: {
        				line: {
        					tension: 0.000001
        				}
        			},
        			scales: {
        				yAxes: [{
        					stacked: true
        				}]
        			},
        			plugins: {
        				filler: {
        					propagate: false
        				},
        				'samples-filler-analyser': {
        					target: 'chart-analyser'
        				}
        			}
        		};
    		
    			var ctx = $("#myChart");
    			console.log('test',ctx);
    		    var myLineChart = Chart(ctx, {
    type: 'bar',
    data: {
        labels: ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"],
        datasets: [{
            label: '# of Votes',
            data: [12, 19, 3, 5, 2, 3],
            backgroundColor: [
                'rgba(255, 99, 132, 0.2)',
                'rgba(54, 162, 235, 0.2)',
                'rgba(255, 206, 86, 0.2)',
                'rgba(75, 192, 192, 0.2)',
                'rgba(153, 102, 255, 0.2)',
                'rgba(255, 159, 64, 0.2)'
            ],
            borderColor: [
                'rgba(255,99,132,1)',
                'rgba(54, 162, 235, 1)',
                'rgba(255, 206, 86, 1)',
                'rgba(75, 192, 192, 1)',
                'rgba(153, 102, 255, 1)',
                'rgba(255, 159, 64, 1)'
            ],
            borderWidth: 1
        }]
    },
    options: {
        scales: {
            yAxes: [{
                ticks: {
                    beginAtZero:true
                }
            }]
        }
    }
});
    		    
                
            });
            //this.reportCollectionConfig.addDisplayProperty()
        }
    }
}

class SWListingReport  implements ng.IDirective{

    public templateUrl;
    public restrict = 'EA';
    public scope = {};
    public bindToController =  {
        collectionConfig:"=?"
    };
    public controller = SWListingReportController;
    public controllerAs = 'swListingReport';

    //@ngInject
    constructor(
        public scopeService,
        public collectionPartialsPath,
        public hibachiPathBuilder
    ){
        this.templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.collectionPartialsPath) + "listingreport.html";
    }

    public static Factory(){
        var directive = (
            scopeService,
            listingPartialPath,
            hibachiPathBuilder
        )=> new SWListingReport(
            scopeService,
            listingPartialPath,
            hibachiPathBuilder
        );
        directive.$inject = [ 'scopeService', 'listingPartialPath', 'hibachiPathBuilder'];
        return directive;
    }
    
    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
        scope.swListingReport.openCalendarStart = function($event) {
			$event.preventDefault();
			$event.stopPropagation();
		    scope.swListingReport.openedCalendarStart = true;
		};
		
		scope.swListingReport.openCalendarEnd = function($event) {
			$event.preventDefault();
			$event.stopPropagation();
		    scope.swListingReport.openedCalendarEnd = true;
		};
		
		scope.swListingReport.openCalendarStartCompare = function($event) {
			$event.preventDefault();
			$event.stopPropagation();
		    scope.swListingReport.openedCalendarStartCompare = true;
		};
		
		scope.swListingReport.openCalendarEndCompare = function($event) {
			$event.preventDefault();
			$event.stopPropagation();
		    scope.swListingReport.openedCalendarEndCompare = true;
		};
    }
}

export{
    SWListingReport
}

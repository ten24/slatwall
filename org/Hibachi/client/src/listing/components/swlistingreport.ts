/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import { Chart, ChartData, Point } from 'chart.js';
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
    public startDateCompare:any;
    public endDateCompare:any;
    public compareReportCollectionConfig:any;
    public compareReportingData:any;
    public reportingData:any;
    public chart:Chart;
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
    
    private random_rgba = ()=>{
        let o = Math.round, r = Math.random, s = 255;
        return 'rgba(' + o(r()*s) + ',' + o(r()*s) + ',' + o(r()*s) + ',' + 1 + ')';
    }
    
    public updateComparePeriod = ()=>{
        this.compareReportCollectionConfig = this.collectionConfig.clone();
        this.compareReportCollectionConfig.setPeriodInterval(this.selectedPeriodInterval.value);
        this.compareReportCollectionConfig.setReportFlag(true);
        this.compareReportCollectionConfig.addDisplayProperty(this.selectedPeriodColumn.propertyIdentifier,'',{isHidden:true,isPeriod:true,isVisible:false});
        this.compareReportCollectionConfig.setAllRecords(true);
        this.compareReportCollectionConfig.setOrderBy(this.selectedPeriodColumn.propertyIdentifier+'|ASC');
        
        //TODO:should add as a filterGroup
        this.compareReportCollectionConfig.addFilter(this.selectedPeriodColumn.propertyIdentifier,this.startDateCompare,'>=','AND',false,true,false,'dates');
        this.compareReportCollectionConfig.addFilter(this.selectedPeriodColumn.propertyIdentifier,this.endDateCompare,'<=','AND',false,true,false,'dates');
        
        this.compareReportCollectionConfig.getEntity().then((reportingData)=>{
           this.compareReportingData = reportingData;
           this.compareReportingData.records.forEach(element=>{
               if(!this.chart.data.labels.includes(element[this.selectedPeriodColumn.name])){
                  this.chart.data.labels.push(element[this.selectedPeriodColumn.name]);
               }
           });
			this.reportCollectionConfig.columns.forEach(column=>{
			    if(column.isMetric){
			        let color = this.random_rgba();
			        let title = `${column.title} (${this.startDateCompare.toDateString()} - ${this.endDateCompare.toDateString()})`;
			        let metrics = [];
			        this.compareReportingData.records.forEach(element=>{
			             metrics.push(
    			                {
    			                    y:element[column.aggregate.aggregateAlias],
    			                    x:element[this.selectedPeriodColumn.name]
    			                }
    			      )
			        });
			        this.chart.data.datasets.push(
			            {
                        label:title,
                        data:metrics,
                        backgroundColor:color,
                        borderColor:color,
                        borderWidth: 2,
                        fill:false
                        }
			        );
			    }
			});
			this.chart.update();
        });
    }
    
    //decides if report comes from persisted collection or transient
    public getReportCollectionConfig = ()=>{
        return this.collectionConfig.clone();
    }
    
    public updatePeriod = ()=>{
        //if we have all the info we need then we can make a report
        if(
            this.selectedPeriodColumn 
            && this.selectedPeriodInterval
            && this.startDate
            && this.endDate
        ){
            
            this.reportCollectionConfig = this.getReportCollectionConfig();
            this.reportCollectionConfig.setPeriodInterval(this.selectedPeriodInterval.value);
            this.reportCollectionConfig.setReportFlag(true);
            this.reportCollectionConfig.addDisplayProperty(this.selectedPeriodColumn.propertyIdentifier,'',{isHidden:true,isPeriod:true,isVisible:false});
            this.reportCollectionConfig.setAllRecords(true);
            this.reportCollectionConfig.setOrderBy(this.selectedPeriodColumn.propertyIdentifier+'|ASC');
            
            //TODO:should add as a filterGroup
            this.reportCollectionConfig.addFilter(this.selectedPeriodColumn.propertyIdentifier,this.startDate,'>=','AND',false,true,false,'dates');
            this.reportCollectionConfig.addFilter(this.selectedPeriodColumn.propertyIdentifier,this.endDate,'<=','AND',false,true,false,'dates');
            console.log(this.reportCollectionConfig);
            this.reportCollectionConfig.getEntity().then((reportingData)=>{
		        this.reportingData = reportingData;
    			var ctx = $("#myChart");
    			var dates = [];
    			var datasets = [];
    			this.reportingData.records.forEach(element=>{dates.push(element[this.selectedPeriodColumn.name])});
    			this.reportCollectionConfig.columns.forEach(column=>{
    			    if(column.isMetric){
    			        let color = this.random_rgba();
    			        let title = `${column.title} (${this.startDate.toDateString()} - ${this.endDate.toDateString()})`;
    			        let metrics = [];
    			        this.reportingData.records.forEach(element=>{
    			            metrics.push(
    			                {
    			                    y:element[column.aggregate.aggregateAlias],
    			                    x:element[this.selectedPeriodColumn.name]
    			                }
    			            )
    			        });
    			        datasets.push(
    			            {
                            label:title,
                            data:metrics,
                            backgroundColor:color,
                            borderColor:color,
                            borderWidth: 2,
                            fill:false
                            }
    			        );
    			    }
    			});
                this.chart = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: dates,
                        datasets:datasets
                    },
                    options: {
                        events:[],
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero:true
                                }
                            }]
                        },
                        hover: {
                            animationDuration: 0
                        },
                        elements:{
                            line:{
                                tension:0
                            }
                        }
                    }
                });
                this.chart.draw();
                if(this.endDateCompare && this.startDateCompare){
                    this.updateComparePeriod();
                }
            });
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

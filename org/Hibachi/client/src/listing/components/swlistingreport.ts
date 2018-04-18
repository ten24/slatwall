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
    public persistedReportCollections:any;
    public selectedReport:any;
    public collectionNameSaveIsOpen:boolean;
    
    //@ngInject
    constructor(
        public $rootScope,
        public $hibachi,
        public metadataService,
        public listingService,
        public observerService,
        public collectionConfigService
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
        
        this.getPersistedReports();
    }

    public $onInit=()=>{
    }
    
    public getPersistedReports = ()=>{
        var persistedReportsCollectionList = this.collectionConfig.newCollectionConfig('Collection');
        persistedReportsCollectionList.setDisplayProperties('collectionID,collectionName,collectionConfig');
        persistedReportsCollectionList.addFilter('reportFlag',1);
        persistedReportsCollectionList.addFilter('collectionObject',this.collectionConfig.baseEntityName);
        console.log(persistedReportsCollectionList.filterGroups);
        persistedReportsCollectionList.addFilter('accountOwner.accountID',this.$rootScope.slatwall.account.accountID,'=','OR',true,true,false,'accountOwner');
        console.log(persistedReportsCollectionList.filterGroups);
        persistedReportsCollectionList.addFilter('accountOwner.accountID','NULL','IS','OR',true,true,false,'accountOwner');
        console.log(persistedReportsCollectionList.filterGroups);
        persistedReportsCollectionList.setAllRecords(true);
        persistedReportsCollectionList.getEntity().then((data)=>{
            this.persistedReportCollections = data.records;
        });
    }
    
    public saveReportCollection = (collectionName?)=>{
        if(collectionName){
            var serializedJSONData={
                'collectionConfig':this.reportCollectionConfig.collectionConfigString,
                'collectionName':collectionName,
                'collectionObject':this.reportCollectionConfig.baseEntityName,
                'accountOwner':{
                    'accountID':this.$rootScope.slatwall.account.accountID
                },
                'reportFlag':1
            }
            
            this.$hibachi.saveEntity(
                'Collection',
                "",
                {
                    'serializedJSONData':angular.toJson(serializedJSONData),
                    'propertyIdentifiersList':'collectionID,collectionName,collectionObject,collectionConfig'
                },
                'save'
            ).then((data)=>{
                this.getPersistedReports();
                this.selectedReport = {
                    collectionID:data.data.collectionID,
                    collectionObject:data.data.collectionObject,
                    collectionName:data.data.collectionName,
                    collectionConfig:data.data.collectionConfig
                };
                
                this.collectionNameSaveIsOpen = false;
            });
            return;
        }

        this.collectionNameSaveIsOpen = true;
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
        this.compareReportCollectionConfig.addFilter(this.selectedPeriodColumn.propertyIdentifier,this.startDateCompare,'>=','AND',true,true,false,'dates');
        this.compareReportCollectionConfig.addFilter(this.selectedPeriodColumn.propertyIdentifier,this.endDateCompare,'<=','AND',true,true,false,'dates');
        
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
    
    
    
    public selectReport = (selectedReport)=>{
        //populate inputs based on the collection
        var collectionData = angular.fromJson(selectedReport.collectionConfig);
        this.selectedPeriodInterval = {value:collectionData.periodInterval};
        
        for(var i=collectionData.filterGroups[0].filterGroup.length-1;i>=0;i--){
            var filterGroup = collectionData.filterGroups[0].filterGroup[i];
            console.log(i,filterGroup);
            
            if(filterGroup.hidden){
                if(filterGroup.comparisonOperator == '>='){
                    this.startDate = filterGroup.value;
                }else if(filterGroup.comparisonOperator == '<='){
                    this.endDate = filterGroup.value;
                }
                collectionData.filterGroups[0].filterGroup.splice(i,1);
                if(collectionData.filterGroups[0].filterGroup.length == 0){
                    delete collectionData.filterGroups[0].filterGroup;
                }
            }
        }
        
        this.selectedPeriodColumn = this.collectionConfigService.getPeriodColumnFromColumns(collectionData.columns);
        this.clearPeriodColumn(collectionData);
        this.reportCollectionConfig = this.collectionConfig.loadJson(angular.toJson(collectionData));
        this.updatePeriod();
    }
    
    public clearPeriodColumn = (collectionData)=>{
        for(var i in collectionData.columns){
            var column = collectionData.columns[i];
            if(column.isPeriod){
                collectionData.columns.splice(i,1);
            }
        }
    };
    
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
            this.reportCollectionConfig.addFilter(this.selectedPeriodColumn.propertyIdentifier,this.startDate,'>=','AND',true,true,false,'dates');
            this.reportCollectionConfig.addFilter(this.selectedPeriodColumn.propertyIdentifier,this.endDate,'<=','AND',true,true,false,'dates');
            this.reportCollectionConfig.getEntity().then((reportingData)=>{
		        this.reportingData = reportingData;
    			var ctx = $("#myChart");
    			var dates = [];
    			var datasets = [];
    			console.log(this.selectedPeriodColumn);
    			this.reportingData.records.forEach(element=>{dates.push(element[this.selectedPeriodColumn.name||this.selectedPeriodColumn.propertyIdentifier])});
    			
    			this.reportCollectionConfig.columns.forEach(column=>{
    			    if(column.isMetric){
    			        let color = this.random_rgba();
    			        let title = `${column.title} (${this.startDate.toDateString ? this.startDate.toDateString():this.startDate} - ${this.endDate.toDateString?this.endDate.toDateString():this.endDate})`;
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

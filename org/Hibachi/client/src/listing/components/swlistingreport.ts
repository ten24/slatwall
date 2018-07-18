/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import { Chart, ChartData, Point } from 'chart.js';
class SWListingReportController {
    public selectedCollectionID:string;
    public collectionName:string;
    public tableId:string;
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
    public filterPropertiesList:any;
    public hasMetric:boolean;
    public objectPath:string[]=[];
    public selectedPeriodPropertyIdentifierArray:string[]=[];
    public selectedPeriodPropertyIdentifier;
    
    //@ngInject
    constructor(
        public $timeout,
        public $rootScope,
        public $hibachi,
        public metadataService,
        public listingService,
        public observerService,
        public collectionConfigService
    ) {
        this.collectionConfig = this.collectionConfig.loadJson(this.collectionConfig.collectionConfigString);
        this.selectedPeriodPropertyIdentifierArray=[this.collectionConfig.baseEntityAlias];
        this.filterPropertiesList = {};
        
        this.getPeriodColumns()
        this.getPersistedReports();
        this.observerService.attach(this.updateReportFromListing,'filterItemAction',this.tableId);
    }
    
    public $onInit=()=>{
    }
    
    public updateReportFromListing=(params)=>{
        if(params.collectionConfig){
            this.collectionConfig = params.collectionConfig;   
            this.updatePeriod();
        }
    }
    
    public saveReportCollection = (collectionName?)=>{
        if(collectionName){
            this.collectionConfig.setPeriodInterval(this.selectedPeriodInterval.value);
            this.selectedPeriodColumn.isPeriod = true;
            this.collectionConfig.columns.push(this.selectedPeriodColumn);
            var serializedJSONData={
                'collectionConfig':this.collectionConfig.collectionConfigString,
                'collectionName':collectionName,
                'collectionObject':this.collectionConfig.baseEntityName,
                'accountOwner':{
                    'accountID':this.$rootScope.slatwall.account.accountID
                },
                'reportFlag':1
            }
            
            this.$hibachi.saveEntity(
                'Collection',
                this.selectedCollectionID || "",
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
                this.selectedCollectionID = data.data.collectionID;
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
        for(var i in this.compareReportCollectionConfig.columns){
            var column = this.compareReportCollectionConfig.columns[i];
            if(column.aggregate){
                column.isMetric = true;
            }else{
                column.isVisible = false;
            }
        }
        this.compareReportCollectionConfig.setPeriodInterval(this.selectedPeriodInterval.value);
        this.compareReportCollectionConfig.setReportFlag(1);
        this.compareReportCollectionConfig.addDisplayProperty(this.selectedPeriodColumn.propertyIdentifier,'',{isHidden:true,isPeriod:true,isVisible:false});
        this.compareReportCollectionConfig.setAllRecords(true);
        this.compareReportCollectionConfig.setOrderBy(this.selectedPeriodColumn.propertyIdentifier+'|ASC');
        
        //TODO:should add as a filterGroup
        this.compareReportCollectionConfig.addFilter(this.selectedPeriodColumn.propertyIdentifier,this.startDateCompare,'>=','AND',true,true,false,'dates');
        this.compareReportCollectionConfig.addFilter(this.selectedPeriodColumn.propertyIdentifier,this.endDateCompare,'<=','AND',true,true,false,'dates');
        
        this.compareReportCollectionConfig.getEntity().then((reportingData)=>{
           /*this.compareReportingData = reportingData;
           this.compareReportingData.records.forEach(element=>{
               if(!this.chart.data.labels.includes(element[this.selectedPeriodColumn.name])){
                  this.chart.data.labels.push(element[this.selectedPeriodColumn.name]);
               }
           });
			this.reportCollectionConfig.columns.forEach(column=>{
			    if(column.isMetric){
			        let color = this.random_rgba();
			        let title = `${column.title} (${this.startDateCompare.toDateString()} - ${new Date(this.endDateCompare).toDateString()})`;
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
			this.chart.update();*/
			var ctx = $("#myChartCompare");
			this.renderReport(reportingData,ctx)
        });
    }
    
    //decides if report comes from persisted collection or transient
    public getReportCollectionConfig = ()=>{
        var reportCollectionConfig = this.collectionConfig.clone()
        return reportCollectionConfig;
    }
    
    public selectReport = (selectedReport)=>{
        //populate inputs based on the collection
        var collectionData = angular.fromJson(selectedReport.collectionConfig);
        this.selectedCollectionID = selectedReport.collectionID;
        this.collectionName=selectedReport.collectionName;
        
        this.selectedPeriodInterval = {value:collectionData.periodInterval};
        for(var i=collectionData.filterGroups[0].filterGroup.length-1;i>=0;i--){
            var filterGroup = collectionData.filterGroups[0].filterGroup[i];
            
            if(filterGroup.filterGroupAlias && filterGroup.filterGroupAlias == 'dates'){
                var datesFilterGroup = filterGroup;
                for(var j in datesFilterGroup.filterGroup){
                    var filter = datesFilterGroup.filterGroup[j];
                    if(filter.comparisonOperator == '>='){
                        this.startDate = filter.value;
                    }else if(filter.comparisonOperator == '<='){
                        this.endDate = filter.value;
                    }
                }
                
            }
        }
        
        this.selectedPeriodColumn = this.collectionConfigService.getPeriodColumnFromColumns(collectionData.columns);
        //navigate propertyIdentifier to populate drop down
        var pidArray = this.selectedPeriodColumn.propertyIdentifier.split('.');
        for(var i=1; i <= pidArray.length-1;i++){
            var propertyName = pidArray[i];
            for(var j in this.periodColumns){
                var periodColumn = this.periodColumns[j];
                if(periodColumn.name===propertyName){
                    if(periodColumn.cfc){
                        this.selectPeriodColumn(periodColumn);
                        break;
                    }else{
                        this.selectPeriodColumn(periodColumn);
                        break;
                    }
                    
                    
                }
                
            }
            
        }
        
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
            this.hasMetric = false;
            this.reportCollectionConfig = this.getReportCollectionConfig();
            for(var i=this.reportCollectionConfig.columns.length-1; i>=0; i-- ){
                var column = this.reportCollectionConfig.columns[i];
                if(column.aggregate){
                    column.isMetric = true;
                    this.hasMetric = true;
                }else{
                    this.reportCollectionConfig.columns.splice(i,1);
                    //column.isVisible = false;
                }
            }
            if(this.hasMetric){
                this.reportCollectionConfig.setPeriodInterval(this.selectedPeriodInterval.value);
                this.reportCollectionConfig.setReportFlag(1);
                this.reportCollectionConfig.addDisplayProperty(this.selectedPeriodColumn.propertyIdentifier,'',{isHidden:true,isPeriod:true,isVisible:false});
                this.reportCollectionConfig.setAllRecords(true);
                this.reportCollectionConfig.setOrderBy(this.selectedPeriodColumn.propertyIdentifier+'|ASC');
                
                this.reportCollectionConfig.removeFilterGroupByFilterGroupAlias('dates');
                this.reportCollectionConfig.addFilter(this.selectedPeriodColumn.propertyIdentifier,this.startDate,'>=','AND',true,true,false,'dates');
                this.reportCollectionConfig.addFilter(this.selectedPeriodColumn.propertyIdentifier,this.endDate,'<=','AND',true,true,false,'dates');
                    
                this.collectionConfig.removeFilterGroupByFilterGroupAlias('dates');
                this.collectionConfig.addFilter(this.selectedPeriodColumn.propertyIdentifier,this.startDate,'>=','AND',true,true,false,'dates');
                this.collectionConfig.addFilter(this.selectedPeriodColumn.propertyIdentifier,this.endDate,'<=','AND',true,true,false,'dates');
                    
                this.observerService.notifyById('getCollection',this.tableId,{collectionConfig:this.collectionConfig.collectionConfigString});
                this.observerService.notifyById('swPaginationAction',this.tableId,{type:'setCurrentPage', payload:1});
                
                this.reportCollectionConfig.getEntity().then((reportingData)=>{
                    var ctx = $("#myChart");
        			this.renderReport(reportingData,ctx);
        			if(this.startDateCompare){
                        var diff = Math.abs(this.endDate - this.startDate);
                        this.endDateCompare = new Date(this.startDateCompare).addMilliseconds(diff).toString('MMM dd, yyyy hh:mm tt');
                        this.updateComparePeriod();
                    }
                });
            }
            
        }
    }

    public renderReport=(reportingData,ctx)=>{
        this.reportingData = reportingData;
		var dates = [];
		var datasets = [];
		this.reportingData.records.forEach(element=>{
		    var pidAliasArray = this.selectedPeriodColumn.propertyIdentifier.split('.');
		    pidAliasArray.shift();
		    var pidAlias = pidAliasArray.join('_');
		    dates.push(element[pidAlias]);
		});
		
		this.reportCollectionConfig.columns.forEach(column=>{
		    if(column.isMetric){
		        let color = this.random_rgba();
		        let title = `${column.title}`;
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
		//used to clear old rendered charts before adding new ones
		if(this.chart!=null){
            this.chart.destroy();
        }
		
        this.chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: dates,
                datasets:datasets,
                spanGaps:true
            },
            options: {
                responsive: true,
                title:{
                  display:true,
                  text:`(${this.startDate.toDateString ? this.startDate.toDateString():this.startDate} - ${this.endDate.toDateString?this.endDate.toDateString():this.endDate})`
                },
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero:true
                        }
                    }],
                    xAxes: [{
                      display: true,
                      scaleLabel: {
                        labelString:this.selectedPeriodInterval.value,
                        display: true,
                      },
                    }]
                },
                tooltips: {
                    mode: 'index',
                    intersect: false,
                },
                hover: {
                    intersect: true,
                    mode:'nearest',
                },
                elements:{
                    line:{
                        tension:0
                    }
                }
            }
        });
        
        this.chart.draw();
    }
    
    public popObjectPath=()=>{
        if(this.objectPath.length > 1){
            this.objectPath.pop();
            this.selectedPeriodPropertyIdentifierArray.pop();
            this.getPeriodColumns(this.objectPath[this.objectPath.length-1],false);
        }
    }
    
    public getPeriodColumns=(baseEntityAlias=this.collectionConfig.baseEntityAlias,adding=true)=>{
        if(adding){
            
            this.objectPath.push(baseEntityAlias);
        }
        
        
        //get meta data we need for existing columns

        this.$hibachi.getFilterPropertiesByBaseEntityName(baseEntityAlias).then((value)=> {
            this.metadataService.setPropertiesList(value, baseEntityAlias);
            this.filterPropertiesList[baseEntityAlias] = this.metadataService.getPropertiesListByBaseEntityAlias(baseEntityAlias);
            this.metadataService.formatPropertiesList(this.filterPropertiesList[baseEntityAlias], baseEntityAlias);
            
            //figure out all the possible periods
            var columns = {};
            columns[baseEntityAlias] = angular.copy(this.metadataService.getPropertiesListByBaseEntityAlias(baseEntityAlias));
            this.periodColumns = [];
            for(var i in columns[baseEntityAlias].data){
                var column = columns[baseEntityAlias].data[i];
                if((column.ormtype && column.ormtype == 'timestamp') || (column.fieldtype && ['one-to-many','many-to-many','id'].indexOf(column.fieldtype) == -1 )){
                    this.periodColumns.push(column);
                }
            }
        });
        
    }
    
    public selectPeriodColumn=(column)=>{
        if(column && column.cfc){
            this.selectedPeriodPropertyIdentifierArray.push(column.name);
            (async ()=>await this.getPeriodColumns(column.cfc));
        }else if(column && column.name){
            this.selectedPeriodPropertyIdentifier = this.selectedPeriodPropertyIdentifierArray.join('.')+'.'+column.name;
            //update the option so it remains selected
            for(var i in this.periodColumns){
                if(column.name === this.periodColumns[i].name){
                    this.periodColumns[i].isPeriod = true;
                    this.periodColumns[i].propertyIdentifier = this.selectedPeriodPropertyIdentifier;
                }
            }
            
            column.propertyIdentifier = this.selectedPeriodPropertyIdentifier;
            column.isPeriod = true;
            
            this.selectedPeriodColumn = column;
            this.updatePeriod();
        }
    }

    public getPersistedReports = ()=>{
        var persistedReportsCollectionList = this.collectionConfig.newCollectionConfig('Collection');
        persistedReportsCollectionList.setDisplayProperties('collectionID,collectionName,collectionConfig');
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

class SWListingReport  implements ng.IDirective{

    public templateUrl;
    public restrict = 'EA';
    public scope = {};
    public bindToController =  {
        collectionConfig:"=?",
        tableId:"@?"
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

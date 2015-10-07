/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWExpandableRecordController{
        public static $inject = ['$scope','$element','utilityService','$slatwall','collectionConfigService'];
//        public childrenLoaded = false;
//        public childrenOpen = false;
//        public record;
//        public recordID;
        constructor(private utilityService:slatwalladmin.UtilityService, private $slatwall:ngSlatwall.SlatwallService,collectionConfigService){
            this.$slatwall = $slatwall;
			this.utilityService = utilityService;
            this.collectionConfigService = collectionConfigService;
//            this.tdElement = this.$element.parent();
//            this.record = this.records[this.recordIndex];
//            this.recordID = this.record[this.entity.$$getIDName()];
//            this.$element.bind('click', this.toggleChild);
        }
        
//        public toggleChild = ()=>{
//            this.childrenOpen = !this.childrenOpen;
//            console.log('toggleChild');
//            console.log(this.childrenOpen);
//            if(!this.childrenLoaded){
//                
//                var childCollectionConfig = this.collectionConfigService.newCollectionConfig(this.entity.metaData.className);
//                var parentName = this.entity.metaData.hb_parentPropertyName;
//                var parentCFC = this.entity.metaData[parentName].cfc;
//                var parentIDName = this.$slatwall.getEntityExample(parentCFC).$$getIDName();
//                childCollectionConfig.clearFilterGroups(); 
//                childCollectionConfig.collection = this.entity;
//                childCollectionConfig.addFilter(parentName+'.'+parentIDName,this.id);
//                childCollectionConfig.setAllRecords(true);
//                childCollectionConfig.columns = this.collectionConfig.columns;
//                console.log(childCollectionConfig);
//                this.collectionPromise = childCollectionConfig.getEntity();
//                
//                this.collectionPromise.then((data)=>{
//                    this.collectionData = data;
//                    this.collectionData.pageRecords = this.collectionData.pageRecords || this.collectionData.records
//                   /* if(this.collectionData.pageRecords.length){
//                        angular.forEach(this.collectionData.pageRecords,(pageRecord)=>{
//                            pageRecord.dataparentID = this.recordID;
//                            pageRecord.depth = this.recordDepth || 0;
//                            pageRecord.depth++;
//                            this.records.splice(this.recordIndex+1,0,pageRecord);
//                        });
//                    }*/
//                    
//                    
//                    console.log('page records');
//                    console.log(this.records);
//                    console.log(this.recordIndex);
//                    this.childrenLoaded = true;
//                    
//                    //this.init();
//                });    
//            }
//            
//            /*angular.forEach(this.records,(record)=>{
//               if(record.dataparentID === this.recordID){
//                record.dataIsVisible = false;    
//               }
//            });*/
//            
//            
//            //return this.collectionPromise;
//        }
        
        
    }
        
	export class SWExpandableRecord implements ng.IDirective{
		public restrict:string = 'EA';
        public scope={};  
		public bindToController={
            id:"=",
            entity:"=",
            collectionConfig:"=",
            recordIndex:"=",
            records:"=",
            recordDepth:"=",
            expandable:"="
        };
        
        public controller=SWExpandableRecordController;
        public controllerAs="swExpandableRecord";
        public static $inject = ['$compile'];
		constructor(private $compile:ng.ICompileService){
            this.$compile = $compile;
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
            console.log('expandable');
            console.log(scope.expandable);
            if(scope.expandable){
                console.log('this');
                var html = $compile('expandable')(scope);
                console.log(html);
               element.html(html);
                /*<i  ng-if="column.tdclass === 'primary' && swListingDisplay.expandable"
                        ng-class="{
                            'fa-caret-down':swExpandableRecordController.childrenOpen,
                            'fa-caret-right':!swExpandableRecordController.childrenOpen
                        }"
                        class="fa {{swListingDisplay.edit ? '' : 'disabled'}} s-listing-arrow"
                    >
                    {{swExpandableRecordCtrl.childrenOpen}}
                    </i> 
                    <a ng-if="swListingDisplay.recordEditAction && column.tdclass  && column.tdclass === 'primary' && swListingDisplay.expandable" ng-href="{{$root.buildUrl(swListingDisplay.recordEditAction,swListingDisplay.recordEditQueryString)}}" class="s-contents-page-title">
                        <span ng-bind="pageRecord[swListingDisplay.getPageRecordKey(column.propertyIdentifier)]"></span>
                    </a>
                    <span ng-if="!swListingDisplay.recordEditAction || !column.tdclass || !column.tdclass === 'primary' || !swListingDisplay.expandable" ng-bind="pageRecord[swListingDisplay.getPageRecordKey(column.propertyIdentifier)]"></span>
            */
           
            }else{
                console.log('compile');
                var html = $compile('notexpandable')(scope);
                console.log(html);
                element.html(html);
            }
		}
	}
    
	angular.module('slatwalladmin').directive('swExpandableRecord',['$compile',($compile) => new SWExpandableRecord($compile)]);
}


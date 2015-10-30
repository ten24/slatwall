/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
   
    
    export class SWExpandableRecordController{
        public static $inject = ['$timeout','utilityService','$slatwall','collectionConfigService'];
        public childrenLoaded = false;
        public childrenOpen = false;
        public children = [];
        constructor(private $timeout:ng.ITimeoutService, private utilityService:slatwalladmin.UtilityService, private $slatwall:ngSlatwall.SlatwallService, private collectionConfigService){
            this.$timeout = $timeout;
            this.$slatwall = $slatwall;
			this.utilityService = utilityService;
            this.collectionConfigService = collectionConfigService;
        }
        public toggleChild = ()=>{
           this.$timeout(()=>{
               this.childrenOpen = !this.childrenOpen;
                if(!this.childrenLoaded){
                       var childCollectionConfig = this.collectionConfigService.newCollectionConfig(this.entity.metaData.className);
                       //set up parent
                       var parentName = this.entity.metaData.hb_parentPropertyName;
                       var parentCFC = this.entity.metaData[parentName].cfc;
                       var parentIDName = this.$slatwall.getEntityExample(parentCFC).$$getIDName();
                       //set up child
                       var childName = this.entity.metaData.hb_childPropertyName;
                       var childCFC = this.entity.metaData[childName].cfc
                       var childIDName = this.$slatwall.getEntityExample(childCFC).$$getIDName();
                    
                       childCollectionConfig.clearFilterGroups(); 
                       childCollectionConfig.collection = this.entity;
                       childCollectionConfig.addFilter(parentName+'.'+parentIDName,this.parentId);
                       childCollectionConfig.setAllRecords(true);
                       angular.forEach(this.collectionConfig.columns,(column)=>{
                           childCollectionConfig.addColumn(column.propertyIdentifier,column.tilte,column);
                       });
                    
                        angular.forEach(this.collectionConfig.joins,(join)=>{
                           childCollectionConfig.addJoin(join); 
                        });
                        childCollectionConfig.groupBys = this.collectionConfig.groupBys;
                       this.collectionPromise = childCollectionConfig.getEntity();
                    
                       this.collectionPromise.then((data)=>{
                           this.collectionData = data;
                           this.collectionData.pageRecords = this.collectionData.pageRecords || this.collectionData.records
                           if(this.collectionData.pageRecords.length){
                               angular.forEach(this.collectionData.pageRecords,(pageRecord)=>{
                                   pageRecord.dataparentID = this.recordID;
                                   pageRecord.depth = this.recordDepth || 0;
                                   pageRecord.depth++;
                                   this.children.push(pageRecord);
                                   this.records.splice(this.recordIndex+1,0,pageRecord);
                               });
                           }
                           this.childrenLoaded = true;
                       });    
                }
                
                angular.forEach(this.children,(child)=>{
                    child.dataIsVisible=this.childrenOpen;
                });
           });   
       }
    }
        
	export class SWExpandableRecord implements ng.IDirective{
		public restrict:string = 'EA';
        public scope={};  
		public bindToController={
            recordValue:"=",
            link:"@",
            expandable:"=",
            parentId:"=",
            entity:"=",
            collectionConfig:"=",
            records:"=",
            recordIndex:"=",
            recordDepth:"=",
            childCount:"=",
            autoOpen:"=",
            multiselectIdPaths:"="
        };
        
        public controller=SWExpandableRecordController;
        public controllerAs="swExpandableRecord";
        public static $inject = ['$compile','$templateRequest','$timeout','partialsPath','utilityService'];
		constructor(private $compile:ng.ICompileService, private $templateRequest:ng.ITemplateRequestService, private $timeout:ng.ITimeoutService, private partialsPath:slatwalladmin.partialsPath,private utilityService){
            this.$compile = $compile;
            this.$templateRequest = $templateRequest;
            this.partialsPath = partialsPath;
            this.$timeout = $timeout;
            this.utilityService = utilityService;
		}
        
        
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
            if(scope.swExpandableRecord.expandable && scope.swExpandableRecord.childCount){
                if(scope.swExpandableRecord.recordValue){
                    var id = scope.swExpandableRecord.records[scope.swExpandableRecord.recordIndex][scope.swExpandableRecord.entity.$$getIDName()];
                    if(scope.swExpandableRecord.multiselectIdPaths && scope.swExpandableRecord.multiselectIdPaths.length){
                        var multiselectIdPathsArray = scope.swExpandableRecord.multiselectIdPaths.split(',');
                        angular.forEach(multiselectIdPathsArray,(multiselectIdPath)=>{
                            var position = this.utilityService.listFind(multiselectIdPath,id,'/');
                            var multiselectPathLength = multiselectIdPath.split('/').length;
                            if(position !== -1 && position < multiselectPathLength -1){
                                scope.swExpandableRecord.toggleChild();
                            }
                        });
                    }
                }
                 
                $templateRequest(partialsPath+"expandablerecord.html").then((html)=>{
                    var template = angular.element(html);
                    
                    //get autoopen reference to ensure only the root is autoopenable
                    var autoOpen = angular.copy(scope.swExpandableRecord.autoOpen);
                    scope.swExpandableRecord.autoOpen = false;
                    template = $compile(template)(scope);
                    element.html(template);
                    element.on('click',scope.swExpandableRecord.toggleChild);
                    if(autoOpen){
                        scope.swExpandableRecord.toggleChild();    
                    }
                });
            }
            
            
		}
	}
    
	angular.module('slatwalladmin').directive('swExpandableRecord',['$compile','$templateRequest','$timeout','partialsPath','utilityService',($compile,$templateRequest,$timeout,partialsPath,utilityService) => new SWExpandableRecord($compile,$templateRequest,$timeout,partialsPath,utilityService)]);
}


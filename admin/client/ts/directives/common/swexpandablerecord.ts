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
                       var parentName = this.entity.metaData.hb_parentPropertyName;
                       var parentCFC = this.entity.metaData[parentName].cfc;
                       var parentIDName = this.$slatwall.getEntityExample(parentCFC).$$getIDName();
                       childCollectionConfig.clearFilterGroups(); 
                       childCollectionConfig.collection = this.entity;
                       childCollectionConfig.addFilter(parentName+'.'+parentIDName,this.parentId);
                       childCollectionConfig.setAllRecords(true);
                       childCollectionConfig.columns = this.collectionConfig.columns;
                       console.log(childCollectionConfig);
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
            recordDepth:"="
        };
        
        public controller=SWExpandableRecordController;
        public controllerAs="swExpandableRecord";
        public static $inject = ['$compile','$templateRequest','$timeout','partialsPath'];
		constructor(private $compile:ng.ICompileService, private $templateRequest:ng.ITemplateRequestService, private $timeout:ng.ITimeoutService, private partialsPath:slatwalladmin.partialsPath){
            this.$compile = $compile;
            this.$templateRequest = $templateRequest;
            this.partialsPath = partialsPath;
            this.$timeout = $timeout;
            
            
		}
        
        
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
            
            if(scope.swExpandableRecord.expandable){
                $templateRequest(partialsPath+"expandablerecord.html").then((html)=>{
                    var template = angular.element(html);
                    
                    template = $compile(template)(scope);
                    element.html(template);
                    element.on('click',scope.swExpandableRecord.toggleChild);
                });
            }
            
		}
	}
    
	angular.module('slatwalladmin').directive('swExpandableRecord',['$compile','$templateRequest','$timeout','partialsPath',($compile,$templateRequest,$timeout,partialsPath) => new SWExpandableRecord($compile,$templateRequest,$timeout,partialsPath)]);
}


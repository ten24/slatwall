/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWExpandableRecordController{
    public static $inject = ['$timeout','utilityService','$hibachi','collectionConfigService'];
    public childrenLoaded = false;
    public childrenOpen = false;
    public children = [];
    public recordDepth:number;
    public records:any;
    public recordID:string;
    public recordIndex:number;
    public collectionData:any;
    public collectionPromise:any;
    public collectionConfig:any;
    public parentId:string;
    public entity:any
    //@ngInject
    constructor(private $timeout:ng.ITimeoutService, private utilityService, private $hibachi, private collectionConfigService){
        this.$timeout = $timeout;
        this.$hibachi = $hibachi;
        this.utilityService = utilityService;
        this.collectionConfigService = collectionConfigService;
        this.recordID = this.parentId; //this is what parent is initalized to in the listing display
    }
    public toggleChild = ()=>{
        this.$timeout(()=>{
            this.childrenOpen = !this.childrenOpen;
            if(!this.childrenLoaded){
                    var childCollectionConfig = this.collectionConfigService.newCollectionConfig(this.entity.metaData.className);
                    //set up parent
                    var parentName = this.entity.metaData.hb_parentPropertyName;
                    var parentCFC = this.entity.metaData[parentName].cfc;
                    var parentIDName = this.$hibachi.getEntityExample(parentCFC).$$getIDName();
                    //set up child
                    var childName = this.entity.metaData.hb_childPropertyName;
                    var childCFC = this.entity.metaData[childName].cfc
                    var childIDName = this.$hibachi.getEntityExample(childCFC).$$getIDName();

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
                                //push the children into the listing display
                                this.children.push(pageRecord);
                                this.records.splice(this.recordIndex+1,0,pageRecord);
                            });
                        }
                        this.childrenLoaded = true;
                    });
            }

            angular.forEach(this.children,(child)=>{
                child.dataIsVisible=this.childrenOpen;
                var entityPrimaryID = this.entity.$$getIDName();
                var idsToCheck = [];
                idsToCheck.push(child[entityPrimaryID]);
                //close all children of the child if we are closing
                var childrenTraversed = false; 
                var recordLength = this.records.length; 
                while(!childrenTraversed && idsToCheck.length > 0){
                    var found = false; 
                    var idToCheck = idsToCheck.pop();
                    for(var i=0; i < recordLength; i++){
                        var record = this.records[i]; 
                        if(record['dataparentID'] == idToCheck ){
                            idsToCheck.push(record[entityPrimaryID]);
                            record.dataIsVisible=this.childrenOpen;
                            found=true; 
                        }
                    }
                    if(!found){
                        childrenTraversed = true; 
                    }
                }
            });
        });
    }
}

class SWExpandableRecord implements ng.IDirective{
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

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            $compile:ng.ICompileService,
            $templateRequest:ng.ITemplateRequestService,
            $timeout:ng.ITimeoutService,
            corePartialsPath,
            utilityService,
			hibachiPathBuilder
        ) => new SWExpandableRecord(
            $compile,
            $templateRequest,
            $timeout,
            corePartialsPath,
            utilityService,
			hibachiPathBuilder
        );
        directive.$inject = [
            '$compile',
            '$templateRequest',
            '$timeout',
            'corePartialsPath',
            'utilityService',
			'hibachiPathBuilder'
        ];
        return directive;
    }

    public controller=SWExpandableRecordController;
    public controllerAs="swExpandableRecord";
    public static $inject = ['$compile','$templateRequest','$timeout','corePartialsPath','utilityService',
			'hibachiPathBuilder'];
    constructor(
        public $compile:ng.ICompileService,
        public $templateRequest:ng.ITemplateRequestService,
        public $timeout:ng.ITimeoutService,
        public corePartialsPath,
        public utilityService,
		public hibachiPathBuilder
     ){
        this.$compile = $compile;
        this.$templateRequest = $templateRequest;
        this.corePartialsPath = corePartialsPath;
        this.$timeout = $timeout;
        this.utilityService = utilityService;
        this.hibachiPathBuilder = hibachiPathBuilder;
    }

    public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any) =>{
        if(scope.swExpandableRecord.expandable && scope.swExpandableRecord.childCount){
            if(scope.swExpandableRecord.recordValue){
                var id = scope.swExpandableRecord.records[scope.swExpandableRecord.recordIndex][scope.swExpandableRecord.entity.$$getIDName()];
                if(scope.swExpandableRecord.multiselectIdPaths && scope.swExpandableRecord.multiselectIdPaths.length){
                    var multiselectIdPathsArray = scope.swExpandableRecord.multiselectIdPaths.split(',');
                    if(scope.swExpandableRecord.childrenLoaded){
                        angular.forEach(multiselectIdPathsArray,(multiselectIdPath)=>{
                            var position = this.utilityService.listFind(multiselectIdPath,id,'/');
                            var multiselectPathLength = multiselectIdPath.split('/').length;
                            if(position !== -1 && position < multiselectPathLength -1){
                                scope.swExpandableRecord.toggleChild();
                            }
                        });
                    }else{
                        scope.swExpandableRecord.toggleChild();
                    }
                    
                }
            }
           

            this.$templateRequest(this.hibachiPathBuilder.buildPartialsPath(this.corePartialsPath)+"expandablerecord.html").then((html)=>{
                var template = angular.element(html);

                //get autoopen reference to ensure only the root is autoopenable
                var autoOpen = angular.copy(scope.swExpandableRecord.autoOpen);
                scope.swExpandableRecord.autoOpen = false;
                template = this.$compile(template)(scope);
                element.html(template);
                element.on('click',scope.swExpandableRecord.toggleChild);
                if(autoOpen){
                    scope.swExpandableRecord.toggleChild();
                }
            });
        }


    }
}
export{
    SWExpandableRecord
}


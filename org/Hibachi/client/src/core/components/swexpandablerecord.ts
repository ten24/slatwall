/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWExpandableRecordController{

    public childrenLoaded = false;
    public childrenOpen = false;
    public children = [];
    public pageRecord;
    public expandable:boolean;
    public recordDepth:number;
    public records:any;
    public recordID:string;
    public recordIndex:number;
    public collectionData:any;
    public collectionPromise:any;
    public collectionConfig:any;
    public childCollectionConfig:any;
    public parentId:string;
    public parentIDName:string;
    public entity:any
    public listingId:string;
    public refreshChildrenEvent
    public expandableRules;

    //@ngInject
    constructor(private $timeout:ng.ITimeoutService,
                private $hibachi,
                private utilityService,
                private collectionConfigService,
                private expandableService,
                private listingService,
                private observerService){

        this.recordID = this.parentId; //this is what parent is initalized to in the listing display
        expandableService.addRecord(this.recordID);
        if(angular.isDefined(this.refreshChildrenEvent) && this.refreshChildrenEvent.length){
            this.observerService.attach(this.refreshChildren, this.refreshChildrenEvent)
        }

    }

    public refreshChildren = () =>{
        this.getEntity();
    }

    public setupChildCollectionConfig = () =>{

        this.childCollectionConfig = this.collectionConfigService.newCollectionConfig(this.entity.metaData.className);
        //set up parent
        var parentName = this.entity.metaData.hb_parentPropertyName;
        var parentCFC = this.entity.metaData[parentName].cfc;
        this.parentIDName = this.$hibachi.getEntityExample(parentCFC).$$getIDName();
        //set up child
        var childName = this.entity.metaData.hb_childPropertyName;
        var childCFC = this.entity.metaData[childName].cfc
        var childIDName = this.$hibachi.getEntityExample(childCFC).$$getIDName();

        this.childCollectionConfig.clearFilterGroups();
        this.childCollectionConfig.collection = this.entity;
        this.childCollectionConfig.addFilter(parentName+'.'+ this.parentIDName,this.parentId);
        this.childCollectionConfig.setAllRecords(true);
        angular.forEach(this.collectionConfig.columns,(column)=>{
            this.childCollectionConfig.addColumn(column.propertyIdentifier,column.title,column);
        });

        angular.forEach(this.collectionConfig.joins,(join)=>{
            this.childCollectionConfig.addJoin(join);
        });
        this.childCollectionConfig.groupBys = this.collectionConfig.groupBys;
    }

    public getEntity = ()=>{
         this.collectionPromise.then((data)=>{
            this.collectionData = data;
            this.collectionData.pageRecords = this.collectionData.pageRecords || this.collectionData.records
            if(this.collectionData.pageRecords.length){
                angular.forEach(this.collectionData.pageRecords,(pageRecord)=>{
                    this.expandableService.addRecord(pageRecord[this.parentIDName],true);
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

    public toggleChild = ()=>{
        this.$timeout(()=>{
            this.childrenOpen = !this.childrenOpen;
            this.expandableService.updateState(this.recordID,{isOpen:this.childrenOpen});
            if(!this.childrenLoaded){
                    if(this.childCollectionConfig == null){
                        this.setupChildCollectionConfig();
                    }
                    if(angular.isFunction(this.childCollectionConfig.getEntity)){
                        this.collectionPromise = this.childCollectionConfig.getEntity();
                    }
                    this.getEntity();
            }
            angular.forEach(this.children,(child)=>{
                child.dataIsVisible=this.childrenOpen;
                var entityPrimaryIDName = this.entity.$$getIDName();
                var idsToCheck = [];
                idsToCheck.push(child[entityPrimaryIDName]);
                this.expandableService.updateState(child[entityPrimaryIDName], {isOpen:this.childrenOpen})
                //close all children of the child if we are closing
                var childrenTraversed = false;
                var recordLength = this.records.length;
                while(!childrenTraversed && idsToCheck.length > 0){
                    var found = false;
                    var idToCheck = idsToCheck.pop();
                    for(var i=0; i < recordLength; i++){
                        var record = this.records[i];
                        if(record['dataparentID'] == idToCheck ){
                            idsToCheck.push(record[entityPrimaryIDName]);
                            this.expandableService.updateState(record[entityPrimaryIDName], {isOpen:this.childrenOpen})
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
        expandable:"=?",
        parentId:"=",
        entity:"=",
        collectionConfig:"=?",
        childCollectionConfig:"=?",
        refreshChildrenEvent:"=?",
        listingId:"@?",
        records:"=",
        pageRecord:"=",
        recordIndex:"=",
        recordDepth:"=",
        childCount:"=",
        autoOpen:"=",
        multiselectIdPaths:"=",
        expandableRules:"="
    };

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            $compile:ng.ICompileService,
            $templateRequest:ng.ITemplateRequestService,
            $timeout:ng.ITimeoutService,
            corePartialsPath,
            utilityService,
            expandableService,
			hibachiPathBuilder
        ) => new SWExpandableRecord(
            $compile,
            $templateRequest,
            $timeout,
            corePartialsPath,
            utilityService,
            expandableService,
			hibachiPathBuilder
        );
        directive.$inject = [
            '$compile',
            '$templateRequest',
            '$timeout',
            'corePartialsPath',
            'utilityService',
            'expandableService',
			'hibachiPathBuilder'
        ];
        return directive;
    }

    public controller=SWExpandableRecordController;
    public controllerAs="swExpandableRecord";
    //@ngInject
    constructor(
        public $compile:ng.ICompileService,
        public $templateRequest:ng.ITemplateRequestService,
        public $timeout:ng.ITimeoutService,
        public corePartialsPath,
        public utilityService,
        public expandableService,
		public hibachiPathBuilder
     ){
        this.$compile = $compile;
        this.$templateRequest = $templateRequest;
        this.corePartialsPath = corePartialsPath;
        this.$timeout = $timeout;
        this.utilityService = utilityService;
        this.expandableService = expandableService;
        this.hibachiPathBuilder = hibachiPathBuilder;
    }

    public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any) =>{
        if(scope.swExpandableRecord.expandable && scope.swExpandableRecord.childCount){
            if(scope.swExpandableRecord.recordValue){
                var id = scope.swExpandableRecord.records[scope.swExpandableRecord.recordIndex][scope.swExpandableRecord.entity.$$getIDName()];
                if(scope.swExpandableRecord.multiselectIdPaths && scope.swExpandableRecord.multiselectIdPaths.length){
                    var multiselectIdPathsArray = scope.swExpandableRecord.multiselectIdPaths.split(',');
                    if(!scope.swExpandableRecord.childrenLoaded){
                        angular.forEach(multiselectIdPathsArray,(multiselectIdPath)=>{
                            var position = this.utilityService.listFind(multiselectIdPath,id,'/');
                            var multiSelectIDs =  multiselectIdPath.split('/');
                            var multiselectPathLength = multiSelectIDs.length;
                            if(position !== -1 && position < multiselectPathLength - 1 && !this.expandableService.getState(id,"isOpen")){
                                this.expandableService.updateState(id,{isOpen:true});
                                scope.swExpandableRecord.toggleChild();
                            }
                        });
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


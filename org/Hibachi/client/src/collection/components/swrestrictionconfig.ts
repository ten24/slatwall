/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWRestrictionConfigController{
    public collectionConfigString:string;
    public collectionConfig:any
    public permissionRecordRestrictionId:string;
    public permissionRecordRestriction:any;
    //@ngInject
    constructor(
        public $timeout,
        public collectionConfigService,
        public $hibachi,
        public observerService

    ){
        var permissionRecordRestrictionRequest = this.$hibachi.getPermissionRecordRestriction(this.permissionRecordRestrictionId);

        permissionRecordRestrictionRequest.promise.then(()=>{
            var collectionConfig = this.collectionConfigService.newCollectionConfig();
            this.permissionRecordRestriction = permissionRecordRestrictionRequest.value;
            collectionConfig.loadJson(this.permissionRecordRestriction.collectionConfig);
            this.collectionConfig = collectionConfig;
        });

        observerService.attach(this.setCollectionConfig,'saveCollection');


    }

    public $onDestroy = ()=>{
        this.observerService.detachByEvent('saveCollection');
    }

    public setCollectionConfig=(payload)=>{

        this.permissionRecordRestriction.data.collectionConfig = angular.toJson(payload.collectionConfig.getCollectionConfig());

        this.permissionRecordRestriction.forms['permissionRecordRestrictionForm'].collectionConfig.$setViewValue(payload.collectionConfig.getCollectionConfig());
        this.permissionRecordRestriction.forms['permissionRecordRestrictionForm'].$setDirty(true);
        this.permissionRecordRestriction.$$save();


    };
}

 class SWRestrictionConfig implements ng.IDirective{

    public template = require('./restrictionconfig.html');
    
    public restrict:string = 'E';
    public scope = {};
    public bindToController={
        permissionRecordRestrictionId:"@?"
    };
    public controller=SWRestrictionConfigController;
    public controllerAs="swRestrictionConfig";
    public static Factory():ng.IDirectiveFactory{
        return () => new this();
    }
}


export {
    SWRestrictionConfig
};

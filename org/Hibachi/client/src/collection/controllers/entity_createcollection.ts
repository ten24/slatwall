/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class CollectionCreateController {
    public collection;


    //@ngInject
    constructor(
        public $scope,
        public collectionConfigService
    ) {
        this.$scope.entity_createcollectionCtrl = {};
        this.$scope.entity_createcollectionCtrl.baseCollections = [];

        this.collection = this.collectionConfigService.newCollectionConfig('Collection');
        this.getBaseCollections('Access');


        //on select change get collection
        this.$scope.entity_createcollectionCtrl.collectionObjectChanged = ()=>{
            console.log(this.$scope.entity_createcollectionCtrl.selectedOption);
            this.getBaseCollections(this.$scope.entity_createcollectionCtrl.selectedOption);
        }


    }

    public getBaseCollections(baseCollectionObject){
        this.collection.clearFilters();
        this.collection.addFilter('collectionObject', baseCollectionObject);
        this.collection.getEntity().then((res)=>{
            this.$scope.entity_createcollectionCtrl.baseCollections = res.pageRecords;
        })
    }


}
export{CollectionCreateController}

import {OrderService as SWOrderService} from "../../../../../../org/Hibachi/client/src/core/services/orderservice"

class OrderService extends SWOrderService{
    public entity:any;

    //@ngInject
    constructor(
        public $injector:ng.auto.IInjectorService,
        public $hibachi,
        public utilityService
    ){
        super($injector,$hibachi,utilityService);
    }
    
    /**
     * Creates a batch. This should use api:main.post with a context of process and an entityName instead of doAction.
     */
    public addVolumeRebuildBatch = (processObject) => {
        if (processObject) {
            processObject.data.entityName = "VolumeRebuildBatch";
            processObject.data['volumeRebuildBatch'] = {};
            processObject.data['volumeRebuildBatch']['volumeRebuildBatchID'] = "";
            
            return this.$hibachi.saveEntity("volumeRebuildBatch",'',processObject.data, "create");
        }
    }
    
}
export {
    OrderService
}
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWProductDeliveryScheduleDatesController {

    public productId:string;
    public componentId:string;
    public currentDateTime:any;
    public deliverScheduleDates;

    //@ngInject
    constructor(
        public $scope,
        public collectionConfigService
    ){
        
        this.getDeliveryScheduleDates();
        this.$scope.$watch('swProductDeliveryScheduleDates.deliverScheduleDates',(newValue,oldValue)=>{
            if(newValue && newValue != oldValue){
                this.sortDeliveryScheduleDates();
            }
        })
        this.currentDateTime = Date.today();
        console.log(this.currentDateTime,'test'); 
    }
    
    public sortDeliveryScheduleDates=()=>{
        this.deliverScheduleDates.sort((a, b)=> {
            
            var a1:any = Date.parse(a.deliveryScheduleDateValue);
            a1 = a1.getTime();
            var b1:any = Date.parse(b.deliveryScheduleDateValue);
            b1 = b1.getTime()
            if (a1 > b1) return 1;
            if (a1 < b1) return -1;
            return 0;
            
        });
    }
    
    public removeDeliveryScheduleDate=(index)=>{
        this.deliverScheduleDates.splice(index,1);
        this.sortDeliveryScheduleDates();  
    }
    
    public getDeliveryScheduleDates=()=>{
        console.log(this.collectionConfigService);
        var deliveryScheduleDateCollection = this.collectionConfigService.newCollectionConfig('DeliveryScheduleDate');
        deliveryScheduleDateCollection.addFilter('product.productID',this.productId);
        deliveryScheduleDateCollection.setAllRecords(true);
        deliveryScheduleDateCollection.getEntity().then((data)=>{
            this.deliverScheduleDates = data.records;
            for(var i in this.deliverScheduleDates){
                this.deliverScheduleDates[i].formattedDate = Date.parse(this.deliverScheduleDates[i].deliveryScheduleDateValue);
            }
        });
        
    }
    
    public addDate=(newDeliverScheduleDate)=>{
        if(newDeliverScheduleDate.deliveryScheduleDateValue){
            var deliverScheduleDate = angular.copy(newDeliverScheduleDate);
            deliverScheduleDate.deliveryScheduleDateValue = deliverScheduleDate.deliveryScheduleDateValue.toString().slice(0,24)
            this.deliverScheduleDates.push(deliverScheduleDate);
            this.sortDeliveryScheduleDates();    
        }
        
    }
}

class SWProductDeliveryScheduleDates implements ng.IDirective{

    public templateUrl; 
    public restrict = "EA";
    public scope = {};  
    
    public bindToController = {
        productId:"@",
        edit:"="
    };
    
    public controller=SWProductDeliveryScheduleDatesController;
    public controllerAs="swProductDeliveryScheduleDates";
    
	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    productPartialsPath,
			slatwallPathBuilder
        ) => new SWProductDeliveryScheduleDates(
			productPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
			'productPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    
    //@ngInject
	constructor(
	    private productPartialsPath,
		private slatwallPathBuilder
	){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(productPartialsPath) + "/productdeliveryscheduledates.html";
    }

    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
        scope.openCalendarStart = function($event) {
			$event.preventDefault();
			$event.stopPropagation();
		    scope.openedCalendarStart = true;
		};

		scope.openCalendarEnd = function($event) {
			$event.preventDefault();
			$event.stopPropagation();
		    scope.openedCalendarEnd = true;
		};
    }
}

export {
	SWProductDeliveryScheduleDatesController,
	SWProductDeliveryScheduleDates
};

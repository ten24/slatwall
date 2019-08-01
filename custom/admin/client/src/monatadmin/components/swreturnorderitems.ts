class SWReturnOrderItemsController{
    public orderItems:Array<Object> = [];
    
    constructor(
        public $hibachi
    ){
    }

    public updateOrderItem = (orderItem) => {
       
       orderItem = this.setValuesWithinConstraints(orderItem);
    //   debugger;
       orderItem.refundTotal = orderItem.returnQuantity * orderItem.refundUnitPrice;
       orderItem.refundPVTotal = orderItem.refundTotal * orderItem.personalVolumeTotal / orderItem.total;
       orderItem.refundCVTotal = orderItem.refundTotal * orderItem.commissionableVolumeTotal / orderItem.total;
   }
   
   private setValuesWithinConstraints = (orderItem)=>{
       var returnQuantityMaximum = orderItem.quantityDelivered;
       
       if (orderItem.returnQuantity == null || orderItem.returnQuantity == undefined) {
           orderItem.returnQuantity = 0;
       }
       
       if(orderItem.returnQuantity > returnQuantityMaximum){
           orderItem.returnQuantity = returnQuantityMaximum;
       }
       
       if (orderItem.refundUnitPrice == null || orderItem.refundUnitPrice == undefined) {
           orderItem.refundUnitPrice = 0;
       }
       return orderItem;
   } 
}

class SWReturnOrderItems {

	public restrict:string;
	public templateUrl:string;
	public scope=true;
	public bindToController = {
	};
	public controller=SWReturnOrderItemsController;
	public controllerAs="swReturnOrderItems";

	public static Factory(){
        var directive:any = (
			$hibachi
        ) => new SWReturnOrderItems(
			$hibachi
        );
        directive.$inject = [
			'$hibachi'
        ];
        return directive;
    }

	constructor(private $hibachi){
		this.restrict = "A";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	SWReturnOrderItems
};
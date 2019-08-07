class SWReturnOrderItemsController{
    public orderItems:Array<Object> = [];
    public orderPayments:Array<Object> = [];
    public refundTotal:number=0;
    public refundPVTotal:number=0;
    public refundCVTotal:number=0;
    
    constructor(
        public $hibachi
    ){
    }

    public updateOrderItem = (orderItem) => {
       
       orderItem = this.setValuesWithinConstraints(orderItem);

       orderItem.refundTotal = orderItem.returnQuantity * orderItem.refundUnitPrice;
       orderItem.refundPVTotal = orderItem.refundTotal * orderItem.personalVolumeTotal / orderItem.total;
       orderItem.refundUnitPV = orderItem.refundPVTotal / orderItem.returnQuantity;
       orderItem.refundCVTotal = orderItem.refundTotal * orderItem.commissionableVolumeTotal / orderItem.total;
       orderItem.refundUnitCV = orderItem.refundCVTotal / orderItem.returnQuantity;
       
       if(orderItem.refundTotal > orderItem.total){
           orderItem.refundUnitPrice = orderItem.total / orderItem.returnQuantity;
           this.updateOrderItem(orderItem);
       }else{
            this.updateTotals();
       }
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
   
   private updateTotals = () =>{
       this.updateOrderItemTotals();
       this.updatePaymentTotals();
   }
   
   private updateOrderItemTotals = () =>{
       let refundTotal = 0;
       let refundPVTotal = 0;
       let refundCVTotal = 0;
       
       this.orderItems.forEach((item:any)=>{
           refundTotal += item.refundTotal;
           refundPVTotal += item.refundPVTotal;
           refundCVTotal += item.refundCVTotal;
       })
       
       this.refundTotal = refundTotal;
       this.refundPVTotal = refundPVTotal;
       this.refundCVTotal = refundCVTotal;
   }
   
   private updatePaymentTotals = ()=>{
       for(let i = this.orderPayments.length - 1; i >= 0; i--){
            this.validateAmount(this.orderPayments[i]);
       }
   }
   
   public validateAmount = (orderPayment)=>{

       const paymentTotal = this.orderPayments.reduce((total:number,payment:any)=>{
           return (payment == orderPayment) ?  total : total += payment.amount;
       },0);
       
       const maxRefund = Math.min(orderPayment.amountReceived,this.refundTotal - paymentTotal);

       if(orderPayment.amount == undefined){
           orderPayment.amount = 0;
       }
       if(orderPayment.amount > maxRefund){
           orderPayment.amount = Math.max(maxRefund,0);
       }
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
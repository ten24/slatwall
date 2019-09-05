class SWReturnOrderItemsController{
    private orderId:string;
    private displayPropertiesList:string;
    
    public orderItemCollectionList;
    public orderItems:Array<Object> = [];
    public orderPayments:Array<Object> = [];
    public refundTotal:number=0;
    public refundPVTotal:number=0;
    public refundCVTotal:number=0;
    public fulfillmentRefundAmount:number;
    public maxFulfillmentRefundAmount:number;
    
    public setupOrderItemCollectionList = () =>{
        this.orderItemCollectionList = this.collectionConfigService.newCollectionConfig("OrderItem");
        this.orderItemCollectionList.setDisplayProperties(this.displayPropertiesList);
        this.orderItemCollectionList.addFilter("order.orderID", this.orderId, "=");
    }
    
    public getDisplayPropertiesList = () =>{
        return `orderItemID,
                quantity,
                calculatedQuantityDeliveredMinusReturns,
                calculatedDiscountAmount,
                calculatedExtendedPriceAfterDiscount,
                calculatedExtendedPersonalVolumeAfterDiscount,
                calculatedExtendedCommissionableVolumeAfterDiscount,
                calculatedExtendedUnitPriceAfterDiscount,
                sku.skuCode,
                sku.product.title,
                sku.calculatedSkuDefinition`.replace(/\s+/gi,'');
    }
    
    constructor(
        public $hibachi,
        private collectionConfigService
    ){
        this.displayPropertiesList = this.getDisplayPropertiesList();
        this.setupOrderItemCollectionList();
    }

    public updateOrderItem = (orderItem) => {
       
       orderItem = this.setValuesWithinConstraints(orderItem);

       orderItem.refundTotal = orderItem.returnQuantity * orderItem.refundUnitPrice;
       orderItem.refundPVTotal = orderItem.refundTotal * orderItem.personalVolumeTotal / orderItem.total;
       orderItem.refundUnitPV = orderItem.refundPVTotal / orderItem.returnQuantity;
       orderItem.refundCVTotal = orderItem.refundTotal * orderItem.commissionableVolumeTotal / orderItem.total;
       orderItem.refundUnitCV = orderItem.refundCVTotal / orderItem.returnQuantity;
       orderItem.taxRefundAmount = orderItem.taxTotal / orderItem.quantity * orderItem.returnQuantity;
       if(orderItem.refundTotal > orderItem.total){
           orderItem.refundUnitPrice = orderItem.total / orderItem.returnQuantity;
           this.updateOrderItem(orderItem);
       }else{
            this.updateTotals();
       }
   }
   
   private setValuesWithinConstraints = (orderItem)=>{
       var returnQuantityMaximum = orderItem.returnQuantityMaximum;
       
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
       this.updateRefundTotals();
       this.updatePaymentTotals();
   }
   
   private updateRefundTotals = () =>{
       let refundTotal = 0;
       let refundPVTotal = 0;
       let refundCVTotal = 0;
       
       this.orderItems.forEach((item:any)=>{
           refundTotal += item.refundTotal + item.taxRefundAmount;
           refundPVTotal += item.refundPVTotal;
           refundCVTotal += item.refundCVTotal;
           
       })
       this.refundTotal = Number((refundTotal + this.fulfillmentRefundAmount).toFixed(2));
       this.refundPVTotal = Number(refundPVTotal.toFixed(2));
       this.refundCVTotal = Number(refundCVTotal.toFixed(2));
   }
   
   private updatePaymentTotals = ()=>{
       for(let i = this.orderPayments.length - 1; i >= 0; i--){
            this.validateAmount(this.orderPayments[i]);
       }
   }
   
   public validateFulfillmentRefundAmount = ()=>{
       if(this.fulfillmentRefundAmount > this.maxFulfillmentRefundAmount){
           this.fulfillmentRefundAmount = this.maxFulfillmentRefundAmount;
       }
       this.updateRefundTotals();
   }
   
   public validateAmount = (orderPayment)=>{

       const paymentTotal = this.orderPayments.reduce((total:number,payment:any)=>{
           return (payment == orderPayment) ?  total : total += payment.amount;
       },0);
       
       const maxRefund = Math.min(orderPayment.amountToRefund,this.refundTotal - paymentTotal);

       if(orderPayment.amount == undefined){
           orderPayment.amount = 0;
       }
       if(orderPayment.amount > maxRefund){
           orderPayment.amount = Number((Math.max(maxRefund,0)).toFixed(2));
       }
   }
}

class SWReturnOrderItems {

	public restrict:string;
	public templateUrl:string;
	public scope=true;
	public bindToController = {
	    orderId:'@'
	};
	public controller=SWReturnOrderItemsController;
	public controllerAs="swReturnOrderItems";

	public static Factory(){
        var directive:any = (
			$hibachi,
			monatBasePath
        ) => new SWReturnOrderItems(
			$hibachi,
			monatBasePath
        );
        directive.$inject = [
			'$hibachi',
			'monatBasePath'
        ];
        return directive;
    }

	constructor(private $hibachi, private monatBasePath){
		this.restrict = "E";
		this.templateUrl = monatBasePath + "/monatadmin/components/returnorderitems.html";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	SWReturnOrderItems
};
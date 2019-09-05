


// Not in use for now




export interface IOrderTemplate {
    orderTemplateId: string;
    name: string;
    orderItems?: IOrderItem[];
    shippingAndBillingDetail?: IShippingAndBillingDetail;
    orderTotalDetail?: IOrderTotalDetail;
}

export interface IOrderItem {
    id: string;
    name: string;
}

export interface IShippingAndBillingDetail {
    shippingAddress: string;
    billingAddress: string;
    deliveryMethod: string;
}

export interface IOrderTotalDetail {
    price: number;
    total: number;
}

export class OrderTemplate implements IOrderTemplate {
  public  orderTemplateId: string;
  public  name: string;
  /**
   * some utility functions as needed
   * 
   */
   
   public OrderTemplate(data:IOrderTemplate){
        Object.assign(this, data);
   }
   
}
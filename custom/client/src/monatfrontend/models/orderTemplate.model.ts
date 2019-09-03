export interface IOrderTemplate{
    id: string;
    name: string;
    orderItems?: IOrderItem[];
}

export interface IOrderItem{
    id: string;
    name: string;
}

export class OrderTemplate implements IOrderTemplate {
  public  id: string;
  public  name: string;
  /**
   * some utility functions as needed
   * 
   */ 
   
   
   
   
   
}
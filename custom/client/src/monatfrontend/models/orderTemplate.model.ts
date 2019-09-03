export interface IOrderTemplate{
    id: string;
    name: string;
    items?: IOrderItem[];
}

export interface IOrderItem{
    id: string;
    name: string;
}

export class OrderTemplate implements IOrderTemplate {
  id: string;
  name: string;
  /**
   * some utility functions as needed
   * 
   */ 
   
   
   
   
   
}
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Displays a shipping label in the order items row.
 * @module slatwalladmin
 * @class swOrderItemsShippingLabelStamp
 */
import { Component, Input, OnInit } from '@angular/core';

@Component({
    selector   : 'swoishippinglabelstamp',
    templateUrl: '/admin/client/src/orderitem/components/orderfulfillment-shippinglabel.html'    
})
export class SwOiShippingLabelStamp implements OnInit {
        
    @Input() orderfulfillment:any;
    
    constructor() {
        
    }
    
    ngOnInit() {

    }
    
    
}
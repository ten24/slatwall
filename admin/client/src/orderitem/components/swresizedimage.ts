/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import { Component, Input, OnInit } from '@angular/core';
import { $Hibachi } from '../../../../../org/Hibachi/client/src/core/services/hibachiservice';

@Component({    
    selector   : 'swresizedimage',
    templateUrl: '/admin/client/src/orderitem/components/orderitem-image.html'
})
export class SwResizedImage implements OnInit {
        
    @Input() orderitem: any;
    @Input() profilename: string;
    
    constructor( private $hibachi: $Hibachi ) {
        
    }
    
    ngOnInit() {
        let skuID = this.orderitem.data.sku.data.skuID;
        //Get the template.
        //Call slatwallService to get the path from the image.
        this.$hibachi.getResizedImageByProfileName(this.profilename, skuID)
            .then((response) => {
                this.orderitem.imagePath = response.resizedImagePaths[0];
            });
    }
}
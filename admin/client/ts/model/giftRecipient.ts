module slatwalladmin {
    'use strict';

    export class GiftRecipient {
        constructor(
            public firstName: string,
            public lastName: string,
            public email: string, 
            public giftMessage: string
            public quantity:number
        ) { 
            this.quantity = 1;
        }
    }
}
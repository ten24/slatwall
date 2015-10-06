module slatwalladmin {
    'use strict';

    export class GiftRecipient {
        constructor(
            public giftCardID: string,
            public giftCardCode: string, 
            public giftCardPin: string, 
            public expirationDate: string, 
            public ownerFirstName: string, 
            public ownerLastName: string, 
            public ownerEmailAddress: string, 
            public activeFlag: boolean
        ) { 
 
        }
    }
}
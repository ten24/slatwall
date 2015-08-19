module slatwalladmin {
    'use strict';

    export class GiftRecipient {
        constructor(
            public firstName: string,
            public lastName: string,
            public email: string, 
            public giftMessage: string,
            public quantity:number
        ) { 
            this.quantity = 1;
            this.firstName = "";
            this.lastName = "";
            this.email = "";
            this.giftMessage = ""; 
        }
        public getFullName = ():string =>{
            return this.firstName + ' ' + this.lastName;    
        }
    }
}
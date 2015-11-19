/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class GiftRecipient {
    constructor(
        public firstName: string,
        public lastName: string,
        public email: string, 
        public giftMessage: string,
        public quantity:number,
        public account:boolean, 
        public editing:boolean
    ) { 
        this.quantity = 1;
        this.editing = false; 
        this.account = false; 
    }
}
export{
    GiftRecipient
}

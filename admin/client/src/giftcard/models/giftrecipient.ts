/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class GiftRecipient {
    public firstName
    public lastName;
    public emailAddress;
    public giftMessage;
    public quantity;
    public account;
    public editing;

    constructor(
        firstName?: string,
        lastName?: string,
        emailAddress?: string,
        giftMessage?: string,
        quantity?:number,
        account?:boolean,
        editing?:boolean
    ) {
        this.quantity = 1;
        this.editing = false;
        this.account = false;
    }

    public reset = () =>{
        this.firstName = null;
        this.lastName = null;
        this.emailAddress = null;
        this.account = null;
        this.editing = false;
        this.quantity = 1;
    }
}
export{
    GiftRecipient
}

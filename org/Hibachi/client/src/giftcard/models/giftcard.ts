/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class GiftCard {
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
export{
    GiftCard
}
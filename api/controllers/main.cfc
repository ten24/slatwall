component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiControllerREST"{
    public any function getExpiredCreditsList(){
        writeDump(getService('GiftCardService').debitExpiredGiftCardCredits());ormFlush;
    }
}

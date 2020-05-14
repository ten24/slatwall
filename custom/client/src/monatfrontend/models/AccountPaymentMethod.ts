export interface AccountPaymentMethod {
    accountPaymentMethodID: string;
    accountPaymentMethodName: string;
    activeFlag: boolean;
    bankAccountNumberEncrypted: string;
    bankRoutingNumberEncrypted: string;
    calculatedExpirationDate: string;
    companyPaymentMethodFlag: string;
    creditCardLastFour: string;
    creditCardNumberEncrypted: string;
    creditCardNumberEncryptedDateTime: string;
    creditCardNumberEncryptedGenerator: string;
    creditCardType: string;
    currencyCode: string;
    expirationMonth: string;
    expirationYear: string;
    giftCardNumberEncrypted: string;
    lastExpirationUpdateAttemptDateTime: string;
    nameOnCreditCard: string;
    providerToken: string;
}
component accessors="true" output="false" extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface" {

    public any function init() {
        return this;
    }

    public string function getDisplayName() {
        return "Monat";
    }

    public string function getIntegrationTypes() {
        return "fw1,data";
    }

    public struct function getSettings() {
        return {
            siteMaximumFlexshipGiftCardAmount = {fieldtype="text", defaultValue=20, validate={dataType="numeric", required=true, minValue=0}},
            siteDaysAfterMarketPartnerEnrollmentFlexshipCreate = {fieldtype="text", defaultValue=0, validate={dataType="numeric", required=true, minValue=0}},
            siteMinCartTotalAfterVIPUserIsEligibleForOFYAndFreeShipping = {fieldtype="text", defaultValue=86, validate={dataType="numeric", required=true, minValue=0}},
            siteMinCartTotalAfterMPUserIsEligibleForOFYAndFreeShipping = {fieldtype="text", defaultValue=69, validate={dataType="numeric", required=true, minValue=0}},
            baseImportURL = {fieldType="text", defaultValue=""},
			authKey = {fieldType="password", encryptValue=true},
			globalMPEnrollmentFeeSkuID = {fieldtype="text", defaultValue="", validate={required=true}},
		    globalVIPEnrollmentFeeSkuID = {fieldtype="text", defaultValue="", validate={required=true}},
		    globalProductCodesRenewMP = {fieldtype="text", defaultValue="", validate={required=true}},
		    orderMinimumDaysToRenewMP = {fieldType="text", defaultValue=0, validate={dataType="numeric"}
			},
		};
    }
    
    public array function getMenuItems(){
        return [];
    }

	public array function getEventHandlers() {
		return [];
	}
}

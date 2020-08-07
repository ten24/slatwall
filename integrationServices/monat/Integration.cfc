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
            siteFlexshipCancellationGracePeriodForMPUsers = {fieldType="text", defaultValue=60, validate = {dataType="numeric", required=true, minValue=0}},
            baseImportURL = {fieldType="text", defaultValue=""},
			authKey = {fieldType="password", encryptValue=true},
		    globalVIPEnrollmentFeeSkuID = {fieldtype="text", defaultValue="", validate={required=true}},
		    orderMinimumDaysToRenewMP = {fieldType="text", defaultValue=0, validate={dataType="numeric"}},
		    legacyImportAPIDomain = {fieldType="text", defaultValue="https://api.monatcorp.net:8443"},
			legacyImportAPIAuthKey = {fieldType="password", defaultValue=""},
		    dailyImportAPIDomain = {fieldType="text", defaultValue="https://apisandbox.monatcorp.net:8443"},
			dailyImportAPIAuthKey = {fieldType="password", defaultValue=""},
			rafCreditExpirationTerm = {fieldType="select"},
			siteVipEnrollmentOrderMinimum = {fieldType="text", defaultValue=84, validate = {dataType="numeric", minValue=0}},
			siteSkinProductListingCategoryFilters = {
			    fieldType="listingMultiselect", 
			    listingMultiselectEntityName="Category",
			    listingMultiselectFilters=[{
					propertyIdentifier="parentCategory.categoryID",
					value="673cba5d92bf40e18027ede2a51dc5a5"
				}]
			},
			siteHairProductListingCategoryFilters = {
			    fieldType="listingMultiselect", 
			    listingMultiselectEntityName="Category",
			    listingMultiselectFilters=[{
					propertyIdentifier="parentCategory.categoryID",
					value="f66d77f60a6b4911a36cb00b11b89a14"
				}]
			}

		};
    }
    
    public array function getSettingOptions(required string settingName){
        if(settingName == 'integrationMonatRAFCreditExpirationTerm'){
            var termCollection = getService('SettingService').getTermCollectionList();
            return termCollection.getRecordOptions();
        }
    }
    
    // @hint Determines whether integration should allow site specific setting overrides
	public boolean function getAllowSiteSpecificSettingsFlag() {
		return true;
	}

	// @hint comma-delimitd list of settings to display that allow site specific overrides (without 'integration{packageName}' prefix)
	public string function getAllowedSiteSettingNames() {
		return "siteHairProductListingCategoryFilters,siteSkinProductListingCategoryFilters";
	}
    
    public array function getMenuItems(){
        return [];
    }

	public array function getEventHandlers() {
		return ["Slatwall.integrationServices.monat.model.handler.monatHandler"];
	}
}

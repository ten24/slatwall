component accessors="true" output="false" extends="Slatwall.org.Hibachi.HibachiCacheService" {
    
    property name="settingService";
    
    public numeric function getCacheValidationIntervalSeconds() {
        // If setting available use it
        try {
            return getSettingService().getSettingValue('globalCacheValidationIntervalSeconds');
        } catch (any e) {
            return super.getCacheValidationIntervalSeconds();
        }
    }
    
    public numeric function getMaxCacheElementsLimit() {
        // If setting available use it
        try {
            return getSettingService().getSettingValue('globalCacheMaxElementsLimit');
        } catch (any e) {
            return super.getMaxCacheElementsLimit();
        }
    }
    
}
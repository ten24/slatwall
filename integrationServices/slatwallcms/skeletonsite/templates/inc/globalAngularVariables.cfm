<cfoutput>
    <!------ we use this to load slatwall variables into angular ------>
    <span ng-init="slatwall.globalURLKeyProduct = '#$.slatwall.getService('settingService').getSettingValue('globalURLKeyProduct')#'"></span>
</cfoutput>
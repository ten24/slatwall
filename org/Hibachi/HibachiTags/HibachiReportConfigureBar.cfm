<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
   <cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
   <cfparam name="attributes.report" type="any" />

   <cfset siteCollectionList = attributes.hibachiScope.getService('siteService').getSiteCollectionList() />
   <cfset siteCollectionList.setDisplayProperties('siteID,siteName', { isVisible=true }) />
   <cfset siteCollectionList.setOrderBy('siteName|ASC') />

<cfoutput>
    <div class="row s-report-info">
        <span ng-init="toggleCustomDate = false"></span>			
        <sw-report-configuration-bar 
        site-collection-list="#attributes.hibachiScope.getService('hibachiUtilityService').hibachiHTMLEditFormat(serializeJson(siteCollectionList.getRecords()), false)#" />
    </div>
</cfoutput>
</cfif>
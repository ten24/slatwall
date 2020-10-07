<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
   <cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
   <cfparam name="attributes.report" type="any" />
   <!---
   <cfset local.startOfToday = CreateDateTime(Year(now()),Month(now()),Day(now()),0,0,0) />
   <cfset local.endOfToday = CreateDateTime(Year(now()),Month(now()),Day(now()),23,59,59) />
   
   <cfset local.startOfMonth = CreateDateTime(Year(now()),Month(now()),1,0,0,0) />
   <cfset local.endOfMonth = CreateDateTime(Year(now()),Month(DateAdd('m', 1, now())),1,0,0,0) />
   <cfset local.endOfHour = CreateDateTime(Year(now()),Month(now()),Day(now()),Hour(now()),59,59) />
   <cfset local.lastTwentyFourHours = DateAdd('h', -24, local.endOfHour) />
   <cfset local.lastTwoWeeks = DateAdd("d", -13, local.endOfToday) />
   <cfset local.weekGrouping = DateAdd("ww", -11, local.endOfToday) />
   <cfset local.monthGrouping = DateAdd("m", -11, local.endOfMonth) />
   <cfset local.startOfYear = CreateDateTime(Year(DateAdd('yyyy', -10, now())),1,1,0,0,0) />
   <cfset local.endOfYear = CreateDateTime(Year(DateAdd('yyyy', -10, now())),1,1,0,0,0) />
               --->

   <cfset siteCollectionList = attributes.hibachiScope.getService('siteService').getSiteCollectionList() />
   <cfset siteCollectionList.setDisplayProperties('siteID,siteName', { isVisible=true }) />
   <cfset siteCollectionList.setOrderBy('siteName|ASC') />
   <cfset siteCollectionListJson = serializeJson(siteCollectionList.getRecords())/>
   <!---escape apostrophes--->

   <cfset siteCollectionListJson = esapiEncode('html_attr', siteCollectionListJson)/>
   <!---
   
   start-of-today="#CreateDateTime(Year(now()),Month(now()),Day(now()),0,0,0)#"
            end-of-today="#CreateDateTime(Year(now()),Month(now()),Day(now()),23,59,59)#"
            start-of-month="#CreateDateTime(Year(now()),Month(now()),1,0,0,0)#"
            end-of-month="#CreateDateTime(Year(now()),Month(DateAdd('m', 1, now())),1,0,0,0)#"
            end-of-hour="#CreateDateTime(Year(now()),Month(now()),Day(now()),Hour(now()),59,59)#"
            start-of-year="#CreateDateTime(Year(DateAdd('yyyy', -10, now())),1,1,0,0,0)#"
            end-of-year="#CreateDateTime(Year(DateAdd('yyyy', 1, now())),Month(now()),1,0,0,0)#"
            group-by="#attributes.report.getReportDateTimeGroupBy()#"
            last-twenty-four-hours="#local.lastTwentyFourHours#"
            last-two-weeks="#local.lastTwoWeeks#"
            week-grouping="#local.weekGrouping#"
            month-grouping="#local.monthGrouping#"
            
            
            --->
<cfoutput>
    <div class="row s-report-info">
        <span ng-init="toggleCustomDate = false"></span>			
        <sw-report-configuration-bar site-collection-list="#siteCollectionListJson#" />
    </div>
</cfoutput>
</cfif>
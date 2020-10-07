<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
    <cfparam name="attributes.report" type="any" />
    <cfparam name="attributes.collectionList" type="any" />
    <cfparam name="attributes.enableAveragesAndSums" type="boolean" default="true"/>
    <cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
    <cfoutput>
        <cfset local.endOfToday = CreateDateTime(Year(now()),Month(now()),Day(now()),23,59,59) />
        <cfset local.lastTwoWeeks = DateAdd("d", -13, local.endOfToday) />
        <cfset siteCollectionList = attributes.hibachiScope.getService('siteService').getSiteCollectionList() />
        <cfset siteCollectionList.setDisplayProperties('siteID,siteName', { isVisible=true }) />
        <cfset siteCollectionListRecords = siteCollectionList.getRecords()/>
        <div id="hibachi-report">
            <!--- Configure --->
            <div id="hibachi-report-configure-bar">
                #attributes.report.getReportConfigureBar()#
            </div>
            <div data-name="Dashboard" >
                <div class="Mcard-wrapper col-md-12">
                    <div class="col-md-3">
                        <sw-stat-widget 
                            metric-code="totalSales"
                            start-date-time="#local.lastTwoWeeks#"
                            end-date-time="#local.endOfToday#"
                            site-id="#siteCollectionListRecords[1]['siteID']#"
                            title="Sales" 
                            img-src="/assets/images/piggy-bank-1.png"
                            img-alt="Piggy Bank"
                            footer-class="Mcard-footer1"
                            collection-config=""
                            >
                        </sw-stat-widget>
                    </div>
                    <div class="col-md-3">
                        <sw-stat-widget 
                            metric-code="orderCount"
                            start-date-time="#local.lastTwoWeeks#"
                            end-date-time="#local.endOfToday#"
                            site-id="#siteCollectionListRecords[1]['siteID']#"
                            title="Order Count" 
                            img-src="/assets/images/shopping-bag-gray.png"
                            img-alt="Shopping Bags"
                            footer-class="Mcard-footer2"
                            collection-config=""
                            >
                        </sw-stat-widget>
                    </div>
                    <div class="col-md-3">
                        <sw-stat-widget 
                            title="Average Order Value" 
                            start-date-time="#local.lastTwoWeeks#"
                            end-date-time="#local.endOfToday#"
                            site-id="#siteCollectionListRecords[1]['siteID']#"
                            metric-code="avgSales"
                            img-src="/assets/images/dollar-symbol-gray.png"
                            img-alt="Dollar Symbol Badge"
                            footer-class="Mcard-footer4"
                            collection-config=""
                            >
                        </sw-stat-widget>
                    </div>
                    <div class="col-md-3">
                        <sw-stat-widget 
                            title="Accounts Created" 
                            start-date-time="#local.lastTwoWeeks#"
                            end-date-time="#local.endOfToday#"
                            site-id="#siteCollectionListRecords[1]['siteID']#"
                            metric-code="accountCount"
                            img-src="/assets/images/user-2.png"
                            img-alt="User Icon"
                            footer-class="Mcard-footer3"
                            collection-config=""
                            >
                        </sw-stat-widget>
                    </div>
                    <sw-chart-widget 
                        name="tom" 
                        start-date-time="#local.lastTwoWeeks#"
                        end-date-time="#local.endOfToday#"
                        site-id="#siteCollectionListRecords[1]['siteID']#"
                        chart-id="report-chart" 
                        report-title="Revenue"
                        collection-config=""
                        />
                </div>
                <sw-report-menu
                    data-collection-config=""
                    >
                </sw-report-menu>
            </div>
        </div>
    </cfoutput>
</cfif>
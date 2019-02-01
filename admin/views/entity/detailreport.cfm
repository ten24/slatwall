<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

--->
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.report" type="any">
<cfparam name="rc.edit" type="boolean">
<cfparam name="rc.reportName" type="any" default="#rc.report.getReportName()#">
<cfparam name="rc.reportDateTime" type="any" default="#rc.report.getReportDateTime()#">
<cfparam name="rc.reportDateTimeGroupBy" type="any" default="#rc.report.getReportDateTimeGroupBy()#">
<cfparam name="rc.reportCompareFlag" type="any" default="#rc.report.getReportCompareFlag()#">
<cfparam name="rc.dimensions" type="any" default="#rc.report.getDimensions()#">
<cfparam name="rc.metrics" type="any" default="#rc.report.getMetrics()#">

<cfoutput>
	<hb:HibachiEntityDetailForm object="#rc.report#" edit="#rc.edit#">
		<hb:HibachiEntityActionBar type="detail" object="#rc.report#" edit="#rc.edit#" />
		
		<input type="hidden" name="reportName" value="#rc.reportName#" />
		<input type="hidden" name="reportType" value="#rc.reportType#" />
		<input type="hidden" name="reportDateTime" value="#rc.reportDateTime#" />
		<input type="hidden" name="reportDateTimeGroupBy" value="#rc.reportDateTimeGroupBy#" />
		<input type="hidden" name="reportCompareFlag" value="#rc.reportCompareFlag#" />
		<input type="hidden" name="dimensions" value="#rc.dimensions#" />
		<input type="hidden" name="metrics" value="#rc.metrics#" />
		<input type="hidden" name="limitResults" value="#rc.limitResults#" />
		<input type="hidden" name="showReport" value="#rc.showReport#" /> 
		
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<hb:HibachiPropertyDisplay object="#rc.report#" property="reportTitle" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.report#" property="dynamicDateRangeFlag" edit="#rc.edit#">
				<hb:HibachiDisplayToggle selector="input[name='dynamicDateRangeFlag']" loadVisable="#rc.report.getDynamicDateRangeFlag()#">
					<hb:HibachiPropertyDisplay object="#rc.report#" property="dynamicDateRangeEndType" edit="#rc.edit#">
					<hb:HibachiPropertyDisplay object="#rc.report#" property="dynamicDateRangeType" edit="#rc.edit#">
					<cfset showValuesList = "years,quarters,months,weeks,days" />
					<hb:HibachiDisplayToggle selector="select[name='dynamicDateRangeType']" showValues="#showValuesList#" loadVisable="#listFindNoCase(showValuesList, rc.report.getDynamicDateRangeType())#">
						<hb:HibachiPropertyDisplay object="#rc.report#" property="dynamicDateRangeInterval" edit="#rc.edit#">
					</hb:HibachiDisplayToggle>
				</hb:HibachiDisplayToggle>
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
		
	</hb:HibachiEntityDetailForm>
</cfoutput>


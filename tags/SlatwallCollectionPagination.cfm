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

    tabDirectory is the name of the tab directory without the path. It is assumed it lives in the custom/admin/views/entity/tabDirectory/customtabs/tabsName file.
    tabName is both the name of the tab file without the file extention as well as the name that displays on the tab.
--->
<cfimport prefix="swa" taglib="../tags" />
<cfimport prefix="hb" taglib="../org/Hibachi/HibachiTags" />
<cfparam name="attributes.collection" type="any" />
<cfparam name="attributes.slatwallScope" type="any" />
<cfparam name="attributes.first" type="string" default="&laquo;"/>
<cfparam name="attributes.previous" type="string" default="&lsaquo; "/>
<cfparam name="attributes.next" type="string" default="&rsaquo;"/>
<cfparam name="attributes.last" type="string"default="&raquo;" />
<cfif thisTag.executionMode is "start">
	<cfoutput>
		
		<cfif !isNull(attributes.collection) AND attributes.collection.getTotalPages() GT 1>
			<!---<cfdump var="#attributes.collection#" top="2">--->
			<nav>
				<cfset lastPage = attributes.collection.getTotalPages()>
                <cfset currentPage = attributes.collection.getCurrentPageDeclaration()>
                <cfset nextPage = currentPage+1>
                <cfset previousPage = (currentPage GT 1) ? currentPage-1 : 1>
                <cfset maxPage = nextPage + 3>
	            <ul class="pagination">
	            	
	            	<!--- First --->
	            	<li><a href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current=1' )#" <cfif currentPage EQ 1>disabled="disabled" title="First Page" </cfif>>
	            		#attributes.first#
	            		</a></li>
	                
	                <!--- Previous --->
	                <li><a href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current='&previousPage )#" <cfif currentPage EQ 1>disabled="disabled" title="Previous Page #currentPage-1#" </cfif>>
	                	#attributes.previous#
	                	</a>
	                </li>
	                
	                <!--- Show previous pages if they exist --->
	                <cfif nextPage GT 2>
		                <cfloop index="page" from="1" to="#nextPage#">
		                	<cfif page LT currentPage>	
			                <li><a href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current=#page#' )#">#page#</a></li>
		                	</cfif>
		                </cfloop>
	                </cfif>
	                
	                <!--- Self --->
	                <li 
	                	<cfif attributes.collection.getPageRecordsStart() EQ attributes.collection.getCurrentPageDeclaration()>
	                		class="active"
	                	</cfif>><a href="##">#attributes.collection.getCurrentPageDeclaration()#</a>
	                </li>
	                
	                <!--- Show next 4 pages if they exist minus the ones shown before the current page. --->
	                <cfloop condition="nextPage LTE lastPage AND nextPage LTE currentPage+4">
		                <li><a href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current=#nextPage#' )#">#nextPage#</a></li>
		                <cfset nextPage+=1>
	                </cfloop>
	                
	                <!--- Next --->
	                <li><a href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current=#currentPage+1#' )#" title="Next Page #currentPage+1#">
	                	#attributes.next#
	                </a></li>
	                <!--- Last --->
	                <li><a href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current='&lastPage )#" title="Last Page #lastPage#">
	                	#attributes.last#
	                	</a></li>
	            </ul>
	        </nav>
        </cfif>
	</cfoutput>
</cfif>

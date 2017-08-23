<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="thistag.filterCountGroups" type="array" default="#arrayNew(1)#" />	
	
<cfelse>
	
	<cfoutput>
		<div class="widget shop-categories">
    		<div class="widget-content">
    			<form action="##">
    				<ul class="product_list checkbox">
    					<cfset currentIndex = 0/>
    					<cfset filterCountGroupsCount = arraylen(thistag.filterCountGroups)/>
    					<cfloop array="#thistag.filterCountGroups#" index="filterCountGroup">
    						<cfset currentIndex++/>	
	    					<cfoutput>
	    						#filterCountGroup.htmlContent#
	    					</cfoutput>
	    					<!--- apply url data to main collection at the end --->
	    					<cfif currentIndex eq filterCountGroupsCount>
	    						
	    						<cfset filterCountGroup.collectionList.applyData(url)/>
	    					</cfif>
						</cfloop>
    					
    			</form>
    		</div>
    	</div>
	</cfoutput>
</cfif>

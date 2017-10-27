<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfif !structKeyExists(attributes,'hibachiScope')>
		<cfset attributes.hibachiScope = request.context.fw.getHibachiScope()/>
	</cfif>
	<cfparam name="attributes.collectionList" type="any" default="" />
	<cfparam name="attributes.template" type="any" default="" />
	<cfparam name="thistag.filterCountGroups" type="array" default="#arrayNew(1)#" />
	
<cfelse>
	
	<cfoutput>
		<script>
			var updateApplyHref = function(id,baseBuildUrl){
	        	var minValue = $('##min'+id).val() || '';
	            var maxValue = $('##max'+id).val() || '';
	            
//	            remove previous params
	            var url = window.location.toString().split('?')[0]+'?'+baseBuildUrl+minValue+'^'+maxValue;
	            $('##apply'+id).attr('href',url);
	        }
		</script>
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

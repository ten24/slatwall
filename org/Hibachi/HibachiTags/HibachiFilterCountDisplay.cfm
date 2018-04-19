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
				var urlAndQueryParams = window.location.toString().split('?');
				var queryParams = []; 
				if(urlAndQueryParams.length>1){ 
					queryParams = urlAndQueryParams[1].split("&");
				}
				
				var baseBuildUrlExistsFlag = false;
				for(var i = 0; i < queryParams.length; i++){
					if(queryParams[i].indexOf(baseBuildUrl)>-1){
						queryParams[i] = baseBuildUrl + minValue + "^" + maxValue;
						baseBuildUrlExistsFlag = true;
					}
				}
				var url = urlAndQueryParams[0];
				if(queryParams && queryParams.length){
					url += "?" + queryParams.join("&");
				}
				if(!baseBuildUrlExistsFlag){
					if(urlAndQueryParams.length > 1){
						url += "&";
					} else {
						url += "?";
					}
					url += baseBuildUrl + minValue + "^" + maxValue;
				} 
	            $('##apply'+id).attr('href',url);
	        }
	        
	        var navigateByIDPath = function(ulElement,baseBuildUrl,IDPath,urlParam){
	        	
	        	var IDArray = [];
	        	
	        	
	        	
	        	ulElement.find("ul li input").each(function(index,element){
	        		
        			if($(element).attr('data-IDPath').indexOf(IDPath) > -1){
	        			var lastIDArray = $(element).attr('data-IDPath').split(',');
	        			var lastID = lastIDArray[lastIDArray.length-1];
	        			IDArray.push(lastID);
	        		}
	        		
	        	});
        		var IDList = IDArray.join(',');
        		var buildUrl = updateQueryStringParameter(baseBuildUrl,urlParam.split('=')[0],IDList);
	        	
	        	window.location=buildUrl;
	        
	        }
	        
	        var updateQueryStringParameter = function(uri, key, value) {
			  var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
			  var separator = uri.indexOf('?') !== -1 ? "&" : "?";
			  if (uri.match(re)) {
			    return uri.replace(re, '$1' + key + "=" + value + '$2');
			  }
			  else {
			    return uri + separator + key + "=" + value;
			  }
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

<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfif !structKeyExists(attributes,'hibachiScope')>
		<cfset attributes.hibachiScope = request.context.fw.getHibachiScope()/>
	</cfif>
	<cfparam name="attributes.collectionList" type="any" default="" />
	<cfparam name="attributes.filterCountDisplayTemplate" type="any" default="./tagtemplates/hibachifiltercountdisplay.cfm" />
	<cfparam name="attributes.filterCountDisplayItemTemplate" type="any" default="" />
	<cfparam name="attributes.template" type="any" default="" />
	<cfparam name="thistag.filterCountGroups" type="array" default="#arrayNew(1)#" />
	<cfif len(attributes.template) && !len(attributes.filterCountDisplayItemTemplate) >
		<cfset attributes.filterCountDisplayItemTemplate = attributes.template />
	</cfif>
<cfelse>
	
	<cfoutput>
		<script>
			
			var stripSpecialCharacters = function(string){
				return string.replace(/[^a-zA-Z ]/g, "");
			};
			
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
					if(stripSpecialCharacters(queryParams[i]).indexOf(stripSpecialCharacters(baseBuildUrl))>-1){
						queryParams[i] += "," + minValue + "^" + maxValue;
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
		<cfinclude template="#attributes.filterCountDisplayTemplate#" >
	</cfoutput>
</cfif>

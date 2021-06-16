<cfimport prefix="hb" taglib="../../../../../../org/Hibachi/HibachiTags"/>
<cfoutput>
			
<button class="btn btn-primary d-md-none d-lg-none d-xl-none" type="button" data-toggle="collapse" data-target="##sidebarCollapse" aria-expanded="false" aria-controls="sidebarCollapse">
    Filter Options
</button>

<div class="collapse show" id="sidebarCollapse">
    <div id="accordion">
        <div class="card mb-4">
    		<div class="card-header" id="headingOne">
    			<h5 class="mb-0">
    				<button class="btn btn-link p-0" data-toggle="collapse" data-target="##collapseOne" aria-expanded="true" aria-controls="collapseOne">
    				Search
    				</button>
    			</h5>
    		</div>
    		<div id="collapseOne" class="collapse" aria-labelledby="headingOne" data-parent="##accordion">
    			<div class="card-body">
                    <input type="text" id="searchBox" name="search" class="form-control form-control-sm">
                    <a href="##" id="searchButton" class="btn btn-sm btn-block btn-secondary mt-1">Search</a>
                    <cfif structKeyExists(url,'keywords')>
						<a href="#$.slatwall.getService('hibachiCollectionService').buildURL('keywords=#url[listFirst('keywords=','=')]#')#">Clear Search</a>
					</cfif>
                </div>
    		</div>
    	</div>
      <hb:HibachiFilterCountDisplay
	    	hibachiScope="#$.slatwall#"
	    	collectionList="#productCollectionList#"
	    	template="../../../custom/apps/#$.slatwall.getApp().getAppCode()#/#$.slatwall.getSite().getSiteCode()#/tags/tagtemplates/FilterCountDisplayItem.cfm"
	        filterCountDisplayTemplate="../../../custom/apps//#$.slatwall.getApp().getAppCode()#/#$.slatwall.getSite().getSiteCode()#/tags/tagtemplates/FilterCountDisplay.cfm"
	    >

		    	<hb:HibachiFilterCountDisplayItem
					propertyIdentifier="defaultSku.price"
					rangeData="#[
						{
							minValue=0,
							maxValue=30,
							displayValue="Under $30"
						},
						{
							minValue=30,
							maxValue=75,
							displayValue="$30 - $75"
						},
						{
							minValue=75,
							maxValue=150,
							displayValue="$75 - $150"
						},
						{
							minValue=150,
							maxValue=300,
							displayValue="$150 - $300"
						},
						{
							minValue=300,
							displayValue="$300 +"
						}
					]#"
				/>
                
                <hb:HibachiFilterCountDisplayItem
					propertyIdentifier="brand"
					inversePropertyIdentifier="products"
					title="#$.slatwall.rbkey('entity.brand_plural')#"
				/>
				
				<hb:HibachiFilterCountDisplayItem
		 			propertyIdentifier="skus.options"
		 			discriminatorProperty="optionGroup"
		 			inversePropertyIdentifier="skus.product"
		 		/>
		 		<hb:HibachiFilterCountDisplayItem
		 			propertyIdentifier="categories"
		 			inversePropertyIdentifier="products"
		 		/>
		 		<hb:HibachiFilterCountDisplayItem
		 			propertyIdentifier="productType"
		 			inversePropertyIdentifier="products"
		 		/>
		 		
		 		
		</hb:HibachiFilterCountDisplay >
    </div>
</div>
<script>
	(function(){
		$('##searchBox').on('input',function (e) {
			//remove previous params
			var urlAndQueryParams = window.location.toString().split('?');
			var queryParams = []; 
			if(urlAndQueryParams.length>1){ 
				queryParams = urlAndQueryParams[1].split("&");
			}
			
			var keywordsExistsFlag = false;
			for(var i = 0; i < queryParams.length; i++){
				if(queryParams[i].indexOf('keywords')>-1){
					queryParams.splice(i,1);
					keywordsExistsFlag = true;
				}
			}
			
			queryParams.push('keywords=' + this.value);
			
			var url = urlAndQueryParams[0];
			if(queryParams && queryParams.length){
				console.log(queryParams);
				url += "?" + queryParams.join("&");
			}
			
		    if (url.indexOf('?') === -1){
				url += "?";
			}
	
	        $('##searchButton').attr('href',url);
	    });
	})();
</script>
</cfoutput>
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
    					<cfloop array="#thistag.filterCountGroups#" index="filterCountGroup">
    						<cfif !isNull(filterCountGroup.collectionList)>
    							<cfset filterCountGroup.entityName = filterCountGroup.collectionList.getCollectionObject()/>
    						<cfelse>
    							<cfset filterCountGroup.collectionList = attributes.hibachiScope.getService('HibachiService').getCollectionList(filterCountGroup.entityName)/>
    						</cfif>
    						<!--- refine list to ID,Name, and count --->
    						<cfset primaryIDName = attributes.hibachiScope.getService('hibachiService').getPrimaryIDPropertyNameByEntityName(filterCountGroup.entityName)/>
    						<cfset simpleRepresentationPropertyName = attributes.hibachiScope.getService('hibachiService').getSimpleRepresentationPropertyNameByEntityName(filterCountGroup.entityName)/>
    						<cfset filterCountGroup.collectionList.setDisplayProperties('#primaryIDName#,#simpleRepresentationPropertyName#')/>
    						<cfset filterCountGroup.collectionList.addDisplayAggregate(filterCountGroup.propertyIdentifier, 'COUNT', 'itemCount')/>
    						<cfset filterCountGroup.collectionList.applyData(url)/>
	    					<li class="filterObj">
	                            <div class="header-wrapper">
	    							<span class="arrow arrowToggle"><i class="fa fa-angle-up"></i></span>
	    							<span>#attributes.hibachiScope.rbKey('entity.#filterCountGroup.entityName#_plural')#</span>
	                            </div>
								<ul class="children active">
									<cfset iteration = 1/>
									
									
	 								<cfloop array="#filterCountGroup.collectionList.getRecords()#" index="filterCountRecord">
	 									<cfif filterCountRecord['itemCount'] NEQ 0>
	 										<cfset buildUrl = "#filterCountGroup.filterType#:#primaryIDName#=#filterCountRecord[primaryIDName]#"/>
	 										
	 										<li>
	 											<cfset isFilterApplied = false/>
	 											<a 
	 												id="#filterCountGroup.entityName##iteration#" 
	 												href="#attributes.hibachiScope.getService('hibachiCollectionService').buildURL('#buildUrl#')#" 
	 												<cfif isFilterApplied>
		 												class="remove" 
		 												data-toggle="tooltip" 
		 												data-placement="right" 
		 												title="Remove"
	 												</cfif>
	 											>
													<cfif isFilterApplied><i class="fa fa-times"></i></cfif>
													<span class="filterTitle"> #filterCountRecord[simpleRepresentationPropertyName]#</span>
													<span class="count">#filterCountRecord['itemCount']#</span>
												</a>
												
												
												<!---<cfif productCollection.isFilterApplied('productType.productTypeID', productTypes['productTypeID'][productTypeIteration])>
													<a href="#$.slatwall.getService('hibachiCollectionService').buildURL('f:productType.productTypeID=#productTypes['productTypeID'][productTypeIteration]#')#" class="remove" id="ProductType#productTypeIteration#" data-toggle="tooltip" data-placement="right" title="Remove">
														<i class="fa fa-times"></i><span class="filterTitle"> #productTypes['productTypeName'][productTypeIteration]#</span>
														<span class="count">#filterCount#</span>
													</a>   
												<cfelse>
													<a id="ProductType#productTypeIteration#" href="#$.slatwall.getService('hibachiCollectionService').buildURL('f:productType.productTypeID=#productTypes['productTypeID'][productTypeIteration]#')#">
														<span class="filterTitle">#productTypes['productTypeName'][productTypeIteration]#</span>
														<span class="count">#filterCount#</span>
													</a>
												</cfif>--->
											</li> 
	 									</cfif>
										<cfset iteration++/>
									</cfloop>
								</ul>
							</li>
						</cfloop>
    					
    					<!---<cfif NOT len(productTypeID) AND NOT structKeyExists(url, 'f:productType.productTypeID') >
    						<!--- Loop over the list of productTypes --->
    						<cfset productTypes = $.slatwall.getService('buddiesProshopDataService').getAvailableProductTypes() />
    						<cfset productTypeIteration = 1/>
    						
    						<li class="filterObj">
                                <div class="header-wrapper">
        							<span class="arrow arrowToggle"><i class="fa fa-angle-up"></i></span>
        							<span>Product Types</span>
                                </div>
    							<ul class="children active">
     								<cfloop query="#productTypes#">
    									<cfset filterCount = $.slatwall.getService('buddiesProshopDataService').getFilterCount(url,'productType.productTypeID', productTypes['productTypeID'][productTypeIteration] ) />
    									<cfif filterCount NEQ 0 >
    										<li>
    											<cfif productCollection.isFilterApplied('productType.productTypeID', productTypes['productTypeID'][productTypeIteration])>
    												<a href="#$.slatwall.getService('hibachiCollectionService').buildURL('f:productType.productTypeID=#productTypes['productTypeID'][productTypeIteration]#')#" class="remove" id="ProductType#productTypeIteration#" data-toggle="tooltip" data-placement="right" title="Remove">
    													<i class="fa fa-times"></i><span class="filterTitle"> #productTypes['productTypeName'][productTypeIteration]#</span>
    													<span class="count">#filterCount#</span>
    												</a>   
    											<cfelse>
    												<a id="ProductType#productTypeIteration#" href="#$.slatwall.getService('hibachiCollectionService').buildURL('f:productType.productTypeID=#productTypes['productTypeID'][productTypeIteration]#')#">
    													<span class="filterTitle">#productTypes['productTypeName'][productTypeIteration]#</span>
    													<span class="count">#filterCount#</span>
    												</a>
    											</cfif>
    										</li> 
    									</cfif>
    									<cfset productTypeIteration++ />	
    								</cfloop>
    							</ul>
    						</li>
    					</cfif>
    									
    					<cfset pricingGroupArray = $.Slatwall.getService('buddiesProShopDataService').getPriceListing() />
    					<li class="filterObj">
                            <div class="header-wrapper">
        						<span class="arrow arrowToggle"><i class="fa fa-angle-up"></i></span>
        						<span>PRICE</span>
                            </div>
    						<ul class="children active">
    							<cfset priceIteration = 1/>
    							<cfloop index="local.pricingGroup" array="#pricingGroupArray#">
    								<cfset filterCount = $.slatwall.getService('buddiesProshopDataService').getRangeCount(url,'defaultSku.price', '#pricingGroup.minPrice#^#pricingGroup.maxPrice#',productTypeID ) />
    								<cfif filterCount NEQ 0 >
    									<li>
    										<cfif  productCollection.isRangeApplied('defaultSku.price', '#pricingGroup.minPrice#^#pricingGroup.maxPrice#')>
    											<a id="priceIndex#priceIteration#" href="#$.slatwall.getService('hibachiCollectionService').buildURL('r:defaultSku.price=#pricingGroup.minPrice#^#pricingGroup.maxPrice#')#" class="remove">
    												<cfif len(pricingGroup.maxPrice)>
    													<i class="fa fa-times"></i><span class="filterTitle">$#pricingGroup.minPrice# - $#pricingGroup.maxPrice#</span>
    													<span class="count">#filterCount#</span>
    												<cfelse>
    													<span class="filterTitle">$#pricingGroup.minPrice# +</span>
    													<span class="count">#filterCount#</span>
    												</cfif>
    											</a>
    										<cfelse>
    											<a id="priceIndex#priceIteration#" href="#$.slatwall.getService('hibachiCollectionService').buildURL('r:defaultSku.price=#pricingGroup.minPrice#^#pricingGroup.maxPrice#')#">
    												<cfif len(pricingGroup.maxPrice)>
    													<span class="filterTitle">$#pricingGroup.minPrice# - $#pricingGroup.maxPrice#</span>
    													<span class="count">#filterCount#</span>
    												<cfelse>
    													<span class="filterTitle">$#pricingGroup.minPrice# +</span>
    													<span class="count">#filterCount#</span>
    												</cfif>
    											</a>
    										</cfif>
    									</li>
    								</cfif>
    								<cfset priceIteration++>
    							</cfloop>
    						</ul>
    					</li>
                        <li class="filterObj">
                            <div class="header-wrapper">
                                <span class="arrow arrowToggle"><i class="fa fa-angle-up"></i></span>
                                <span>Manufacturers</span>
                            </div>
                            <ul class="children active">
                                <cfset manufacturersTitleArray = ArrayNew(1)>
                                <cfset manufacturersListArray = ArrayNew(1)>
                                <cfloop array = "#productTypeIDArray#" index = "productTypeObj">
                					<cfset manufacturersArray = $.slatwall.getService('buddiesProShopDataService').getBrandHashMapByProductTypeID(productTypeObj) />
        							<cfset manufacturerIteration = 1/>
        							<cfloop index="local.manufacturer" array="#manufacturersArray#">
                                        
        								<cfset filterCount = $.slatwall.getService('buddiesProshopDataService').getFilterCount(url,'brand.brandID',  manufacturer['brandID'], productTypeID ) />
        								<cfif filterCount NEQ 0 >
                                            
                                            <cfif !ArrayContains(manufacturersTitleArray, "#manufacturer['brandName']#")>
                                                <cfscript> 
                                                    manufacturerStruct = StructNew();
                                                    manufacturerStruct.count = filterCount;
                                                    manufacturerStruct.brandId = manufacturer['brandID'];
                                                    manufacturerStruct.brandName = manufacturer['brandName'];
                                                    ArrayAppend(manufacturersListArray, manufacturerStruct);
                                                </cfscript> 
                                            </cfif>
        								</cfif>     
                                        <cfset ArrayAppend(manufacturersTitleArray, manufacturer['brandName'])>
                                            
        								<cfset manufacturerIteration++>
        							</cfloop>		
                                </cfloop>
                                <cfset sortedManufactuererArray = ArrayOfStructSort(manufacturersListArray, "Text", "asc", "brandName")>
                                <cfloop array = "#sortedManufactuererArray#" index = "sortedArrayItem">
                                    <li>
										<cfif  productCollection.isFilterApplied('brand.brandID', sortedArrayItem.brandId)>
											<a href="#$.slatwall.getService('hibachiCollectionService').buildURL('f:brand.brandID=#sortedArrayItem.brandId#')#" class="remove" id="Manufacturers#manufacturerIteration#" data-toggle="tooltip" data-placement="right" title="Remove">
												<i class="fa fa-times"></i><span class="filterTitle"> #sortedArrayItem.brandName#</span>
												<span class="count">#sortedArrayItem.count#</span>
											</a>   
										<cfelse>
												<a id="Manufacturers#manufacturerIteration#" href="#$.slatwall.getService('hibachiCollectionService').buildURL('f:brand.brandID=#sortedArrayItem.brandId#')#">
													<span class="filterTitle">#sortedArrayItem.brandName#</span>
													<span class="count">#sortedArrayItem.count#</span>
												</a>
										</cfif>
									</li>
                                </cfloop>
                            </ul>
                        </li>

    					<cfif len(productTypeID)>
    						<!---If content product type EQ Bowling Shoes & Accessories display bowling shoe filters --->
    						<!--- <cfif  productTypeObject.getProductTypeName() EQ 'Bowling Shoes & Accessories'>
    							<cfset attributeSetArray = $.slatwall.getService("ProductService").getProductType('5124bffa4dddbde5014df7fee90d0794').getAttributeSets()>
    						<cfelse>
    							<cfset attributeSetArray = productTypeObject.getAttributeSets()>
    						</cfif> --->
                            <cfloop array = "#productTypeIDArray#" index = "productTypeObj">
                                <cfset productTypeObject = $.slatwall.getService("ProductService").getProductType(productTypeObj)>
                                <cfset attributeSetArray = productTypeObject.getAttributeSets() />
                                
                                <cfparam name="attributePath" default = "">
        						<cfparam name="contentIDPropertyPath" default = "">
                
        						<cfloop index="attributeSet" array="#attributeSetArray#">	
        							<cfloop index="attribute" array="#attributeSet.getAttributes()#">
        								<cfset attributeCode = attribute.getAttributeCode() />
        								<cfset attributePath = "" />
        								<cfset attributeName = "" />
        								<cfset attributeValue = "" />
        								
        								<cfset contentIDPropertyPath = "attribute.attributeValues.product.listingPages.contentID" />
        								<cfset attributeName = attribute.getAttributeName() />
        								<cfset attributeOptionsCollection = attribute.getAttributeOptionsCollectionlist() />
        								<cfset attributeOptionsCollection.setDistinct(1) />
        								<cfset attributeOptionsCollection.setDisplayProperties('attributeOptionValue,attributeOptionLabel') />
        								<cfif isBoolean($.slatwall.getContent().getProductListingPageFlag()) and $.slatwall.getContent().getProductListingPageFlag()>
        									<cfset attributeOptionsCollection.addFilter(contentIDPropertyPath, $.slatwall.content('contentID')) />
        								</cfif>
        			
        								<cfset attributeOptionsCollection.addOrderBy("attributeOptionLabel|Asc") />
        								<li class="filterObj">
                                            <div class="header-wrapper">
            									<span class="arrow arrowToggle"><i class="fa fa-angle-up"></i></span>
            									<span>#attributeName#</span>
                                            </div>
        									<ul class="children active">
        										<cfloop array="#attributeOptionsCollection.getRecords()#" index="attributeOption">
        											<cfset filterCount = $.slatwall.getService('buddiesProshopDataService').getFilterCount(url,'#attribute.getAttributeCode()#',  '#attributeOption.attributeOptionValue#', productTypeID ) />
        											<cfif filterCount NEQ 0 >
        												<li>
        													<cfif  productCollection.isFilterApplied(attribute.getAttributeCode(), attributeOption.attributeOptionValue)>
        														<a href="#$.slatwall.getService('hibachiCollectionService').buildURL('f:#attributePath##attribute.getAttributeCode()#=#attributeOption.attributeOptionValue#')#" class="remove" id="#attributeOption.attributeOptionValue#" data-toggle="tooltip" data-placement="right" title="Remove">
        															<i class="fa fa-times"></i><span class="filterTitle"> #attributeOption.attributeOptionLabel#</span>
        															<span class="count">#filterCount#</span>
        														</a>   
        													<cfelse>
        														<a id="#attributeOption.attributeOptionValue#" href="#$.slatwall.getService('hibachiCollectionService').buildURL('f:#attributePath##attribute.getAttributeCode()#=#attributeOption.attributeOptionValue#')#">
        															<span class="filterTitle">#attributeOption.attributeOptionLabel#</span>
        															<span class="count">#filterCount#</span>
        														</a>                                        
        													</cfif>
        												</li>
        											</cfif>
        										</cfloop>
        									</ul>
        								</li>
        							</cfloop>
        						</cfloop>
                                    
                            </cfloop>
    						
    						<cfset attribute = $.slatwall.getService('AttributeService').getAttributeByAttributeCode('themes') />
    						<li class="filterObj">
                                <div class="header-wrapper">
    								<span class="arrow arrowToggle"><i class="fa fa-angle-up"></i></span>
    								<span>#attribute.getAttributeName()#</span>
                                </div>
                                
                            	<cfset attributeOptionsCollection = attribute.getAttributeOptionsCollectionlist() />
    							<cfset attributeOptionsCollection.setDistinct(1) />
    							<cfset attributeOptionsCollection.setDisplayProperties('attributeOptionValue,attributeOptionLabel') />
    							<cfif isBoolean($.slatwall.getContent().getProductListingPageFlag()) and $.slatwall.getContent().getProductListingPageFlag()>
    								<cfset attributeOptionsCollection.addFilter(contentIDPropertyPath, $.slatwall.content('contentID')) />
    							</cfif>
    								
    							<ul class="children active">
    								<cfloop array="#attributeOptionsCollection.getRecords()#" index="attributeOption">
    									<cfset filterCount = $.slatwall.getService('buddiesProshopDataService').getFilterCount(url,attribute.getAttributeCode(),  attributeOption.attributeOptionValue, productTypeID ) />
    									<cfif filterCount NEQ 0 >
    										<li>
    											<cfif  productCollection.isFilterApplied(attribute.getAttributeCode(), attributeOption.attributeOptionValue)>
    												<a href="#$.slatwall.getService('hibachiCollectionService').buildURL('f:#attributePath##attribute.getAttributeCode()#=#attributeOption.attributeOptionValue#')#" class="remove" id="#attributeOption.attributeOptionValue#" data-toggle="tooltip" data-placement="right" title="Remove">
    													<i class="fa fa-times"></i><span class="filterTitle"> #attributeOption.attributeOptionLabel#</span>
    													<span class="count">#filterCount#</span>
    												</a>   
    											<cfelse>
    												<a id="#attributeOption.attributeOptionValue#" href="#$.slatwall.getService('hibachiCollectionService').buildURL('f:#attributePath##attribute.getAttributeCode()#=#attributeOption.attributeOptionValue#')#">
    													<span class="filterTitle">#attributeOption.attributeOptionLabel#</span>
    													<span class="count">#filterCount#</span>
    												</a>                                        
    											</cfif>
    										</li>
    									</cfif>
    								</cfloop>
    							</ul>
    						</li>
    						
    						<cfif productTypeObject.getProductTypeName() EQ 'Bowling Shoes & Accessories'>
    							<li class="filterObj">
                                    <div class="header-wrapper">
        								<span class="arrow arrowToggle"><i class="fa fa-angle-up"></i></span>
        								<span>Product Types</span>
                                    </div>
                                    
    								<ul class="children active">
    					            	<cfloop array="#productTypeObject.getChildProductTypes()#" index="local.childProductType" >
    						                <cfif local.childProductType.getProductTypeName() EQ "Shoe Accessories">
    						                	<cfloop array="#local.childProductType.getChildProductTypes()#" index="local.grandChildProductType" >
    												<cfset filterCount = $.slatwall.getService('buddiesProshopDataService').getFilterCount(url,'productType.productTypeID',  grandChildProductType.getProductTypeID() ) />
    												<cfif filterCount NEQ 0 >
    													<li>
    							                			<cfif  productCollection.isFilterApplied('productType.productTypeID', grandChildProductType.getProductTypeID())>
    															<a href="#$.slatwall.getService('hibachiCollectionService').buildURL('f:productType.productTypeID=#grandChildProductType.getProductTypeID()#')#" class="remove" id="#grandChildProductType.getProductTypeName()#" data-toggle="tooltip" data-placement="right" title="Remove">
    																<i class="fa fa-times"></i><span class="filterTitle"> #grandChildProductType.getProductTypeName()#</span>
    																<span class="count">#filterCount#</span>
    															</a>
    														<cfelse>
    															<a id="#grandChildProductType.getProductTypeName()#" href="#$.slatwall.getService('hibachiCollectionService').buildURL('f:productType.productTypeID=#grandChildProductType.getProductTypeID()#')#">
    																<span class="filterTitle">#grandChildProductType.getProductTypeName()#</span>
    																<span class="count">#filterCount#</span>
    															</a>
    														</cfif>
    													</li>
    					                			</cfif>
    											</cfloop>
    						                <cfelseif childProductType.getActiveFlag() >
    						                	<cfset filterCount = $.slatwall.getService('buddiesProshopDataService').getFilterCount(url,'productType.productTypeID',  childProductType.getProductTypeID() ) />
    											<cfif filterCount NEQ 0 >
    												<li>
    						                			<cfif  productCollection.isFilterApplied('productType.productTypeID', childProductType.getProductTypeID())>
    														<a href="#$.slatwall.getService('hibachiCollectionService').buildURL('f:productType.productTypeID=#childProductType.getProductTypeID()#')#" class="remove" id="#childProductType.getProductTypeName()#" data-toggle="tooltip" data-placement="right" title="Remove">
    															<i class="fa fa-times"></i><span class="filterTitle"> #childProductType.getProductTypeName()#</span>
    															<span class="count">#filterCount#</span>
    														</a>
    													<cfelse>
    														<a id="#childProductType.getProductTypeName()#" href="#$.slatwall.getService('hibachiCollectionService').buildURL('f:productType.productTypeID=#childProductType.getProductTypeID()#')#">
    															<span class="filterTitle">#childProductType.getProductTypeName()#</span>
    															<span class="count">#filterCount#</span>
    														</a>
    													</cfif>
    												</li>
    						                	</cfif>
    						                </cfif>
    					                </cfloop>
    								</ul>
    							</li>
    						</cfif>
    					</cfif>
        
    				</ul>--->
    			</form>
    		</div>
    	</div>
	<!--- </cfcache> --->
	<!--- /widget shop categories --->
  <!---  <script>
		//If there are selected filters, add them to the navigation
		  $(window).bind("load", function() {
		    (function(){
		        //*This adds function to the sorting features of the side nav
		        var selectedNameDiv = $('.checkbox label.checked');
		        $(selectedNameDiv).each(function() {
		            var selectedName = $(this).children('.filterTitle').html();
		            var selectedNameLink = $(this).siblings().attr('data-target');
		            $('.removeFilters').append('<a href="' + selectedNameLink + '">' + '<li>' + '<i class="fa fa-times-circle"></i> ' + selectedName + '</li></a>');
		        });
		        if( $('.removeFilters li').length < 1 ){$('.breadcrum h3').hide();};
		    })();
		  });

		  //Hide the remove filters if there are no filters to remove
		  $(function(){
		    $('.filterObj').each(function(){
		      if($(this).children('.children').children('li').size() == 0){
		        $(this).hide();
		      };
		    });
		  });

		  $('.checked').siblings('input').prop('checked', true);
		  $(function () {
			$('[data-toggle="tooltip"]').tooltip();
		  })
    </script>--->
	</cfoutput>
</cfif>

<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.loyaltyAccruement" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>

		 <sw-listing-display data-base-entity-name="AccruementCurrency"
										data-multi-slot="true"
										data-has-action-bar="false"
										data-has-search="false"
										data-edit="false"
										data-record-edit-action="admin:entity.editaccruementcurrency"
			    						data-record-delete-action="admin:entity.deleteaccruementcurrency"
										data-record-edit-modal="true"
										data-is-angular-route="false"
										data-angular-links="false">
				
				<sw-listing-columns>
					<sw-listing-column data-editable="true" data-property-identifier="currencyCode" ></sw-listing-column>
					<sw-listing-column data-editable="true" data-property-identifier="giftCardValue"></sw-listing-column>
			</sw-listing-columns>
			
			<sw-collection-configs>
				<sw-collection-config data-entity-name="AccruementCurrency"
									data-parent-directive-controller-as-name="swListingDisplay"
									data-parent-deferred-property="singleCollectionDeferred"
									data-collection-config-property="collectionConfig"
									data-filter-flag="false">
	
					<sw-collection-columns>
						<sw-collection-column data-property-identifier="currencyCode" data-is-exportable="true" data-is-searchable="false" data-is-visible="false" data-is-only-keyword-column="false" data-is-keyword-column="true"></sw-collection-column>
						<sw-collection-column data-property-identifier="giftCardValue" data-is-exportable="false"  data-is-searchable="true" data-is-only-keyword-column="false" data-is-keyword-column="true"></sw-collection-column>
					</sw-collection-columns>
							
	    		<sw-collection-filters>
	    			<sw-collection-filter data-hidden="true" data-property-identifier="loyaltyAccruement.loyaltyAccruementID" data-comparison-value="#rc.loyaltyAccruement.getLoyaltyAccruementID()#"></sw-collection-filter>
	    		</sw-collection-filters>
	
				</sw-collection-config>
			</sw-collection-configs>
		</sw-listing-display>
		

		<hb:HibachiProcessCaller 
			action="admin:entity.preprocessloyaltyaccruement" 
			entity="#rc.loyaltyAccruement#" 
			processContext="addgiftcardvaluebycurrency"
			querystring="fRedirectAction=admin:entity.detailLoyaltyAccruement"
			class="btn btn-default"
			icon="plus"
			modal="true" 
		/>		
		
</cfoutput>
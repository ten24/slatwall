<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.loyaltyAccruement" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>

<hb:HibachiEntityDetailForm object="#rc.loyaltyAccruement#" edit="#rc.edit#"  
								saveActionQueryString="loyaltyID=#rc.loyalty.getLoyaltyID()#" >
			<hb:HibachiEntityActionBar type="detail" object="#rc.loyaltyAccruement#" edit="#rc.edit#"
								   backAction="admin:entity.detailloyalty"
								   backQueryString="loyaltyID=#rc.loyalty.getLoyaltyID()#"
								   cancelAction="admin:entity.detailloyalty"
								   cancelQueryString="loyaltyID=#rc.loyalty.getLoyaltyID()#" 
							  	   deleteQueryString="redirectAction=admin:entity.detailloyalty&loyaltyID=#rc.loyalty.getLoyaltyID()#" />
		
		<input type="hidden" name="loyalty.loyaltyID" value="#rc.loyalty.getLoyaltyID()#" />
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="activeFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="startDateTime" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="endDateTime" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="expirationTerm" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="accruementEvent" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="accruementType" edit="#rc.edit#">
			<!--- TYPE - POINTS --->
			<hb:HibachiDisplayToggle selector="select[name='accruementType']" showValues="points" loadVisable="#rc.loyaltyAccruement.getAccruementType() == 'points'#">
				
				<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="pointType" edit="#rc.edit#" >
				
				<hb:HibachiDisplayToggle selector="select[name='pointType']" showValues="fixed" loadVisable="#rc.loyaltyAccruement.getPointType() == 'fixed'#">
					<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="pointQuantity" edit="#rc.edit#">
				</hb:HibachiDisplayToggle>
				
			</hb:HibachiDisplayToggle>
			
			<!--- TYPE - GIFT CARD --->
			<hb:HibachiDisplayToggle selector="select[name='accruementType']" showValues="giftCard" loadVisable="#rc.loyaltyAccruement.getAccruementType() == 'giftCard'#">
				
				<div class="form-group s-required">
					<label for="giftCardSku" class="control-label col-sm-4">
						<span class="s-title">Gift Card Sku</span>
						
					</label>
					<div class="col-sm-8">
						<sw-typeahead-input-field
							data-entity-name="Sku"
							data-field-name="giftCardSku.skuID"
							data-property-to-save="skuID"
							data-property-to-show="skuCode"
							data-properties-to-load="skuID,skuCode"
							data-show-add-button="false"
							data-show-view-button="false"
							data-filters="[{propertyIdentifier:'product.productType.systemCode',comparisonValue:'gift-card'}]"
							data-placeholder-text="Search Gift Card"
							data-multiselect-mode="false"
							data-order-by-list="skuName|ASC" >
				
							<span sw-typeahead-search-line-item bind-html="true" data-property-identifier="skuCode"></span>
							
						</sw-typeahead-input-field>
					</div>
				</div>
				
			</hb:HibachiDisplayToggle>
			<!--- TYPE - PROMOTION --->
			<hb:HibachiDisplayToggle selector="select[name='accruementType']" showValues="promotion" loadVisable="#rc.loyaltyAccruement.getAccruementType() == 'promotion'#">
				
				<div class="form-group s-required">
					<label for="giftCardSku" class="control-label col-sm-4">
						<span class="s-title">Promotion</span>
					</label>
					<div class="col-sm-8">
						<sw-typeahead-input-field
							data-entity-name="Promotion"
							data-field-name="promotion.promotionID"
							data-property-to-save="promotionID"
							data-property-to-show="promotionName"
							data-properties-to-load="promotionID,promotionName"
							data-show-add-button="false"
							data-show-view-button="false"
							data-placeholder-text="Search Promotions"
							data-multiselect-mode="false"
							data-order-by-list="promotionName|ASC" >
				
							<span sw-typeahead-search-line-item bind-html="true" data-property-identifier="promotionName"></span>
							
						</sw-typeahead-input-field>
					</div>
				</div>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</hb:HibachiEntityDetailForm>
</cfoutput>
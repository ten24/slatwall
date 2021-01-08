<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.productReview" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<cfif !structKeyExists(rc,'productID')>
					<hb:HibachiPropertyDisplay object="#rc.productReview#" property="product" 
						edit="#rc.edit#" productLabelText="#$.slatwall.rbkey('entity.product_plural')#"
					/>
				</cfif>
				<hb:HibachiPropertyDisplay object="#rc.productReview#" property="activeFlag" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.productReview#" property="reviewTitle" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.productReview#" property="reviewerName" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.productReview#" property="rating" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.productReview#" property="review" edit="#rc.edit#" fieldType="textarea">
				<hb:HibachiPropertyDisplay object="#rc.productReview#" property="productReviewSites" edit="#rc.edit#">
				<cfif rc.productReview.isNew() neq true >
					<hb:HibachiPropertyDisplay object="#rc.productReview#" property="productReviewStatusType" edit="#rc.edit#" fieldType="select" productLabelText="#$.slatwall.rbkey('entity.product_plural')#">
				</cfif>
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
</cfoutput>

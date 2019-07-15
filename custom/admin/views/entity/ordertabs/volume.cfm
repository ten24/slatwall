<cfimport prefix="swa" taglib="../../../../../tags" />
<cfimport prefix="hb" taglib="../../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.order" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divclass="col-md-6">

			<hb:HibachiPropertyDisplay object="#rc.order#" property="personalVolumeSubtotal" edit="false"  />	
			<hb:HibachiPropertyDisplay object="#rc.order#" property="taxableAmountSubtotal" edit="false"  />	
			<hb:HibachiPropertyDisplay object="#rc.order#" property="commissionableVolumeSubtotal" edit="false"  />	
			<hb:HibachiPropertyDisplay object="#rc.order#" property="retailCommissionSubtotal" edit="false"  />	
			<hb:HibachiPropertyDisplay object="#rc.order#" property="productPackVolumeSubtotal" edit="false"  />		
			<hb:HibachiPropertyDisplay object="#rc.order#" property="retailValueVolumeSubtotal" edit="false"  />
			<hb:HibachiPropertyDisplay object="#rc.order#" property="personalVolumeSubtotalAfterItemDiscounts" edit="false"  />	
			<hb:HibachiPropertyDisplay object="#rc.order#" property="taxableAmountSubtotalAfterItemDiscounts" edit="false"  />	
			<hb:HibachiPropertyDisplay object="#rc.order#" property="commissionableVolumeSubtotalAfterItemDiscounts" edit="false"  />	
			<hb:HibachiPropertyDisplay object="#rc.order#" property="retailCommissionSubtotalAfterItemDiscounts" edit="false"  />	
			<hb:HibachiPropertyDisplay object="#rc.order#" property="productPackVolumeSubtotalAfterItemDiscounts" edit="false"  />	
			<hb:HibachiPropertyDisplay object="#rc.order#" property="retailValueVolumeSubtotalAfterItemDiscounts" edit="false"  />		
			<hb:HibachiPropertyDisplay object="#rc.order#" property="personalVolumeTotal" edit="false"  />
			<hb:HibachiPropertyDisplay object="#rc.order#" property="taxableAmountTotal" edit="false"  />
			<hb:HibachiPropertyDisplay object="#rc.order#" property="commissionableVolumeTotal" edit="false"  />
			<hb:HibachiPropertyDisplay object="#rc.order#" property="retailCommissionTotal" edit="false"  />
			<hb:HibachiPropertyDisplay object="#rc.order#" property="productPackVolumeTotal" edit="false"  />
			<hb:HibachiPropertyDisplay object="#rc.order#" property="retailValueVolumeTotal" edit="false"  />
		
			
		</hb:HibachiPropertyList>
		

	</hb:HibachiPropertyRow>
</cfoutput>

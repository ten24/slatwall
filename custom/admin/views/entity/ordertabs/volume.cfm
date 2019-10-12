<cfimport prefix="swa" taglib="../../../../../tags" />
<cfimport prefix="hb" taglib="../../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.order" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<table class="table table-bordered">
		<tr>
			<td><hb:HibachiPropertyDisplay object="#rc.order#" property="personalVolumeSubtotal" edit="false"  /></td>
			<td><hb:HibachiPropertyDisplay object="#rc.order#" property="personalVolumeSubtotalAfterItemDiscounts" edit="false"  /></td>
			<td><hb:HibachiPropertyDisplay object="#rc.order#" property="personalVolumeTotal" edit="false"  /></td>
		</tr>
			
		<tr>	
			<td><hb:HibachiPropertyDisplay object="#rc.order#" property="taxableAmountSubtotal" edit="false"  value="#rc.order.getFormattedValue('taxableAmountSubtotal','decimal')#" /></td>
			<td><hb:HibachiPropertyDisplay object="#rc.order#" property="taxableAmountSubtotalAfterItemDiscounts" edit="false" value="#rc.order.getFormattedValue('taxableAmountSubtotalAfterItemDiscounts','decimal')#" /></td>
			<td><hb:HibachiPropertyDisplay object="#rc.order#" property="taxableAmountTotal" edit="false"  value="#rc.order.getFormattedValue('taxableAmountTotal','decimal')#" /></td>
		</tr>
			
		<tr>
			<td><hb:HibachiPropertyDisplay object="#rc.order#" property="commissionableVolumeSubtotal" edit="false"  value="#rc.order.getFormattedValue('commissionableVolumeSubtotal','decimal')#" /></td>
			
			<td><hb:HibachiPropertyDisplay object="#rc.order#" property="commissionableVolumeSubtotalAfterItemDiscounts" edit="false" value="#rc.order.getFormattedValue('commissionableVolumeSubtotalAfterItemDiscounts','decimal')#" /></td>
			<td><hb:HibachiPropertyDisplay object="#rc.order#" property="commissionableVolumeTotal" edit="false" value="#rc.order.getFormattedValue('commissionableVolumeTotal','decimal')#" /></td>
		</tr>
		
		<tr>
			<td><hb:HibachiPropertyDisplay object="#rc.order#" property="retailCommissionSubtotal" edit="false"  /></td>
			<td><hb:HibachiPropertyDisplay object="#rc.order#" property="retailCommissionSubtotalAfterItemDiscounts" edit="false"  /></td>
			<td><hb:HibachiPropertyDisplay object="#rc.order#" property="retailCommissionTotal" edit="false"  /></td>
		</tr>
		
		<tr>
			<td><hb:HibachiPropertyDisplay object="#rc.order#" property="productPackVolumeSubtotal" edit="false"  /></td>
			<td><hb:HibachiPropertyDisplay object="#rc.order#" property="productPackVolumeSubtotalAfterItemDiscounts" edit="false"  /></td>
			<td><hb:HibachiPropertyDisplay object="#rc.order#" property="productPackVolumeTotal" edit="false"  /></td>
		</tr>
		
		<tr>
			<td><hb:HibachiPropertyDisplay object="#rc.order#" property="retailValueVolumeSubtotal" edit="false"  /></td>
			<td><hb:HibachiPropertyDisplay object="#rc.order#" property="retailValueVolumeSubtotalAfterItemDiscounts" edit="false"  /></td>
			<td><hb:HibachiPropertyDisplay object="#rc.order#" property="retailValueVolumeTotal" edit="false"  /></td>
		</tr>
	
	</table>

</cfoutput>

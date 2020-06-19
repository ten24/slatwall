<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.priceGroupRate" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>	
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.priceGroupRate#" property="amountType" fieldType="select" edit="#rc.edit#" />
			<hb:HibachiPropertyDisplay object="#rc.priceGroupRate#" property="amount" edit="#rc.edit#" />
			<hb:HibachiPropertyDisplay object="#rc.priceGroupRate#" property="currencyCode" fieldType="select" edit="#rc.edit#" />
			<hb:HibachiDisplayToggle selector="select[name=amountType]" showValues="percentageOff" loadVisable="#rc.priceGroupRate.getNewFlag() or rc.priceGroupRate.getValueByPropertyIdentifier('amountType') eq 'percentageOff'#">
				<hb:HibachiPropertyDisplay object="#rc.priceGroupRate#" property="roundingRule" edit="#rc.edit#" displayVisible="amountType:percentageOff" />
			</hb:HibachiDisplayToggle>
			<!---<hb:HibachiPropertyDisplay object="#rc.pricegrouprate#" property="globalFlag" edit="#rc.edit#" />--->
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
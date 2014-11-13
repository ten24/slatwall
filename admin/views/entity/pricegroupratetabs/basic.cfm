<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.priceGroupRate" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiPropertyRow>	
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.priceGroupRate#" property="amountType" fieldType="select" edit="#rc.edit#" />
			<cf_HibachiPropertyDisplay object="#rc.priceGroupRate#" property="amount" edit="#rc.edit#" />
			<cf_HibachiDisplayToggle selector="select[name=amountType]" showValues="percentageOff" loadVisable="#rc.priceGroupRate.getNewFlag() or rc.priceGroupRate.getValueByPropertyIdentifier('amountType') eq 'percentageOff'#">
				<cf_HibachiPropertyDisplay object="#rc.priceGroupRate#" property="roundingRule" edit="#rc.edit#" displayVisible="amountType:percentageOff" />
			</cf_HibachiDisplayToggle>
			<!---<cf_HibachiPropertyDisplay object="#rc.pricegrouprate#" property="globalFlag" edit="#rc.edit#" />--->
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>
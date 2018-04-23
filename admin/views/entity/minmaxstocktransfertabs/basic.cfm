<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.minMaxStockTransfer" type="any" />
<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.minMaxStockTransfer#" property="fromLocation" edit="#rc.edit#"/>
			<hb:HibachiPropertyDisplay object="#rc.minMaxStockTransfer#" property="toLocation" edit="#rc.edit#"/>
			<hb:HibachiPropertyDisplay object="#rc.minMaxStockTransfer#" property="createdDateTime" edit="false"/>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>

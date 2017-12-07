<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.minMaxStockTransferItem" type="any" />
<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyList divclass="col-md-6">
				<hb:HibachiPropertyDisplay object="#rc.minMaxStockTransferItem#" property="sku" edit="false"/>
				<hb:HibachiPropertyDisplay object="#rc.minMaxStockTransferItem#" property="fromTopLocation" edit="false"/>
				<hb:HibachiPropertyDisplay object="#rc.minMaxStockTransferItem#" property="fromLeafLocation" edit="false"/>
				<hb:HibachiPropertyDisplay object="#rc.minMaxStockTransferItem#" property="fromMinQuantity" edit="false"/>
				<hb:HibachiPropertyDisplay object="#rc.minMaxStockTransferItem#" property="fromMaxQuantity" edit="false"/>
				<hb:HibachiPropertyDisplay object="#rc.minMaxStockTransferItem#" property="fromOffsetQuantity" edit="false"/>
				<hb:HibachiPropertyDisplay object="#rc.minMaxStockTransferItem#" property="fromSumQATS" edit="false"/>
				<hb:HibachiPropertyDisplay object="#rc.minMaxStockTransferItem#" property="fromCalculatedQATS" edit="false"/>
			</hb:HibachiPropertyList>
			<hb:HibachiPropertyList divclass="col-md-6">
				<hb:HibachiPropertyDisplay object="#rc.minMaxStockTransferItem#" property="transferQuantity" edit="#rc.edit#"/>
				<hb:HibachiPropertyDisplay object="#rc.minMaxStockTransferItem#" property="toTopLocation" edit="false"/>
				<hb:HibachiPropertyDisplay object="#rc.minMaxStockTransferItem#" property="toLeafLocation" edit="false"/>
				<hb:HibachiPropertyDisplay object="#rc.minMaxStockTransferItem#" property="toMinQuantity" edit="false"/>
				<hb:HibachiPropertyDisplay object="#rc.minMaxStockTransferItem#" property="toMaxQuantity" edit="false"/>
				<hb:HibachiPropertyDisplay object="#rc.minMaxStockTransferItem#" property="toOffsetQuantity" edit="false"/>
				<hb:HibachiPropertyDisplay object="#rc.minMaxStockTransferItem#" property="toSumQATS" edit="false"/>
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>


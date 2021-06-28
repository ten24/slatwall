<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.inventoryAnalysis" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.inventoryAnalysis#" property="inventoryAnalysisName" edit="#rc.edit#" />
			<hb:HibachiPropertyDisplay object="#rc.inventoryAnalysis#" property="analysisStartDateTime" edit="#rc.edit#" />
			<hb:HibachiPropertyDisplay object="#rc.inventoryAnalysis#" property="daysOut" edit="#rc.edit#" />

			<hb:HibachiPropertyDisplay object="#rc.inventoryAnalysis#" property="analysisHistoryStartDateTime" edit="false" />
			<hb:HibachiPropertyDisplay object="#rc.inventoryAnalysis#" property="analysisHistoryEndDateTime" edit="false" />
			<hb:HibachiPropertyDisplay object="#rc.inventoryAnalysis#" property="analysisHistoryDaysOutDateTime" edit="false" />

		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>

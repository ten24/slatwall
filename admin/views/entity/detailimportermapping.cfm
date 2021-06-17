<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.importerMapping" type="any">
<cfparam name="rc.edit" type="boolean">

<hb:HibachiEntityDetailForm object="#rc.importerMapping#" edit="#rc.edit#">
	<hb:HibachiEntityActionBar type="detail" object="#rc.importerMapping#" edit="#rc.edit#">
		<hb:HibachiActionCaller action="slatwallImporter:main.getSampleCSV" querystring="mappingCode=#rc.importerMapping.getMappingCode()#" type="list" />
		<hb:HibachiProcessCaller entity="#rc.importerMapping#" action="slatwallimporter:main.preprocessintegration" querystring="mappingCode=#rc.importerMapping.getMappingCode()#" processContext="importcsv" type="list" modal="true" />
	</hb:HibachiEntityActionBar>
	<hb:HibachiEntityDetailGroup object="#rc.importerMapping#">
		<hb:HibachiEntityDetailItem view="admin:entity/importermappingtabs/basic" open="true" text="#$.slatwall.rbKey('admin.define.basic')#" showOnCreateFlag=true />
	</hb:HibachiEntityDetailGroup>
</hb:HibachiEntityDetailForm>
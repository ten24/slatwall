<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.fileGroup" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList divclass="col-md-12">
				<hb:HibachiPropertyDisplay object="#rc.fileGroup#" property="fileGroupName" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.fileGroup#" property="fileGroupCode" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.fileGroup#" property="fileGroupDescription" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.fileGroup#" property="fileRestrictAccessFlag" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.fileGroup#" property="fileTrackAccessFlag" edit="#rc.edit#">
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
</cfoutput>

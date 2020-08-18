<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.entityqueue" type="any" />
<cfparam name="rc.edit" type="boolean"/>
<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.entityqueue#" property="baseObject" >
			<hb:HibachiPropertyDisplay object="#rc.entityqueue#" property="processMethod" edit="#rc.edit#" >
			<hb:HibachiPropertyDisplay object="#rc.entityqueue#" property="entityQueueDateTime">
			<hb:HibachiPropertyDisplay object="#rc.entityqueue#" property="logHistoryFlag">
			<hb:HibachiPropertyDisplay object="#rc.entityqueue#" property="mostRecentError">
			<hb:HibachiPropertyDisplay object="#rc.entityqueue#" property="tryCount">
			<hb:HibachiPropertyDisplay object="#rc.entityqueue#" property="entityQueueProcessingDateTime">
			<hb:HibachiPropertyDisplay object="#rc.entityQueue#" property="entityQueueData" edit="#rc.edit#" fieldType="textarea" fieldAttributes="rows='20'">	
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>

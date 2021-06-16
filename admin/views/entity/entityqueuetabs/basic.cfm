<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.entityqueue" type="any" />
<cfparam name="rc.edit" type="boolean"/>
<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.entityqueue#" property="baseObject" >
			<hb:HibachiPropertyDisplay object="#rc.entityqueue#" property="baseID" >
			<cfif NOT isNUll(rc.entityqueue.getBatch()) >
			    <hb:HibachiPropertyDisplay object="#rc.entityqueue#" property="batch" valuelink="?slatAction=admin:entity.detailbatch&batchID=#rc.entityqueue.getBatch().getBatchID()#">
			</cfif>
			<hb:HibachiPropertyDisplay object="#rc.entityqueue#" property="integration" >
			<hb:HibachiPropertyDisplay object="#rc.entityqueue#" property="processMethod" edit="#rc.edit#" >
			<hb:HibachiPropertyDisplay object="#rc.entityqueue#" property="entityQueueDateTime">
			<hb:HibachiPropertyDisplay object="#rc.entityqueue#" property="logHistoryFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.entityqueue#" property="tryCount" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.entityqueue#" property="mostRecentError" fieldType="json" fieldAttributes="rows='10'" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.entityqueue#" property="entityQueueProcessingDateTime">
			<hb:HibachiPropertyDisplay object="#rc.entityQueue#" property="entityQueueData" edit="#rc.edit#" fieldType="json" fieldAttributes="rows='20'">	
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>

<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.entityqueuefailure" type="any" />
<cfparam name="rc.edit" type="boolean"/>
<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.entityqueuefailure#" property="baseObject" >
			<hb:HibachiPropertyDisplay object="#rc.entityqueuefailure#" property="processMethod" edit="#rc.edit#" >
			<hb:HibachiPropertyDisplay object="#rc.entityqueuefailure#" property="entityQueueDateTime">
			<hb:HibachiPropertyDisplay object="#rc.entityqueuefailure#" property="mostRecentError">
			<hb:HibachiPropertyDisplay object="#rc.entityqueuefailure#" property="tryCount">
			<hb:HibachiPropertyDisplay object="#rc.entityqueuefailure#" property="entityQueueProcessingDateTime">
			<hb:HibachiPropertyDisplay object="#rc.entityqueuefailure#" property="entityQueueData" edit="#rc.edit#" fieldType="textarea" fieldAttributes="rows='20'">	
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>

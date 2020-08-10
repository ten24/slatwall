<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.src" type="any" default="" />
	<cfparam name="attributes.type" type="any" default="" />
	<cfset keyHash = hash(attributes.src,'md5')/>
	<cfscript>
		cacheKey = 'HibachiScript_#keyHash#';
		if(!attributes.hibachiScope.getService('hibachiCacheService').hasCachedValue(cacheKey)){
			fileHash = hash(fileReadBinary(expandPath(attributes.src)),'md5');
			attributes.hibachiScope.getService('hibachiCacheService').setCachedValue(cacheKey,fileHash);
		}
		fileHash = attributes.hibachiScope.getService('hibachiCacheService').getCachedValue(cacheKey);
	</cfscript>
	<cfoutput>
		<script src="#attributes.src#?#keyHash#=#fileHash#" type="#attributes.type#"></script>
	</cfoutput>
</cfif>

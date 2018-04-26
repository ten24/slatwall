<cfoutput>
	<nav>
	    <ul class="pagination">
	    	<cfif currentPage NEQ 1>
		    	<!--- First --->
		    	<li>
		    		<a href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current=1' )#">
		    		#attributes.first#
		    		</a>
		    	</li>
		        
		        <!--- Previous --->
		        <li><a href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current='&previousPage )#">
		        	#attributes.previous#
		        	</a>
		        </li>
	        </cfif>
	        <!--- Show previous pages if they exist --->
	        <cfif nextPage GT 2>
	        	<cfset fourPagesAgo = currentPage - 4>
	            <cfloop condition="fourPagesAgo LT currentPage">
	                <cfif fourPagesAgo GT 0>
						<li><a href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current=#fourPagesAgo#' )#">#fourPagesAgo#</a></li>
	                </cfif>
	                <cfset fourPagesAgo += 1>
	            </cfloop>
	        </cfif>
	        
	        <!--- Self --->
	        <li class="active">
	        	<a href="##">#attributes.collection.getCurrentPageDeclaration()#</a>
	        </li>
	        
	        <!--- Show next 4 pages if they exist minus the ones shown before the current page. --->
	        <cfloop condition="nextPage LTE lastPage AND nextPage LTE currentPage+4">
	            <li><a href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current=#nextPage#' )#">#nextPage#</a></li>
	            <cfset nextPage+=1>
	        </cfloop>
		    <cfif nextPage LT attributes.collection.getTotalPages()>
			<!--- Next --->	
			<li>
				<a href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current=#currentPage+1#' )#" title="Next Page #currentPage+1#">
		        	#attributes.next#
		        </a>
		    </li>	        	
	        <!--- Last --->
	        <li>
	        	<a href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current='&lastPage )#" title="Last Page #lastPage#">
	        	#attributes.last#
	        	</a>
	        </li>
		    </cfif>
	    </ul>
	</nav>
</cfoutput>


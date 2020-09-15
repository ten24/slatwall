<cfoutput>
	            <!--- Example Pagination Markup --->
   <!---     	<nav class="mt-5">--->
			<!---	<ul class="pagination">--->
			<!---		<li class="page-item disabled"><a class="page-link" href="##">Previous</a></li>--->
			<!---    	<li class="page-item active"><a class="page-link" href="##">1</a></li>--->
			<!---    	<li class="page-item"><a class="page-link" href="##">2</a></li>--->
			<!---    	<li class="page-item"><a class="page-link" href="##">3</a></li>--->
			<!---    	<li class="page-item"><a class="page-link" href="##">Next</a></li>--->
			<!---	</ul>--->
			<!--</nav>--->
	<nav class="mt-5">
	    <ul class="pagination">
	    	<cfif currentPage NEQ 1>
			    <cfif attributes.showFirstAndLast>
		    		<!--- First --->
				    	<li class="page-item"><a class="page-link" href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current=1' )#" <cfif currentPage EQ 1>disabled="disabled" title="First Page" </cfif>>
				    	#attributes.first#
				    	</a></li>
				</cfif>
		        <!--- Previous --->
		        <li class="page-item"><a class="page-link" href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current='&previousPage )#">
		        	#attributes.previous#
		        	</a>
		        </li>
	        </cfif>
	        <!--- Show previous pages if they exist --->
	        <cfif nextPage GT 2>
	        	<cfset fourPagesAgo = currentPage - 4>
	            <cfloop condition="fourPagesAgo LT currentPage">
	                <cfif fourPagesAgo GT 0>
						<li class="page-item"><a class="page-link" href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current=#fourPagesAgo#' )#">#fourPagesAgo#</a></li>
	                </cfif>
	                <cfset fourPagesAgo += 1>
	            </cfloop>
	        </cfif>
	        
	        <!--- Self --->
	        <li class=" page-item active">
	        	<a class="page-link" href="##">#attributes.collection.getCurrentPageDeclaration()#</a>
	        </li>
	        
	        <!--- Show next 4 pages if they exist minus the ones shown before the current page. --->
	        <cfloop condition="nextPage LTE lastPage AND nextPage LTE currentPage+4">
	            <li class="page-item"><a class="page-link" href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current=#nextPage#' )#">#nextPage#</a></li>
	            <cfset nextPage+=1>
	        </cfloop>
		    <cfif currentPage LT attributes.collection.getTotalPages()>
				<!--- Next --->	
				<li class="page-item">
					<a class="page-link" href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current=#currentPage+1#' )#" title="Next Page #currentPage+1#">
			        	#attributes.next#
			        </a>
			    </li>
				<cfif attributes.showFirstAndLast>
		    		<!--- Last --->
			        <li class="page-item">
						<a class="page-link" href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current='&lastPage )#" title="Last Page #lastPage#">
			        		#attributes.last#
			        	</a>
			        </li>
			     </cfif>
		    </cfif>
	    </ul>
	</nav>
</cfoutput>


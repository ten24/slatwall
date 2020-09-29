<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.report" type="any" />
	<cfparam name="attributes.collectionList" type="any" />
	<cfparam name="attributes.enableAveragesAndSums" type="boolean" default="true"/> 
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	
	<cfoutput>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/Chart.bundle.min.js"></script>
									<cfset scopeVariableID = '#attributes.collectionlist.getCollectionObject()##rereplace(createUUID(),'-','','all')#'/>
				<cfset entityMetaData = getMetaData(attributes.collectionList.getCollectionEntityObject())/>
	
				<cfset attributes.collectionList.getCollectionConfigStruct()["enableAveragesAndSums"] = attributes.enableAveragesAndSums />
				<cfset JSON = serializeJson(attributes.collectionList.getCollectionConfigStruct())/>

				<!---escape apostrophes--->
				<cfset JSON = rereplace(JSON,"'","\'",'all')/>
				<!---convert double quotes to single--->
				<cfset JSON = rereplace(JSON,'"',"'",'all')/>
				<span ng-init="
					#scopeVariableID#=$root.hibachiScope.$injector.get('collectionConfigService').newCollectionConfig().loadJson(#JSON#);
				"></span>
				
				<cfif !attributes.collectionList.getNewFlag() && !structKeyExists(attributes.collectionList.getCollectionConfigStruct(),'periodInterval') >
					<span ng-controller="collections"
						data-table-id="#scopeVariableID#"
						data-collection-id="#attributes.collectionList.getCollectionID()#"
					>
					</span>
				</cfif>
				
				<cfset personalCollectionKey = hash(serializeJson(attributes.collectionList.getCollectionConfigStruct()))/>
	
		<div id="hibachi-report" data-reportname="#attributes.report.getClassName()#">
			<!--- Configure --->
			<div id="hibachi-report-configure-bar">
				#attributes.report.getReportConfigureBar()#
			</div>
			
			
				<sw-dashboard>
			<div class="Mcard-wrapper col-md-12">
		        <div class="col-md-3">
		        		<sw-stat-widget 
						title="Sales" 
						metric="salesRevenueThisPeriod"
						img-src="/assets/images/piggy-bank-1.png"
						img-alt="Piggy Bank"
						footer-class="Mcard-footer1"
					>
					</sw-stat-widget>
		        </div>
		
		
				<div class="col-md-3">
		         		<sw-stat-widget 
						title="Order Count" 
						metric="orderCount"
						img-src="/assets/images/shopping-bag-gray.png"
						img-alt="Shopping Bags"
						footer-class="Mcard-footer2"
					>
					</sw-stat-widget>

		        </div>
		
		        <div class="col-md-3">
		        	<sw-stat-widget 
						title="Average Order Value" 
						metric="averageOrderTotal"
						img-src="/assets/images/dollar-symbol-gray.png"
						img-alt="Dollar Symbol Badge"
						footer-class="Mcard-footer4"
					>
					</sw-stat-widget>
		        </div>
		        
		    	<div class="col-md-3">
		    		<sw-stat-widget 
						title="Accounts Created" 
						metric="accountCount"
						img-src="/assets/images/user-2.png"
						img-alt="User Icon"
						footer-class="Mcard-footer3"
					>
					</sw-stat-widget>
		        </div>
			<sw-chart-widget name="tom" report-title=#attributes.report.getReportEntity().getReportTitle()# />

			</div>
			
			
	
				<sw-report-menu
					data-collection-config="#scopeVariableID#"
				>
				</sw-report-menu>

				
				
		</sw-dashboard>
			

			
					



			

			<script type="text/javascript">
				// jQuery(document).ready(function(){
				// 	addLoadingDiv( 'hibachi-report' );
				// 	updateReport();
				// });
			</script>
		</div>
	</cfoutput>
</cfif>


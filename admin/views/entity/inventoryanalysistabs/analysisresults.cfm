<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.inventoryAnalysis" type="any">
<cfparam name="rc.edit" type="boolean">
<cfparam name="url['P:Current']" default="1">

	<cfset rc.inventoryAnalysis.getSkuCollection().setPageRecordsStart(url['P:Current'])>

	<cfoutput>

		<table class="table table-striped table-bordered table-condensed">
			<!--- Term Payment Details --->
			<thead>
				<tr>
					<th colspan="11">#$.slatwall.rbKey('entity.inventoryAnalysis')#</th>
				</tr>
				<tr>
					<th>Product Type</th>
					<th>Sku Code</th>
					<th>Description</th>
					<th>Definition</th>
					<th>Net Sales Last 12 Months</th>
					<th>Committed <br>QC</th>
					<th>Expected <br>QE</th>
					<th>On Hand <br>QOH</th>
					<th>Estimated Months Remaining</th>
					<th>Total On Hand <br>QOH+QC</th>
					<th>Estimated Days Out</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="#rc.inventoryAnalysis.getReportData().query#">
					<tr>
						<td>#ProductType#</td>
						<td>#SkuCode#</td>
						<td>#Description#</td>
						<td>#Definition#</td>
						<td>#NetSalesLast12Months#</td>
						<td>#CommittedQC#</td>
						<td>#ExpectedQE#</td>
						<td>#OnHandQOH#</td>
						<td>
							<cfif EstimatedMonthsRemaining neq 0>
								#numberFormat(EstimatedMonthsRemaining,'9.99')#	
							<cfelse>
								-
							</cfif>
						</td>
						<td>#TotalOnHandQOHplusQC#</td>
						<td>#EstimatedDaysOut#</td>
					</tr>
				</cfloop>
			</tbody>
		</table>

		<swa:SlatwallCollectionPagination collection="#rc.inventoryAnalysis.getSkuCollection()#" slatwallScope="#rc.$.slatwall#" />

	</cfoutput>

<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.inventoryAnalysis" type="any">
<cfparam name="rc.edit" type="boolean">
<cfparam name="url['P:Current']" default="1">
	<cfset currentCollection = rc.inventoryAnalysis.getSkuCollection()/>
	<cfif isNumeric(url['P:Current'])>
		<cfset currentPage = url['P:Current']/>
		<cfset currentCollection.setCurrentPageDeclaration(currentPage)/>
	</cfif>
	<cfoutput>

		<table class="table table-striped table-bordered table-condensed">
			<!--- Term Payment Details --->
			<thead>
				<tr>
					<th colspan="11">#$.slatwall.rbKey('entity.inventoryAnalysis')#</th>
				</tr>
				<tr>
					<th>Product Type</th>
					<th>Product Name</th>
					<th>Sku Code</th>
					<th>Description</th>
					<th>Definition</th>
					<th>Net Sales Last 12 Months</th>
					<th>Committed <br>QC</th>
					<th>On Quote <br>QOH</th>
					<th>Expected <br>QE</th>
					<th>On Hand <br>QOH</th>
					<th>Total Qty <br>QOH+QE</th>
					<th>Estimated Months Remaining</th>
					<th>Estimated Sales Quantity</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="#rc.inventoryAnalysis.getReportData(currentPage=currentPage).query#">
					<tr>
						<td>#ProductType#</td>
						<td>#ProductName#</td>
						<td>#SkuCode#</td>
						<td>#Description#</td>
						<td>#Definition#</td>
						<td>#NetSalesLast12Months#</td>
						<td>#CommittedQC#</td>
						<td>#QOQ#</td>
						<td>#ExpectedQE#</td>
						<td>#OnHandQOH#</td>
						<td>#TotalQtyQOHplusQE#</td>
						<td>
							<cfif EstimatedMonthsRemaining neq 0>
								#numberFormat(EstimatedMonthsRemaining,'9.99')#	
							<cfelse>
								-
							</cfif>
						</td>
						<td>#EstimatedSalesQuantity#</td>
					</tr>
				</cfloop>
			</tbody>
		</table>

		<swa:SlatwallCollectionPagination collection="#currentCollection#" slatwallScope="#rc.$.slatwall#" />

	</cfoutput>
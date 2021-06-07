<cfoutput>
	<table class="signature" style="clear:both;">
        <tbody>
            <tr>
                <td>Print Name</td>
                <td>Signature</td>
                <td>Date</td>
            </tr>
        </tbody>
    </table>

	<table>
		<tr>
			<td style="width:70px; height:70px; border: 1px solid black; border-bottom:2px solid black; border-right:2px solid black; text-align: center;">&nbsp;</td>
			<td style="padding-left:10px;">Total Number of Pieces</td>
		</tr>
	</table>

	<cfif order.getPaymentAmountDue() GT 0 >
		<div style="border: 1px solid red; display:inline-block; padding:10px 20px; margin-top:20px;">
			<h1 style="color:red; margin:0;">NOT PAID</h1>
		</div>
	</cfif>
</cfoutput>
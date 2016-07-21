<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:

	This is an email template designed to be used to customize the emails
	that slatwall sends.  If you would like to customize this template, it
	should first be coppied into the /custom/templates/ directory in the
	same folder path naming convention that it currently resides inside.

	All email templates have 2 objects that are passed in (seen below):

	email: This is the actually email entity that will have things like a
	to, from, ext... that will eventually be persisted to the database as
	a log of this e-mail so long as the "Log Email" setting is set to true

	emailData: This is a structure used to set values that will get
	populated into the email entity once this processing is complete.
	Typically you will want to set emailData.htmlBody & emailData.textBody
	however, you can also set any of the other properties as well.  If you
	do not set emailData.htmlBody, then the output of this include will be
	used as the htmlBody, and no textBody will be set.
	It will also be used as a final stringReplace() struct for any ${} keys
	that have not already been relpaced.  Another key field that you can
	set in the emailData is voidSend=true which will cancel the sending of
	this e-mail.

	Lastly, the base object that is being used for this email should also
	be injected into the template and paramed at the top.

--->
<cfparam name="email" type="any" />
<cfparam name="emailData" type="struct" default="#structNew()#" />
<cfparam name="giftCard" type="any" />

<cfsilent>
	<cfset email.setEmailTo("#giftCard.getOwnerEmailAddress()#")>
	<cfset email.setRelatedObject("giftCard")>
	<cfset email.setRelatedObjectID("#giftCard.getGiftCardID()#")>
	<cfset email.setLogEmailFlag("True")>
</cfsilent>

<cfsavecontent variable="emailData.emailBodyHTML">
	<cfoutput>
		<div id="container" style="width: 625px; font-family: arial; font-size: 12px;background:##fff;">

			<!--- Add Logo Here  --->
			<!--- <img src="http://Full_URL_Path_To_Company_Logo/logo.jpg" border="0" style="float: right;"> --->

			<div id="top" style="width: 325px; margin: 0; padding: 0;">
				<h1 style="font-size: 20px;">A Gift Card Sent To #giftCard.getOrderItemGiftRecipient().getEmailAddress()# Has Failed</h1>
                <p>Below are the details of the gift card that failed to send.</p>

				<table id="giftCardInfo" style="border-spacing: 0px; border-collapse: collapse; border: 1px solid ##d8d8d8; text-align: left; font-size: 12px; width: 350px;">
					<tbody>
                        <tr>
                            <th>Code:</th>
                            <th>Balance:</th>
                        </tr>
						<tr>
							<td>#giftCard.getGiftCardCode()#</td>
							<td>#giftCard.getBalanceAmount()#</td>
						</tr>
					</tbody>
				</table>
			</div>

			<br style="clear:both;" />


		</div>
	</cfoutput>
</cfsavecontent>
<cfsavecontent variable="emailData.emailBodyText">
	<cfoutput>
		=================================
		A Gift Card Sent To #giftCard.getOrderItemGiftRecipient().getEmailAddress()# Has Failed,
		Below are the details of the gift card that failed to send.
		=================================
		Gift Card Code: #giftCard.getGiftCardCode()#
		Gift Card Balance: #giftCard.getBalanceAmount()#
		=================================
	</cfoutput>
</cfsavecontent>



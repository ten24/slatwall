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

	Event Registration Status Types
	__________________
	erstRegistered
	erstPendingApproval
	erstWaitlisted
	erstPendingConfirmation
	erstAttended

--->
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.eventregistration" type="any" />
<cfparam name="rc.edit" type="boolean" default="false" />

<cfoutput>
	<hb:HibachiEntityDetailForm object="#rc.eventregistration#" edit="#rc.edit#">
		<hb:HibachiEntityActionBar type="detail" object="#rc.eventregistration#" edit="#rc.edit#"
								   backaction="admin:entity.detailsku"
								   backquerystring="skuID=#rc.eventregistration.getsku().getSkuID()###tabeventregistrations">

			<!--- Change Status --->
			<hb:HibachiProcessCaller action="admin:entity.preprocessEventRegistration" entity="#rc.eventRegistration#" processContext="approve" type="list" modal="true" />
			<hb:HibachiProcessCaller action="admin:entity.preprocessEventRegistration" entity="#rc.eventRegistration#" processContext="attend" type="list" modal="true" />
			<hb:HibachiProcessCaller action="admin:entity.preprocessEventRegistration" entity="#rc.eventRegistration#" processContext="cancel" type="list" modal="true" />
			<hb:HibachiProcessCaller action="admin:entity.preprocessEventRegistration" entity="#rc.eventRegistration#" processContext="pendingApproval" type="list" modal="true" />
			<hb:HibachiProcessCaller action="admin:entity.preprocessEventRegistration" entity="#rc.eventRegistration#" processContext="pendingConfirmation" type="list" modal="true" />
			<hb:HibachiProcessCaller action="admin:entity.preprocessEventRegistration" entity="#rc.eventRegistration#" processContext="register" type="list" modal="true" />
			<hb:HibachiProcessCaller action="admin:entity.preprocessEventRegistration" entity="#rc.eventRegistration#" processContext="waitlist" type="list" modal="true" />

		</hb:HibachiEntityActionBar>

		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList divClass="col-md-6">
				<hb:HibachiPropertyDisplay object="#rc.eventregistration.getaccount()#" property="fullName" valuelink="?slatAction=admin:entity.detailaccount&accountID=#rc.eventregistration.getaccount().getAccountID()#">
				<hb:HibachiPropertyDisplay object="#rc.eventregistration.getsku().getproduct()#" property="productName"  valuelink="?slatAction=admin:entity.detailproduct&productID=#rc.eventregistration.getsku().getproduct().getProductID()#">
				<hb:HibachiPropertyDisplay object="#rc.eventregistration.getsku()#" property="eventStartDateTime" edit="false">
				<hb:HibachiPropertyDisplay object="#rc.eventregistration.getsku()#" property="eventEndDateTime" edit="false" >
				<hb:HibachiPropertyDisplay object="#rc.eventregistration.getsku()#" property="startReservationDateTime" edit="false">
				<hb:HibachiPropertyDisplay object="#rc.eventregistration.getsku()#" property="endReservationDateTime" edit="false" >
				<hb:HibachiPropertyDisplay object="#rc.eventregistration#" property="eventRegistrationStatusType" edit="false" title="#$.slatwall.rbKey('entity.type.parentType.eventRegistrationStatusType')#" >
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>

	</hb:HibachiEntityDetailForm>

</cfoutput>

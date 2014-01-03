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
	erstApproved
	erstWaitListed
	erstPending
	erstAttended
	erstCancelled

--->
<cfparam name="rc.eventregistration" type="any" />
<cfparam name="rc.edit" type="boolean" default="false" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.eventregistration#" edit="#rc.edit#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.eventregistration#" edit="#rc.edit#"
								   backaction="admin:entity.detailproduct"
								   backquerystring="productID=#rc.eventregistration.getorderitem().getsku().getproduct().getProductID()###tabeventregistrations"
								   deleteQueryString="redirectAction=admin:entity.detaileventregistration&eventregistrationID=#rc.eventregistration.geteventregistrationID()#">
			
			<!--- Change Status (onHold, close, cancel, offHold) --->
			<cf_HibachiProcessCaller action="admin:entity.processEventRegistration" entity="#rc.eventRegistration#" processContext="registered" type="list" modal="false" />
			<cf_HibachiProcessCaller action="admin:entity.processEventRegistration" entity="#rc.eventRegistration#" processContext="attended" type="list" modal="false" />
			<cf_HibachiProcessCaller action="admin:entity.processEventRegistration" entity="#rc.eventRegistration#" processContext="approved" type="list" modal="false" />
			<cf_HibachiProcessCaller action="admin:entity.processEventRegistration" entity="#rc.eventRegistration#" processContext="waitlisted" type="list" modal="false" />
			<cf_HibachiProcessCaller action="admin:entity.processEventRegistration" entity="#rc.eventRegistration#" processContext="pending" type="list" modal="false" />
			<cf_HibachiProcessCaller action="admin:entity.processEventRegistration" entity="#rc.eventRegistration#" processContext="cancelled" type="list" modal="false" />
			<!---<cf_HibachiProcessCaller action="admin:entity.processEventRegistration" entity="#rc.eventRegistration#" processContext="notPlaced" type="list" modal="false" />--->
			
			
		</cf_HibachiEntityActionBar>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList divClass="span6">
				<cf_HibachiPropertyDisplay object="#rc.eventregistration.getaccount()#" property="fullName" valuelink="?slatAction=admin:entity.detailaccount&accountID=#rc.eventregistration.getaccount().getAccountID()#">
				<cf_HibachiPropertyDisplay object="#rc.eventregistration.getorderitem().getsku().getproduct()#" property="productName"  valuelink="?slatAction=admin:entity.detailproduct&productID=#rc.eventregistration.getorderitem().getsku().getproduct().getProductID()#">
				<cf_HibachiPropertyDisplay object="#rc.eventregistration.getorderitem().getsku()#" property="eventStartDateTime" edit="false">
				<cf_HibachiPropertyDisplay object="#rc.eventregistration.getorderitem().getsku()#" property="eventEndDateTime" edit="false" >
				<cf_HibachiPropertyDisplay object="#rc.eventregistration.getorderitem().getsku()#" property="startReservationDateTime" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.eventregistration.getorderitem().getsku()#" property="endReservationDateTime" edit="#rc.edit#" >
				<cf_HibachiPropertyDisplay object="#rc.eventregistration#" property="eventRegistrationStatusType" edit="false" title="#$.slatwall.rbKey('entity.type.parentType.eventRegistrationStatusType')#" >
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
	</cf_HibachiEntityDetailForm>

</cfoutput>

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

--->
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.productschedule" type="any" />
<cfparam name="rc.edit" default="false">

<cfoutput>
	<hb:HibachiEntityDetailForm object="#rc.productschedule#" edit="#rc.edit#">
		<hb:HibachiEntityActionBar type="detail" object="#rc.productschedule#" edit="#rc.edit#"
					backAction="admin:entity.detailproduct"
					backQueryString="productID=#rc.productschedule.getProduct().getProductID()#">
			<hb:HibachiProcessCaller entity="#rc.productschedule.getFirstScheduledSku()#" action="admin:entity.preprocesssku" processContext="changeeventdates" type="list" modal="true" querystring="edittype=all	" />
	</hb:HibachiEntityActionBar>


		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>

				<hb:HibachiPropertyDisplay object="#rc.productschedule#" property="recurringTimeUnit" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.productschedule#" property="weeklyRepeatDays" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.productschedule#" property="monthlyRepeatByType" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.productschedule#" property="scheduleEndDate" edit="#rc.edit#">

			</hb:HibachiPropertyList>

		</hb:HibachiPropertyRow>

	</hb:HibachiEntityDetailForm>
</cfoutput>

<script>
	$("input[name='eventStartDateTime']").change(function() {
		var dayNames = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
		var weeks = ["First","Second","Third","Fourth","Fifth"];
		var monthDay = ["1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th","11th","12th","13th","14th","15th","16th","17th","18th","19th","20th","21st","22nd","23rd","24th","25th","26th","27th","28th","29th","30th","31st"];
		var scheduleStartDate = new Date($("input[name='eventStartDateTime']").val());
		var dateOnly = $(this).val().substring(0,$(this).val().length-9);
		$("input[name='scheduleStartDate']").val(dateOnly);
		var weekdaySummary = "Occurs every " + weeks[Math.ceil(scheduleStartDate.getDate()/7)-1] + " " + dayNames[scheduleStartDate.getDay()];
		var monthdaySummary = "Occurs on the " + monthDay[scheduleStartDate.getDate()-1] + " of every month";
		$("#monthlyRepeatByWeekdaySummary").text(weekdaySummary);
		$("#monthlyRepeatByMonthdaySummary").text(monthdaySummary);
	});

</script>

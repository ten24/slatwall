<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.orderTemplate" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<cfif rc.orderTemplate.getOrderTemplateType().getSystemCode() NEQ 'ottWishList'>
				<div class="col-md-2">
					<label class="control-label">#getHibachiScope().rbKey('entity.orderTemplate.createdDateTime')#</label>
					<p class="form-control-static">#DateFormat(rc.orderTemplate.getCreatedDateTime(),'mm/dd/yyyy')#</p>
				</div> 
				
				<div class="col-md-2">
					<label class="control-label">#getHibachiScope().rbKey('entity.orderTemplate.orderTemplateStatusType')#</label>
					<p class="form-control-static">#rc.orderTemplate.getOrderTemplateStatusType().getTypeName()#</p>
				</div> 
				
				<div class="col-md-2">
					<sw-order-template-frequency-card 
							data-order-template="#rc.orderTemplate.getEncodedJsonRepresentation()#"
							data-frequency-term-options="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(rc.orderTemplate.getFrequencyTermOptions()))#"
						<cfif not isNull(rc.orderTemplate.getFrequencyTerm())>
							data-frequency-term="#rc.orderTemplate.getFrequencyTerm().getEncodedJsonRepresentation()#"
						</cfif>
					>
					</sw-order-template-frequency-card>
				</div> 
				
				<div class="col-md-2">
					<label class="control-label">#getHibachiScope().rbKey('entity.orderTemplate.lastOrderPlacedDateTime')#</label>
					<cfif not isNull(rc.orderTemplate.getLastOrderPlacedDateTime()) > 
						<p class="form-control-static">#dateTimeFormat(rc.orderTemplate.getLastOrderPlacedDateTime(),'mm/dd/yyyy - hh:nn tt')#</p>
					</cfif> 
				</div> 
				
				<div class="col-md-2">
					<sw-order-template-upcoming-orders-card 
							data-order-template="#rc.orderTemplate.getEncodedJsonRepresentation()#"
						<cfif not isNull(rc.orderTemplate.getFrequencyTerm())>
							data-frequency-term="#rc.orderTemplate.getFrequencyTerm().getEncodedJsonRepresentation()#"
						</cfif>
							data-scheduled-order-dates="#rc.orderTemplate.getScheduledOrderDates(1)#">
					</sw-order-template-upcoming-orders-card>
				</div> 
				<cfset local.startDate = dateFormat(deserializeJson(decodeForHTML(rc.orderTemplate.getEncodedJsonRepresentation()))['scheduleOrderNextPlaceDateTime']) />
				<cfset local.endDate = dateFormat(dateAdd("yyyy", 1,deserializeJson(decodeForHTML(rc.orderTemplate.getEncodedJsonRepresentation()))['scheduleOrderNextPlaceDateTime'])) />
				<div class="col-md-2">
					<sw-order-template-update-schedule-modal data-schedule-order-next-place-date-time-string="#dateFormat(rc.orderTemplate.getScheduleOrderNextPlaceDateTime(), 'yyyy-mm-dd')#"
															data-order-template-schedule-date-change-reason-type-options="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(rc.orderTemplate.getOrderTemplateScheduleDateChangeReasonTypeOptions()))#"	
															data-order-template="#rc.orderTemplate.getEncodedJsonRepresentation()#"
															data-start-date-string="#local.startDate#"
															data-end-date-string="#local.endDate#"> 
					</sw-order-template-update-schedule-modal>
				</div> 
			<cfelse>
				<div class="col-md-2">
					<label class="control-label">#getHibachiScope().rbKey('entity.orderTemplate.createdDateTime')#</label>
					<p class="form-control-static">#DateFormat(rc.orderTemplate.getCreatedDateTime(),'mm/dd/yyyy')#</p>
				</div> 
			</cfif>

		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>

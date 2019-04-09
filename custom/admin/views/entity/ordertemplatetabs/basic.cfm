<cfimport prefix="swa" taglib="../../../../../tags" />
<cfimport prefix="hb" taglib="../../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.orderTemplate" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
		
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
				<p class="form-control-static">#rc.orderTemplate.getLastOrderPlacedDateTime()#</p>
			</div> 
			
			<div class="col-md-2">
				<sw-order-template-upcoming-orders-card 
					<cfif not isNull(rc.orderTemplate.getFrequencyTerm())>
						data-frequency-term="#rc.orderTemplate.getFrequencyTerm().getEncodedJsonRepresentation()#"
					</cfif>
						data-scheduled-order-dates="#rc.orderTemplate.getScheduledOrderDates(1)#">
				</sw-order-template-upcoming-orders-card>
			</div> 


			<div class="col-md-2">
				<sw-order-template-update-schedule-modal data-schedule-order-next-place-date-time-string="#dateFormat(rc.orderTemplate.getScheduleOrderNextPlaceDateTime(), 'yyyy-mm-dd')#"
														data-order-template="#rc.orderTemplate.getEncodedJsonRepresentation()#"
														data-end-day-of-the-month="25" 
														data-end-date-string="#dateFormat( dateAdd('d', now(), 90), 'yyyy-mm-dd')#">
				</sw-order-template-update-schedule-modal>
			</div> 


		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>

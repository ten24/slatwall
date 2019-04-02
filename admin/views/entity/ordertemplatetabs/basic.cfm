<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

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
				<sw-order-template-frequency-card 
					<cfif not isNull(rc.orderTemplate.getFrequencyTerm())>
						data-frequency-term="#rc.orderTemplate.getFrequencyTerm().getEncodedJsonRepresentation()#"
					</cfif>
				>
				</sw-order-template-frequency-card>
			</div> 
			<div class="col-md-2">

			</div> 
			<div class="col-md-2">

			</div> 
			<div class="col-md-2">

			</div> 
			<div class="col-md-2">

			</div> 


		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>

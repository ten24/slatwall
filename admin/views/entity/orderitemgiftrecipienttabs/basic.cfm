<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.edit" type="boolean" />
<cfparam name="rc.orderItemGiftRecipient" type="any" />

<cfoutput>
	<hb:HibachiPropertyList>
		<hb:HibachiPropertyRow>
           <hb:HibachiPropertyDisplay object="#rc.orderItemGiftRecipient#" property="firstName" edit="#rc.edit#" />
           <hb:HibachiPropertyDisplay object="#rc.orderItemGiftRecipient#" property="lastName" edit="#rc.edit#" />
           <hb:HibachiPropertyDisplay object="#rc.orderItemGiftRecipient#" property="emailAddress" edit="#rc.edit#" />
           <hb:HibachiPropertyDisplay object="#rc.orderItemGiftRecipient#" property="giftMessage" edit="#rc.edit#" />
           <hb:HibachiPropertyDisplay object="#rc.orderItemGiftRecipient#" property="quantity" edit="#rc.edit#" />
		</hb:HibachiPropertyRow>
	</hb:HibachiPropertyList>
</cfoutput>
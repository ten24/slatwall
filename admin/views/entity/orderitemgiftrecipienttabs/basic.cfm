<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.orderItemGiftRecipient" type="any" />

<cfoutput>
	<hb:HibachiPropertyList>
		<hb:HibachiPropertyRow>
           <hb:HibachiPropertyDisplay object="#rc.orderItemGiftRecipient#" property="firstName" />
           <hb:HibachiPropertyDisplay object="#rc.orderItemGiftRecipient#" property="lastName" />
           <hb:HibachiPropertyDisplay object="#rc.orderItemGiftRecipient#" property="emailAddress" />
           <hb:HibachiPropertyDisplay object="#rc.orderItemGiftRecipient#" property="giftMessage" />
           <hb:HibachiPropertyDisplay object="#rc.orderItemGiftRecipient#" property="quantity" />
		</hb:HibachiPropertyRow>
	</hb:HibachiPropertyList>
</cfoutput>
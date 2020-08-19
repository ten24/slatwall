<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />
<cfparam name="rc.integration" type="any">


   <hb:HibachiEntityActionBar type="detail" object="#rc.integration#" showcancel="false" showcreate="false" showedit="false" showdelete="false">
      <hb:HibachiProcessCaller entity="#rc.integration#" action="slatwallimporter:main.preprocessintegratoin" processContext="importcsv" type="list" modal="true" />
   </hb:HibachiEntityActionBar>

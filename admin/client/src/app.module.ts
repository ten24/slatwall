import {NgModule} from '@angular/core';
import {BrowserModule} from '@angular/platform-browser';
import {UpgradeModule} from '@angular/upgrade/static';
import {bootstrapper} from './bootstrap';
import {HeroDetailComponent} from './slatwall/components/herodetail.component';
import {slatwalladminmodule} from './slatwall/slatwalladmin.module';

import {AlertModule} from "../../../org/Hibachi/client/src/alert/alert.module";
import {CardModule} from "../../../org/Hibachi/client/src/card/card.module";
import {CollectionModule} from "../../../org/Hibachi/client/src/collection/collection.module";
import {CoreModule}  from  "../../../org/Hibachi/client/src/core/core.module";
import {DialogModule} from "../../../org/Hibachi/client/src/dialog/dialog.module";
import {EntityModule} from "../../../org/Hibachi/client/src/entity/entity.module";
import {FormModule} from "../../../org/Hibachi/client/src/form/form.module";
import {FrontendModule} from "../../../org/Hibachi/client/src/frontend/frontend.module";
import {HibachiModule} from "../../../org/Hibachi/client/src/hibachi/hibachi.module";
//import {ListingModule} from "../../../org/hibachi/client/src/listing/listing.module";
import {LoggerModule} from "../../../org/Hibachi/client/src/logger/logger.module";
import {PaginationModule} from "../../../org/Hibachi/client/src/pagination/pagination.module";
import {ValidationModule} from "../../../org/Hibachi/client/src/validation/validation.module";
import {WorkflowModule} from "../../../org/Hibachi/client/src/workflow/workflow.module";
import {ContentModule} from "./content/content.module";
import {FormBuilderModule} from "./formbuilder/formbuilder.module";
import {FulfillmentBatchDetailModule} from "./fulfillmentbatch/fulfillmentbatchdetail.module";
import {GiftCardModule} from "./giftcard/giftcard.module";
import {OptionGroupModule} from "./optiongroup/optiongroup.module";
import {OrderFulfillmentModule} from "./orderfulfillment/orderfulfillment.module";
import {OrderItemModule} from "./orderitem/orderitem.module";
import {ProductModule} from "./product/product.module"; 
import {ProductBundleModule} from "./productbundle/productbundle.module";
import {SkuModule} from "./sku/sku.module";
import {SlatwallAdminModule} from "./slatwall/slatwalladmin.module";

import { parseProvider,logProvider,filterProvider,timeoutProvider,qProvider } from "./ajs-upgraded-providers"; 


@NgModule({
  providers: [
    parseProvider,
    logProvider,
    filterProvider,
    timeoutProvider,
    qProvider
  ],
  imports: [
    BrowserModule,
    UpgradeModule,
    AlertModule,
    CardModule,
    CollectionModule,
    CoreModule,
    DialogModule,
    EntityModule,
    FormModule,
    FrontendModule,
    HibachiModule,
   // ListingModule,
    LoggerModule,
    PaginationModule,
    ValidationModule,
    WorkflowModule,
    ContentModule,
    FormBuilderModule,
    FulfillmentBatchDetailModule,
    GiftCardModule,
    OptionGroupModule,
    OrderFulfillmentModule,
    OrderItemModule,
    ProductModule,
    ProductBundleModule,
    SkuModule,
    SlatwallAdminModule
  ],
  declarations:[
      HeroDetailComponent
  ],
  entryComponents: [
    HeroDetailComponent
  ]
})
export class AppModule {
  constructor(private upgrade: UpgradeModule) { }
  ngDoBootstrap() {
     var bootstrapperInstance:any = new bootstrapper();
     bootstrapperInstance.fetchData().then(()=>{
         //console.log('test');
        this.upgrade.bootstrap(document.body,[slatwalladminmodule.name]);
        console.log(this.upgrade);
     });
  }
}
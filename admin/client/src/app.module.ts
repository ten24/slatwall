import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { UpgradeModule } from '@angular/upgrade/static';
import { bootstrapper } from './bootstrap';
import { HeroDetailComponent } from './slatwall/components/herodetail.component';
import { slatwalladminmodule } from './slatwall/slatwalladmin.module';
import {AlertModule} from "../../../org/Hibachi/client/src/alert/alert.module";
import {DialogModule} from "../../../org/Hibachi/client/src/dialog/dialog.module";
import { LoggerModule } from "../../../org/Hibachi/client/src/logger/logger.module";
import { CoreModule }  from  "../../../org/Hibachi/client/src/core/core.module";
import { CardModule } from "../../../org/Hibachi/client/src/card/card.module";
import { EntityModule } from "../../../org/Hibachi/client/src/entity/entity.module";
import { FormModule }   from "../../../org/Hibachi/client/src/form/form.module";
import { Pagination } from "../../../org/Hibachi/client/src/pagination/pagination.module";
import { ValidationModule } from "../../../org/Hibachi/client/src/validation/validation.module";
import { WorkflowModule } from "../../../org/Hibachi/client/src/workflow/workflow.module";
import {ContentModule} from "./content/content.module";
import {FormBuilderModule} from "./formbuilder/formbuilder.module";
import {OptionGroupModule} from "./optiongroup/optiongroup.module";
import {GiftCardModule} from "./giftcard/giftcard.module";
import {OrderItemModule} from "./orderitem/orderitem.module";
import {ProductModule} from "./product/product.module";
import { parseProvider,logProvider,filterProvider,timeoutProvider,qProvider,httpProvider,appConfigProvider,resourceBundlesProvider } from "./ajs-upgraded-providers"; 


@NgModule({
  providers: [
    parseProvider,
    logProvider,
    filterProvider,
    timeoutProvider,
    qProvider,
    httpProvider,
    appConfigProvider,
    resourceBundlesProvider
  ],
  imports: [
    BrowserModule,
    UpgradeModule,
    AlertModule,
    DialogModule,
    LoggerModule,
    CoreModule,
    CardModule,
    EntityModule,
    ContentModule,
    FormBuilderModule,
    OptionGroupModule,
    GiftCardModule,
    OrderItemModule,
    ProductModule,
    FormModule,
    Pagination,
    ValidationModule,
    WorkflowModule
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
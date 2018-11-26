import { Directive, Input, TemplateRef, ViewContainerRef } from '@angular/core';

@Directive({
  selector: '[swinit]'
})
export class SwInit {
        
    constructor(
        private templateRef: TemplateRef<any>,
        private viewContainer: ViewContainerRef
    ) { }

    @Input() set swinit(val: any) {
        this.viewContainer.clear();
        this.viewContainer.createEmbeddedView(this.templateRef, {swinit: val});
    }

}
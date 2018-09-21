/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import { Component, Input, OnInit } from "@angular/core";
@Component({
    selector: "sw-schedule-preview",
    templateUrl: "/slatwall/org/Hibachi/client/src/workflow/components/schedulepreview.html"
})
export class SWSchedulePreview implements OnInit {
    @Input() schedule;
    public scheduleKeys;

    constructor() {
     }
    ngOnInit() { 
        // scheduleKeys is used to store the keys in schedule object so that we can iterate through it in html
        this.scheduleKeys = Object.keys(this.schedule);
    }
}

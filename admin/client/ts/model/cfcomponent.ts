/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
module slatwalladmin{

    //model
    export class CFComponent {
        entityname:string;
        persistent:boolean;
        
        constructor(
            entityname:string,
            persistent:boolean
        ) { 
            this.entityname = entityname;
            this.persistent = persistent;   
        }
    }
}

/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
module slatwalladmin{

    //model
    export class CFProperty {
        name:string;
        ormtype:string;
        default:string;
        fieldtype:string;
        type:string;
        persistent:string;
        cfc:string
        fkcolumn:string
        
//        constructor(
//            msg: string,
//            type: string
//        ) { 
//            this.msg = msg;
//            this.type = type;   
//        }
    }
}

module slatwalladmin {
    'use strict';

    export class GiftRecipient {
        public firstName
        public lastName;
        public email;
        public giftMessage; 
        public quantity; 
        public account; 
        public editing; 
        
        constructor(
            firstName?: string,
            lastName?: string,
            email?: string, 
            giftMessage?: string,
            quantity?:number,
            account?:boolean, 
            editing?:boolean
        ) { 
            this.quantity = 1;
            this.editing = false; 
            this.account = false; 
        }
        
        public valid = () =>{
            if(this.firstName != null &&
               this.lastName != null &&
               this.email != null &&
               this.quantity != null
            ){
                return true;
            }
            return false;
        }
        
        public reset = () =>{
            this.firstName = null;
            this.lastName = null;
            this.email = null; 
            this.account = null;
            this.editing = false; 
            this.quantity = 1; 
        }
    }
}

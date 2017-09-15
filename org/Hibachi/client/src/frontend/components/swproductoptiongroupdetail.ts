/// <reference path='../../../typings/tsd.d.ts' />

class SWProductOptionGroupDetailController {
    
        public productId:string; 
        public productBundleGroupId:string; 

        public optionGroups=[]; 
        public skus=[];
        public childSkus:any[];

        public selectedSku:any; 

        public selectedOptionGroups={};
        public optionGroupChosen={}; 
        public optionGroupSortOrder={}; 
        public optionGroupLoading={}; 
        public allOptionGroups={}; 

        public allSelected=false; 
        public loading=true;
        public outOfStock=false;
        public touched=false; 
        public activeOptionGroupIndex=0; 

        public quantity=1; 
        public currencyCode;
        public imageSizePixels; 

        public orderByFilter; 

        public error=false; 
        public firstRequest=true; 

        public total = 0;

        public displaySkuCode:boolean;
        public lockInSelections:boolean;
        
        public itemNumber:string; 

        //@ngInject
        constructor(
            private collectionConfigService,
            private listingService, 
            private utilityService,
            private $rootScope,
            private $filter
        ){
            this.orderByFilter = this.$filter('orderBy');

            if(angular.isUndefined(this.displaySkuCode)){
                this.displaySkuCode = true;    
            }
            if(angular.isUndefined(this.imageSizePixels)){
                this.imageSizePixels = 60; 
            }
            if(angular.isUndefined(this.currencyCode)){
                this.currencyCode = "USD";
            }
            if(angular.isUndefined(this.lockInSelections)){
                this.lockInSelections = false; 
            }

            this.updateOptions(); 
        }

        private processResponse = (response) =>{ 
            
            if(response['skus'] != null && response['skus'].length){
                this.skus = response['skus']; 
                if(this.skus.length === 1){
                    this.selectedSku = this.skus[0]; 
                }
            } else if(this.allSelected) { 
                this.outOfStock = true; 
            }
            if(!response['skuOptionDetails'] || this.allSelected){
                return this.optionGroups;
            }

            var optionGroups = []; 

            if(this.firstRequest){
                this.allOptionGroups = response['skuOptionDetails'];
                this.firstRequest = false; 
            }

            for(var key in this.allOptionGroups){
                
                if(response['skuOptionDetails'][key] != null && this.selectedOptionGroups[response['skuOptionDetails'][key].optionGroupID] == null){
                    //option group was returned use it
                    var optionGroup = response['skuOptionDetails'][key]; 

                    if( optionGroup.options.length > 1 &&
                        (optionGroup.optionGroupImageGroupFlag == 'No ' || 
                        (optionGroup.optionGroupImageGroupFlag != null && optionGroup.optionGroupImageGroupFlag === false))
                    ){
                        optionGroup.options.unshift({optionID:'',optionName:'--Please Select ' + optionGroup['optionGroupName'],sortOrder:-1});
                    }

                } else {
                    //option group wasn't returned 
                    //if it was already selected leave the other options in there
                    var optionGroup = this.allOptionGroups[key]; 
                }

                this.optionGroupSortOrder[optionGroup.optionGroupID] = optionGroup.sortOrder; 
                this.optionGroupLoading[optionGroup.optionGroupID] = false; 

                if( optionGroup.options.length > 0 &&
                    this.selectedOptionGroups[optionGroup.optionGroupID] == null && 
                    (   optionGroup.optionGroupImageGroupFlag == 'No ' || 
                        (optionGroup.optionGroupImageGroupFlag != null && optionGroup.optionGroupImageGroupFlag === false)
                    )
                ){
                    this.selectedOptionGroups[optionGroup.optionGroupID] = optionGroup.options[0];
                }

                if( optionGroup.options.length === 1){
                    this.updateActiveOptionGroupIndex(optionGroup.optionGroupID);
                }

                optionGroups.unshift(optionGroup); 

            }

            return this.orderByFilter(optionGroups,"+sortOrder"); 
        }

        public reset = () =>{
            this.loading = true; 
            this.selectedOptionGroups={}; 
            this.optionGroupChosen={}; 
            this.activeOptionGroupIndex = 0;
            this.selectedSku = null; 
            this.skus=[]; 
            this.updateOptions();
        }

        //for images
        public selectOption = (option, optionGroupID) => {            
            this.selectedOptionGroups[optionGroupID] = option;

            this.updateActiveOptionGroupIndex(optionGroupID);

            this.updateOptions(optionGroupID); 
        }


        public updateActiveOptionGroupIndex = (optionGroupID?) =>{

            if(!this.optionGroupChosen[optionGroupID] && 
                this.activeOptionGroupIndex + 1 < this.optionGroups.length
            ){
                this.activeOptionGroupIndex++;
            } else if(this.activeOptionGroupIndex + 1 === this.optionGroups.length){
                this.allSelected = true;
            }
            
            this.optionGroupChosen[optionGroupID] = true;
        }

        //for select
        public updateOptions = (optionGroupID?) =>{


            if(optionGroupID){
                this.touched = true; 
                this.updateActiveOptionGroupIndex(optionGroupID);
            } else {
                this.optionGroupChosen[optionGroupID] = false;
                this.allSelected = false;
            }

            for(var key in this.optionGroupLoading){
                if( (optionGroupID && key != optionGroupID) && 
                    !this.optionGroupChosen[optionGroupID]
                ){
                    this.optionGroupLoading[key] = true;
                }
            }

            var selectedOptionsList = '';

            for(var key in this.selectedOptionGroups){
                if(this.optionGroupChosen[key] && this.selectedOptionGroups[key].optionID.length > 0){
                    selectedOptionsList = this.utilityService.listAppend(selectedOptionsList, this.selectedOptionGroups[key].optionID); 
                }
            }

            var queryString = '?productID=' + this.productId; 

            if(selectedOptionsList.length){
                queryString += '&selectedOptionIDList=' + selectedOptionsList; 
            }

            return this.$rootScope.slatwall.getProductSkuOptionDetails(queryString).then(
                (response)=>{
                    this.optionGroups = this.processResponse(response);
                    
                    if(this.optionGroups.length == 1 && this.optionGroups[0].options.length == 1){
                        this.allSelected = true; 
                    } 
                    this.loading = false;
                },
                (reason)=>{
                    this.loading = false;
                    this.error = true; 
                }
            );
        }

        public getTotal = () =>{
            this.total = this.selectedSku.price * this.quantity
            if(this.childSkus && this.childSkus.length){
                for(var i=0; i<this.childSkus.length; i++){
                    if(this.childSkus[i].selected){
                        this.total += (this.childSkus[i].price * this.quantity);
                    }
                }
            }
            return this.total; 
        }
        
    }
    
    class SWProductOptionGroupDetail implements ng.IDirective{
    
        public templateUrl; 
        public restrict = "EA";
        public scope = {};  
        
        public bindToController = {
            childSkus:"=?",
            productId:"@?",
            productBundleGroupId:"@?",
            currencyCode:"@?",
            imageSizePixels:"=?",
            displaySkuCode:"=?",
            itemNumber:"@?",
            lockInSelections:"=?"
        };
        
        public controller=SWProductOptionGroupDetailController;
        public controllerAs="swProductOptionGroupDetail";
        
        public static Factory():ng.IDirectiveFactory{
            var directive:ng.IDirectiveFactory = (
                hibachiPathBuilder
            ) => new SWProductOptionGroupDetail(
                hibachiPathBuilder
            );
            directive.$inject = [
                'hibachiPathBuilder'
            ];
            return directive;
        }
        
        //@ngInject
        constructor(
            private hibachiPathBuilder
        ){
            this.templateUrl = hibachiPathBuilder.buildPartialsPath("/frontend/components/productoptiongroupdetail.html");
        }
    
        public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
        }
    }
    
    export {
        SWProductOptionGroupDetailController,
        SWProductOptionGroupDetail
    };
    
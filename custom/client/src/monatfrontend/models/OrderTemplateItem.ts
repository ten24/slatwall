export interface OrderTemplateItem {
    calculatedCommissionableVolumeTotal: string;
    calculatedListPrice                : number;
    calculatedPersonalVolumeTotal      : string;
    calculatedProductPackVolumeTotal   : string;
    calculatedRetailCommissionTotal    : string;
    calculatedTaxableAmountTotal       : string;
    calculatedTotal                    : string;
    kitFlagCode                        : string;
    orderTemplate_currencyCode         : string;
    orderTemplateItemID                : string;
    quantity                           : number;
    sku_imagePath                      : string;
    sku_product_productName            : string;
    sku_skuCode                        : string;
    sku_skuDefinition                  : string;
    sku_skuID                          : string;
    skuProductURL                      : string;
    temporaryFlag                      : boolean;
    total                              : number;
}
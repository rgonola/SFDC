@isTest
public with sharing class IIT_TestClassForUassage{

    public static void insertCustomSetting(){
        list<Invoiceit_s__Configuration__c> objects = new list<Invoiceit_s__Configuration__c>();
        
        Invoiceit_s__Configuration__c c1 =  new Invoiceit_s__Configuration__c(Name = 'QUOTE_PAGE_3', invoiceit_s__String_Value__c = 'createquotestep3'); 
        Invoiceit_s__Configuration__c c2 =  new Invoiceit_s__Configuration__c(Name = 'QUOTE_PAGE_2', invoiceit_s__String_Value__c = 'createquotestep2'); 
        Invoiceit_s__Configuration__c c3 =  new Invoiceit_s__Configuration__c(Name = 'PRODUCT_OBJECTNAME', invoiceit_s__String_Value__c = 'invoiceit_s__Product__c', invoiceit_s__Description__c = 'The name of the object that has to be searched for ');
        Invoiceit_s__Configuration__c c4 =  new Invoiceit_s__Configuration__c(Name = 'NO_OF_DECIMALS_FOR_CURRENCY_VALUES', invoiceit_s__NUMBER_VALUE__C = 3, invoiceit_s__Field_Type__c = 'Number', invoiceit_s__Description__c = 'Define the number of decimals (precision) for all your currency values. Currency values will be rounded to the specified number of decimals',invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 15);
        Invoiceit_s__Configuration__c c5 =  new Invoiceit_s__Configuration__c(Name = 'CALCULATION_PRECISION', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Mention if you want to ROUND_UP or ROUND_DOWN the quote and order totals. If total is 46.70 ROUND_UP will make it 47 and ROUND_DOWN will make it 46. Leaving this blank will leave the total unchanged.',invoiceit_s__Picklist_Indicator__c ='listCalculatePrecision',invoiceit_s__Category__c ='Quote',invoiceit_s__Sequence__c = 3);
        Invoiceit_s__Configuration__c c6 =  new Invoiceit_s__Configuration__c(Name = 'PRODUCT_SEARCH_LIMIT', invoiceit_s__NUMBER_VALUE__C = 20, invoiceit_s__Field_Type__c = 'Number', invoiceit_s__Description__c = 'Define the maximum number of Invoice IT Product records that are returned in the instant product search results',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3',invoiceit_s__Sequence__c = 1);
        Invoiceit_s__Configuration__c c7 =  new Invoiceit_s__Configuration__c(Name = 'PRODUCT_ORDERFIELD', invoiceit_s__String_Value__c = 'Name', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the order in which the Invoice IT Product fields are displayed in the instant product search results',invoiceit_s__Picklist_Indicator__c ='listProductFields1',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3',invoiceit_s__Sequence__c = 2);
        Invoiceit_s__Configuration__c c8 =  new Invoiceit_s__Configuration__c(Name = 'TYPE_OF_PACKAGE', invoiceit_s__String_Value__c = 'STANDALONE');
        Invoiceit_s__Configuration__c c9 =  new Invoiceit_s__Configuration__c(Name = 'PRODUCT_DISPLAYFIELDS', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the Invoice IT Product fields that are displayed in the instant product search results',invoiceit_s__Picklist_Indicator__c ='listProductFields2',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3',invoiceit_s__Sequence__c = 3);
        Invoiceit_s__Configuration__c c10 = new Invoiceit_s__Configuration__c(Name = 'INVOICE_GROUP_CRITERIA', invoiceit_s__String_Value__c = 'ONE_INVOICE_PER_ORDER', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define whether you want the invoice scheduler to generate one invoice per order or to generate a consolidated invoice per account',invoiceit_s__Picklist_Indicator__c ='listInvoiceGeneration',invoiceit_s__Category__c ='Invoice',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 8);
        Invoiceit_s__Configuration__c c11 = new Invoiceit_s__Configuration__c(Name = 'ORDER_PAGE_3', invoiceit_s__String_Value__c = 'createjobstep3');
        Invoiceit_s__Configuration__c c12 = new Invoiceit_s__Configuration__c(Name = 'ORDER_STATUS_FOR_INVOICING', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the Order status that determines if the Order has to be picked up for invoicing',invoiceit_s__Picklist_Indicator__c ='listOrderStatusfields',invoiceit_s__Category__c ='Order',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 3);
        Invoiceit_s__Configuration__c c13 = new Invoiceit_s__Configuration__c(Name = 'DEFAULT_CURRENCY', invoiceit_s__String_Value__c = 'GBP', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Mention the ISO code of your default currency here. Say GBP',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3',invoiceit_s__Sequence__c = 4);
        Invoiceit_s__Configuration__c c14 = new Invoiceit_s__Configuration__c(Name = 'QUOTE_VALIDITY_PERIOD', invoiceit_s__NUMBER_VALUE__C = 15, invoiceit_s__Field_Type__c = 'Number', invoiceit_s__Description__c = 'The default number of days that a Quote is valid for after the date it is created',invoiceit_s__Category__c ='Quote',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 2);
        Invoiceit_s__Configuration__c c15 = new Invoiceit_s__Configuration__c(Name = 'ORDER_PAGE_2', invoiceit_s__String_Value__c = 'createjobstep2');
        Invoiceit_s__Configuration__c c16 = new Invoiceit_s__Configuration__c(Name = 'CHARGE_STATUS_FOR_INVOICING', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the Order Line status that determines if the Order Line has to be picked up for invoicing',invoiceit_s__Picklist_Indicator__c ='listORPCStatus',invoiceit_s__Category__c ='Order',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 4);
        Invoiceit_s__Configuration__c c17 = new Invoiceit_s__Configuration__c(Name = 'INVOICE_NO_OF_DAYS_TILL_DUE_DATE', invoiceit_s__NUMBER_VALUE__C = 15, invoiceit_s__Field_Type__c = 'Number', invoiceit_s__Description__c = 'The default number of days when an invoice is due from the invoice date',invoiceit_s__Category__c ='Invoice',invoiceit_s__Sequence__c = 1);
        Invoiceit_s__Configuration__c c18 = new Invoiceit_s__Configuration__c(Name = 'TAX_CALCULATION_BASED_ON', invoiceit_s__String_Value__c = 'Account Billing Address', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define whether the Tax and/or VAT is calculated based on the Shipping Contact Address, Billing Contact Address or the Account Billing Address',invoiceit_s__Picklist_Indicator__c ='listTaxCalculationBasedOn',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3',invoiceit_s__Sequence__c = 5);
        Invoiceit_s__Configuration__c c19 = new Invoiceit_s__Configuration__c(Name = 'USE_SERVICE_START_DATE_FOR_INVOICE', invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Align the Order service start date to Order date. Leave this un-checked if normally your Order service start dates are different to the order date', invoiceit_s__Boolean_Value__c = True,invoiceit_s__Category__c ='Order',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 5);
        Invoiceit_s__Configuration__c c20 = new Invoiceit_s__Configuration__c(Name = 'DISCOUNT_BY_VALUE_OR_PERCENTAGE', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Enable discounts by percentage(%) or by value', invoiceit_s__String_Value__c = 'APPLY_DISCOUNT_BY_PERCENTAGE',invoiceit_s__Picklist_Indicator__c ='listApplyDiscounts',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3',invoiceit_s__Sequence__c = 6);
        Invoiceit_s__Configuration__c c21 = new Invoiceit_s__Configuration__c(Name = 'AUTOMATE_PAYMENT_ALLOCATION', invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Should payments be allocated against pending invoices automatically', invoiceit_s__Boolean_Value__c = False,invoiceit_s__Category__c ='Invoice',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 9);
        Invoiceit_s__Configuration__c c22 = new Invoiceit_s__Configuration__c(Name = 'ORDER_DISCOUNT_CODE_FIELD', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the field on the Order object that stores the discount code', invoiceit_s__String_Value__c = 'Discount_Code__c',invoiceit_s__Picklist_Indicator__c ='listOrderFieldsForDiscountCode',invoiceit_s__Category__c ='Order',invoiceit_s__Sequence__c = 1);
        Invoiceit_s__Configuration__c c23 = new Invoiceit_s__Configuration__c(Name = 'QUOTE_DISCOUNT_CODE_FIELD', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the field on the Quote object that stores the discount code', invoiceit_s__String_Value__c = 'Discount_Code__c',invoiceit_s__Picklist_Indicator__c ='listQuoteFieldsForDiscountCode',invoiceit_s__Category__c ='Quote',invoiceit_s__Sequence__c = 4);
        Invoiceit_s__Configuration__c c24 = new Invoiceit_s__Configuration__c(Name = 'DEFAULT_PAYMENT_TERMS', invoiceit_s__Field_Type__c = 'String', invoiceit_s__String_Value__c = 'Due On Receipt', invoiceit_s__Description__c = 'Set the global payment terms value for Invoice IT',invoiceit_s__Picklist_Indicator__c ='listDefaultPaymentTerms',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3',invoiceit_s__Sequence__c = 7);
        Invoiceit_s__Configuration__c c25 = new Invoiceit_s__Configuration__c(Name = 'ALIGN_DATES_OF_ORDER_TO_PRODUCTS', invoiceit_s__Description__c = 'Align the service start dates of the order lines to the service start dates of the order', invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Boolean_Value__c = True,invoiceit_s__Category__c ='Order',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 6);
        Invoiceit_s__Configuration__c c26 = new Invoiceit_s__Configuration__c(Name = 'CAN_REFUND_CHARGES_DURING_ADJUSTMENTS', invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Define whether you want to provide a refund for services that are paid for but cancelled mid-term', invoiceit_s__Boolean_Value__c = False,invoiceit_s__Category__c ='Invoice',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 10);
        Invoiceit_s__Configuration__c c27 = new Invoiceit_s__Configuration__c(Name = 'DEFAULT_QUANTITY_IN_WIZARDS', invoiceit_s__Field_Type__c = 'Number', invoiceit_s__Description__c = 'Set the global default quantity of product line items if the default quantity value has not been specified in the product catalogue', invoiceit_s__NUMBER_VALUE__C = 1,invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 10);
        Invoiceit_s__Configuration__c c28 = new Invoiceit_s__Configuration__c(Name = 'IS_ORDER_FROM_CLOSED_WON_OPP', invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Automatically generate an Order when an Opportunity is set to Closed Won', invoiceit_s__Boolean_Value__c = True,invoiceit_s__Category__c ='Opportunity',invoiceit_s__Quick_Screen_Id__c ='5',invoiceit_s__Sequence__c = 4);
        Invoiceit_s__Configuration__c c29 = new Invoiceit_s__Configuration__c(Name = 'POPULATE_OPPORTUNITY_AMOUNT_FROM', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Which total field should automatically populate the Opportunity "Amount" field', invoiceit_s__String_Value__c = 'NETTOTAL',invoiceit_s__Picklist_Indicator__c ='listProductValueToRollUp',invoiceit_s__Category__c ='Opportunity',invoiceit_s__Quick_Screen_Id__c ='5',invoiceit_s__Sequence__c = 5);
        Invoiceit_s__Configuration__c c30 = new Invoiceit_s__Configuration__c(Name = 'OPPLINE_STATUS_FOR_ORDER_CONVERSION', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the status of the Opportunity line items that determines whether they should be selected for auto-conversion into an Order', invoiceit_s__String_Value__c ='Active',invoiceit_s__Picklist_Indicator__c ='listOpportunityCharges1',invoiceit_s__Category__c ='Opportunity',invoiceit_s__Quick_Screen_Id__c ='5',invoiceit_s__Sequence__c = 2);
        Invoiceit_s__Configuration__c c31 = new Invoiceit_s__Configuration__c(Name = 'OPPLINE_STATUS_AFTER_ORDER_CONVERSION', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'What should be the status of opportunity lines after they are automatically converted to order lines', invoiceit_s__String_Value__c ='Converted',invoiceit_s__Picklist_Indicator__c ='listOpportunityCharges',invoiceit_s__Category__c ='Opportunity',invoiceit_s__Quick_Screen_Id__c ='5',invoiceit_s__Sequence__c = 1);  
        Invoiceit_s__Configuration__c c32 = new Invoiceit_s__Configuration__c(Name = 'QUOTE_LEGAL_ENTITY_FIELD_NAME', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'The field on the Quote object where the legal entity information is stored. This will override the Account legal entity setting',invoiceit_s__Picklist_Indicator__c ='listQuoteFields',invoiceit_s__Category__c ='Quote',invoiceit_s__Sequence__c = 4);
        Invoiceit_s__Configuration__c c33 = new Invoiceit_s__Configuration__c(Name = 'ORDER_LEGAL_ENTITY_FIELD_NAME', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'The field on the Order object where the legal entity information is stored. This will override the Account legal entity setting',invoiceit_s__Picklist_Indicator__c ='listOrderFields',invoiceit_s__Category__c ='Order',invoiceit_s__Sequence__c = 2);
        Invoiceit_s__Configuration__c c34 = new Invoiceit_s__Configuration__c(Name = 'ACCOUNT_LEGAL_ENTITY_FIELD_NAME', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'The field on the Account object where the legal entity information is stored',invoiceit_s__Picklist_Indicator__c ='listAccountFields',invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 11);
        Invoiceit_s__Configuration__c c35 = new Invoiceit_s__Configuration__c(Name = 'SAVE_CREDIT_CARD_ON_PAYMENT_PAGE', invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Define whether customers are prompted to save their Credit Card information on the payment page',invoiceit_s__Category__c ='Invoice',invoiceit_s__Sequence__c = 3);
        Invoiceit_s__Configuration__c C36 = new Invoiceit_s__Configuration__c(Name = 'INVOICE_RUN_BATCH_SIZE', invoiceit_s__Field_Type__c = 'Number', invoiceit_s__Description__c = 'How many records should be processed in each batch during an invoice scheduler run', invoiceit_s__NUMBER_VALUE__C = 10,invoiceit_s__Category__c ='Invoice',invoiceit_s__Sequence__c = 4);
        Invoiceit_s__Configuration__c c37 = new Invoiceit_s__Configuration__c(Name = 'BILL_ONETIME_CHARGES_BASED_ON_DATES', invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Define whether one-time charges are only billed on or after the service start date. This means that one-time charges will not be billed prior to the service start date', invoiceit_s__Boolean_Value__c = false,invoiceit_s__Category__c ='Invoice',invoiceit_s__Sequence__c = 5);
        Invoiceit_s__Configuration__c c38 = new Invoiceit_s__Configuration__c(Name = 'CLONEED_OPPORTUNITY_STAGE', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the default opportunity stage when an Opportunity is cloned',invoiceit_s__Picklist_Indicator__c ='listOpportunityStage',invoiceit_s__Category__c ='Opportunity',invoiceit_s__Quick_Screen_Id__c ='5',invoiceit_s__Sequence__c = 6);
        Invoiceit_s__Configuration__c c39 = new Invoiceit_s__Configuration__c(Name = 'INVOICE_TO_BE_CHARGED_ON', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define whether the Payment Scheduler should pickup unpaid invoices on or after the invoice date or on or after the invoice due date', invoiceit_s__String_Value__c = 'Due Date',invoiceit_s__Picklist_Indicator__c ='listPaymentSchedulerDates',invoiceit_s__Category__c ='Invoice',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 11);
        Invoiceit_s__Configuration__c c40 = new Invoiceit_s__Configuration__c(Name = 'DEFAULT_PAYMENT_TERMS_TO_BE_USED_FROM', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define whether the global payment terms should be overridden by the payment terms on Account or at the Order level', invoiceit_s__String_Value__c = 'ACCOUNT',invoiceit_s__Picklist_Indicator__c ='listPaymentTerms',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3',invoiceit_s__Sequence__c = 8);
        Invoiceit_s__Configuration__c c42 = new Invoiceit_s__Configuration__c(Name = 'AUTOMATIC_ALLOCATEDTOFUTURE_INVOICES', invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Allow over payments to be automatically allocated to new invoices', invoiceit_s__Boolean_Value__c = false,invoiceit_s__Category__c ='Invoice',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 12);
        Invoiceit_s__Configuration__c c43 = new Invoiceit_s__Configuration__c(Name = 'MANUAL_INVOICE_GENERATION_STATUS', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the default invoice status when an invoice is generated manually', invoiceit_s__String_Value__c = 'Draft',invoiceit_s__Picklist_Indicator__c ='listInvoiceStatus',invoiceit_s__Category__c ='Invoice',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 13);
        Invoiceit_s__Configuration__c c44 = new Invoiceit_s__Configuration__c(Name = 'NAVIGATION_FOR_PRODUCTRATEPLAN', invoiceit_s__Field_Type__c = 'Number', invoiceit_s__Description__c = 'Define the default number of Rate Plans that should be displayed on the Invoice IT Product page', invoiceit_s__NUMBER_VALUE__C = 40,invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 12);
        Invoiceit_s__Configuration__c c45 = new Invoiceit_s__Configuration__c(Name = 'NAVIGATION_FOR_PRODUCTCHARGE', invoiceit_s__Field_Type__c = 'Number', invoiceit_s__Description__c = 'Define the default number of Rate Plan Charges that should be displayed on the Invoice IT Product page', invoiceit_s__NUMBER_VALUE__C = 40,invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 13);
        Invoiceit_s__Configuration__c c46 = new Invoiceit_s__Configuration__c(Name = 'CHARGENAME_TEXTBOX_WIDTH', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Enter the width for the Charge Name text box while creating order and quote and opportunity Products ex :- width:200px', invoiceit_s__String_Value__c = 'width:150px',invoiceit_s__Picklist_Indicator__c ='listChargeNameWidth',invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 14);
        Invoiceit_s__Configuration__c c47 = new Invoiceit_s__Configuration__c(Name = 'PRODUCTNAME_TEXTBOX_WIDTH', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Enter the width for the Product Name text box while creating order and quote and opportunity Products ex :- width:200px', invoiceit_s__String_Value__c = 'width:150px',invoiceit_s__Picklist_Indicator__c ='listProductNameWidth',invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 15);
        Invoiceit_s__Configuration__c c48 = new Invoiceit_s__Configuration__c(Name = 'INVOICEIT_HOME_POPUP' ,invoiceit_s__Boolean_Value__c = false, invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'This is for Invoice IT home Pop up');
        Invoiceit_s__Configuration__c c49 = new Invoiceit_s__Configuration__c(Name = 'DISPLAY_PRODUCT_CHARGE_POP_UP' ,invoiceit_s__Boolean_Value__c = false, invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Enhanced advance Product Charge selection in the wizards',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3',invoiceit_s__Sequence__c = 16);
        Invoiceit_s__Configuration__c c50 = new Invoiceit_s__Configuration__c(Name = 'DISPLAY_PRODUCT_RELATED_LIST' ,invoiceit_s__Boolean_Value__c = false, invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'This is for displaying product realted list(New Product Page)');
        Invoiceit_s__Configuration__c c51 = new Invoiceit_s__Configuration__c(Name = 'DISPLAY_PRODUCT_BUNDLES_SEARCH' ,invoiceit_s__Boolean_Value__c = false, invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Define the product bundle search on step wizard pages',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3');
        Invoiceit_s__Configuration__c c52 = new Invoiceit_s__Configuration__c(Name = 'PRODUCTBUNDLE_SEARCHFIELDS' ,invoiceit_s__String_Value__c = 'Name', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the Product Bundle fields that can be searched for in the instant product bundle search',invoiceit_s__Picklist_Indicator__c ='listProductBundleFields',invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 21);
        Invoiceit_s__Configuration__c c53 = new Invoiceit_s__Configuration__c(Name = 'PRODUCTBUNDLE_ORDERFIELD', invoiceit_s__String_Value__c = 'Name', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the order in which the Product Bundle fields are displayed in the instant product bundle search results',invoiceit_s__Picklist_Indicator__c ='listProductBundleFields2',invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 22);
        Invoiceit_s__Configuration__c c54 = new Invoiceit_s__Configuration__c(Name = 'PRODUCTBUNDLE_DISPLAYFIELDS', invoiceit_s__String_Value__c = '', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the Product Bundle fields that are displayed in the instant product bundle search results',invoiceit_s__Picklist_Indicator__c ='listProductBundleFields1',invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 20);
        Invoiceit_s__Configuration__c c55 = new Invoiceit_s__Configuration__c(Name = 'ENABLE_STATE_AND_COUNTRY_PICKLIST' ,invoiceit_s__Boolean_Value__c = false, invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Define the state and country picklist in Site Page and Virtual Terminal',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3');
        Invoiceit_s__Configuration__c c56 = new Invoiceit_s__Configuration__c(Name = 'NO_OF_DAYS_FOR_AUTO_RENEWAL' ,invoiceit_s__Field_Type__c = 'Number', invoiceit_s__Description__c = 'Number of days before Order Expires',invoiceit_s__Category__c ='Order',invoiceit_s__Sequence__c = 8, invoiceit_s__NUMBER_VALUE__C = 30);
        Invoiceit_s__Configuration__c c57 = new Invoiceit_s__Configuration__c(Name = 'INVOICEIT_BATCH_JOBS_TO_PROCESS', invoiceit_s__String_Value__c = '', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the batches for processing',invoiceit_s__Picklist_Indicator__c ='listBatchJobs',invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 23);
        
                
        Invoiceit_s__Configuration__c c58 = new Invoiceit_s__Configuration__c(Name = 'EXCHANGERATE_ACCESSTOKEN', invoiceit_s__Field_Type__c = 'String',invoiceit_s__String_Value__c = 'kicbus');
        Invoiceit_s__Configuration__c c59 = new Invoiceit_s__Configuration__c(Name = 'ADVANCED_BILLING_RULE', invoiceit_s__Field_Type__c = 'String',invoiceit_s__String_Value__c = 'BILLINGCONTACT_ACCOUNT' );
        Invoiceit_s__Configuration__c c60 = new Invoiceit_s__Configuration__c(Name = 'EXCHANGERATE_ENDPOINTURL', invoiceit_s__Field_Type__c = 'String',invoiceit_s__String_Value__c = 'https://test-xlr-currencies.eu.cloudhub.io/api/exchangerate/xlr/');
        Invoiceit_s__Configuration__c c65 =  new Invoiceit_s__Configuration__c(Name = 'MANNA_UNIT_PRICE', invoiceit_s__NUMBER_VALUE__C = 30, invoiceit_s__Field_Type__c = 'Number', invoiceit_s__Description__c = 'This will hold the value of (Cost/Unit Pre Buffer + Buffer Amount) for Manna Charges',invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 75);
        
        objects.add((Invoiceit_s__Configuration__c) c65);
        objects.add((Invoiceit_s__Configuration__c) c58);
        objects.add((Invoiceit_s__Configuration__c) c59);
        objects.add((Invoiceit_s__Configuration__c) c60);
        objects.add((Invoiceit_s__Configuration__c) c1);
        objects.add((Invoiceit_s__Configuration__c) c2);
        objects.add((Invoiceit_s__Configuration__c) c3);
        objects.add((Invoiceit_s__Configuration__c) c4);
        objects.add((Invoiceit_s__Configuration__c) c5);
        objects.add((Invoiceit_s__Configuration__c) c6);
        objects.add((Invoiceit_s__Configuration__c) c7);
        objects.add((Invoiceit_s__Configuration__c) c8);
        objects.add((Invoiceit_s__Configuration__c) c9);
        objects.add((Invoiceit_s__Configuration__c) c10);
        objects.add((Invoiceit_s__Configuration__c) c11);
        objects.add((Invoiceit_s__Configuration__c) c12);
        objects.add((Invoiceit_s__Configuration__c) c13);
        objects.add((Invoiceit_s__Configuration__c) c14);
        objects.add((Invoiceit_s__Configuration__c) c15);
        objects.add((Invoiceit_s__Configuration__c) c16);
        objects.add((Invoiceit_s__Configuration__c) c17);
        objects.add((Invoiceit_s__Configuration__c) c18);
        objects.add((Invoiceit_s__Configuration__c) c19);
        objects.add((Invoiceit_s__Configuration__c) c20);
        objects.add((Invoiceit_s__Configuration__c) c21);
        objects.add((Invoiceit_s__Configuration__c) c22);
        objects.add((Invoiceit_s__Configuration__c) c23);
        objects.add((Invoiceit_s__Configuration__c) c24);
        objects.add((Invoiceit_s__Configuration__c) c25);
        objects.add((Invoiceit_s__Configuration__c) c26);
        objects.add((Invoiceit_s__Configuration__c) c27);
        objects.add((Invoiceit_s__Configuration__c) c28);
        objects.add((Invoiceit_s__Configuration__c) c29);
        objects.add((Invoiceit_s__Configuration__c) c30);
        objects.add((Invoiceit_s__Configuration__c) c31);
        objects.add((Invoiceit_s__Configuration__c) c32);
        objects.add((Invoiceit_s__Configuration__c) c33);
        objects.add((Invoiceit_s__Configuration__c) c34);
        objects.add((Invoiceit_s__Configuration__c) c35);
        objects.add((Invoiceit_s__Configuration__c) c36);
        objects.add((Invoiceit_s__Configuration__c) c37);
        objects.add((Invoiceit_s__Configuration__c) c38);
        objects.add((Invoiceit_s__Configuration__c) c39);
        objects.add((Invoiceit_s__Configuration__c) c40);
        objects.add((Invoiceit_s__Configuration__c) c42);
        objects.add((Invoiceit_s__Configuration__c) c43);
        objects.add((Invoiceit_s__Configuration__c) c44);
        objects.add((Invoiceit_s__Configuration__c) c45);
        objects.add((Invoiceit_s__Configuration__c) c46);
        objects.add((Invoiceit_s__Configuration__c) c47);
        objects.add((Invoiceit_s__Configuration__c) c48);
        objects.add((Invoiceit_s__Configuration__c) c49);
        objects.add((Invoiceit_s__Configuration__c) c50);
        objects.add((Invoiceit_s__Configuration__c) c51);
        objects.add((Invoiceit_s__Configuration__c) c52);
        objects.add((Invoiceit_s__Configuration__c) c53);
        objects.add((Invoiceit_s__Configuration__c) c54);
        objects.add((Invoiceit_s__Configuration__c) c55);
        objects.add((Invoiceit_s__Configuration__c) c56);
        objects.add((Invoiceit_s__Configuration__c) c57);
        Invoiceit_s__Configuration__c invoiceEmailTemplate = new Invoiceit_s__Configuration__c(Name = 'INVOICE_EMAIL_TEMPLATE', invoiceit_s__String_Value__c = 'Enter Template Id', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'The Salesforce Id of the Invoice Email template that is used when sending an Invoice via email',invoiceit_s__Picklist_Indicator__c ='listInvoiceTemplate',invoiceit_s__Category__c ='Invoice',invoiceit_s__Sequence__c = 5);
        Invoiceit_s__Configuration__c quoteEmailTemplate = new Invoiceit_s__Configuration__c(Name = 'QUOTE_EMAIL_TEMPLATE', invoiceit_s__String_Value__c = 'Enter Template Id', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'The Salesforce Id of the Quote Email template that is used when sending a Quote via email',invoiceit_s__Picklist_Indicator__c ='listQuoteEmailTemplate',invoiceit_s__Category__c ='Quote',invoiceit_s__Sequence__c = 5);
        objects.add(quoteEmailTemplate);
        objects.add(invoiceEmailTemplate);

        Invoiceit_s__Configuration__c companyLogo = new Invoiceit_s__Configuration__c(Name = 'COMPANY_LOGO' ,invoiceit_s__String_Value__c = 'https://c.na12.content.force.com/servlet/servlet.ImageServer?id=015U00000000fGG&oid=00DU0000000HSiW', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Default image for Visualforce Quote and Invoice templates',invoiceit_s__Picklist_Indicator__c ='listCompanyLogo',invoiceit_s__Category__c ='Quote',invoiceit_s__Sequence__c = 6);                                                                 
        objects.add(companyLogo);
        objects.add(new Invoiceit_s__Configuration__c(Name = 'PRODUCT_SEARCHFIELDS' ,invoiceit_s__String_Value__c = 'Name,invoiceit_s__Product_Code__c', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the Invoice IT Product fields that can be searched for in the instant product search',invoiceit_s__Picklist_Indicator__c ='listProductFields',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3',invoiceit_s__Sequence__c = 9));
        objects.add(new Invoiceit_s__Configuration__c(Name = 'SUPPORT_PAGE_URL' ,invoiceit_s__String_Value__c = 'http://www.weinvoiceit.com/support/'));
        objects.add(new Invoiceit_s__Configuration__c(Name = 'ORDER_STATUS_VALUES_TO_ROLLUP', invoiceit_s__String_Value__c = 'In Progress,Ready to be Invoiced,Invoiced', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the Order status values for which the total values are rolled up to the account/opportunity',invoiceit_s__Picklist_Indicator__c ='listOrderStatusfields1',invoiceit_s__Category__c ='Order',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 7));
        objects.add(new Invoiceit_s__Configuration__c(Name = 'QUOTE_STATUS_VALUES_TO_ROLLUP', invoiceit_s__String_Value__c = 'Active,Converted', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the Quote status values for which the total values are rolled up to the account/opportunity',invoiceit_s__Picklist_Indicator__c ='listQuoteStatusfields1',invoiceit_s__Category__c ='Quote',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 1));
        objects.add(new Invoiceit_s__Configuration__c(Name = 'UPDATE_AMOUNT_FIELD_IN_OPPORTUNITY', invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Define whether the Amount field on opportunities should be updated with the total quote value',invoiceit_s__Category__c ='Opportunity',invoiceit_s__Quick_Screen_Id__c ='5',invoiceit_s__Sequence__c = 3));
        
        
        
        
        Invoiceit_s__Configuration__c c1n =  new Invoiceit_s__Configuration__c(Name = 'PID_last', invoiceit_s__Number_Value__c= 1000); 
         objects.add((Invoiceit_s__Configuration__c) c1n);
         
         Invoiceit_s__Configuration__c c2n =  new Invoiceit_s__Configuration__c(Name = 'CID_last', invoiceit_s__Number_Value__c= 1000); 
         objects.add((Invoiceit_s__Configuration__c) c2n);
        
        insert objects;
    
    }
    static testMethod void InsertingUsage() {
    
    //Insert Custom setting 
    
        insertCustomSetting();
        //Insert product 
        Product2 prod = new Product2();
        prod.Name = 'EFile Fee';
        prod.Family = 'Hardware';
        prod.ProductCode = '2016EFILEFEE';
        prod.IsActive=true;
        insert prod;
        Product_Fulfillment_Step__c pfull = new Product_Fulfillment_Step__c();
        pfull.Name = 'Taest';
        pfull.Actionss__c = 'Create Task';
        pfull.Product__c= prod.id;
        insert pfull; 
        Product2 prod1 = new Product2();
        prod1.Name = 'ATX-KR CCHBK REV';
        prod1.Family = 'Hardware';
        prod1.ProductCode = 'ATX-KR CCHBK REV';
        prod1.IsActive=true;
        insert prod1;
        
        //Insert PriceBook
        Pricebook2 priceBook= new Pricebook2();
        priceBook.Name='Custom Pricebook';
        priceBook.isActive=true ;
        insert priceBook;
        EmailTemplate et=[SELECT Body,name, subject,HtmlValue FROM EmailTemplate where name='IIT_RegCodeTemplate'];
        //Insert PriceBook Entry
        PricebookEntry priceBookEtry= new PricebookEntry();
        priceBookEtry.Pricebook2Id = priceBook.Id;
        priceBookEtry.Product2Id = prod.Id;
        priceBookEtry.UnitPrice = 12000; 
        priceBookEtry.IsActive = true;
        insert priceBookEtry;
        
        //Account insert
        Account account = new Account(Name = 'India');
        insert account;
       // EmailTemplate etemplate = new EmailTemplate();
        //etemplate.
        //Contact Insert 
        Contact cont = new Contact();
        cont.AccountId = account.id;
        cont.Email = 'test@gmail.com';
        cont.FirstName = 'InvoiceIT';
        cont.LastName =  'Test';
        cont.Is_Primary__c = true;
        insert cont;
        
        //insert Opportunity 
        Opportunity opp = new Opportunity();
        opp.AccountId = account.id;
        opp.CloseDate = System.today();
        opp.StageName = 'Validation';
        opp.Name = 'Opportunity Test';
        opp.ForecastCategoryName = 'Medium Probability';
        opp.Product__c = 'ATX';
        insert opp;    
         
      
            invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'USD',invoiceit_s__Symbol__c = '$');
            
            insert currency1;
            
             SBQQ__Quote__c cpqQuote = new SBQQ__Quote__c();
        cpqQuote.SBQQ__Account__c = account.id;
        cpqQuote.SBQQ__Opportunity2__c = opp.id;
        cpqQuote.SBQQ__Status__c = 'Draft';
        cpqQuote.SBQQ__PrimaryContact__c =cont.id;
        cpqQuote.SBQQ__Type__c = 'Quote';
        cpqQuote.SBQQ__StartDate__c = System.today();
        cpqQuote.SBQQ__PriceBook__c = priceBook.id;
        cpqQuote.SBQQ__Primary__c = true;
        insert cpqQuote;
        
        //Insert QuoteLine
        SBQQ__QuoteLine__c cpqQuoteLine =  new SBQQ__QuoteLine__c();
        
        cpqQuoteLine.SBQQ__Quote__c = cpqQuote.id;
        cpqQuoteLine.SBQQ__Product__c= prod.id;
        cpqQuoteLine.SBQQ__Quantity__c = 1;
        cpqQuoteLine.SBQQ__ListPrice__c = 100;
        cpqQuoteLine.SBQQ__CustomerPrice__c = 100;
        cpqQuoteLine.SBQQ__NetPrice__c = 100;
        cpqQuoteLine.Free_EFiles__c =  121;
        
        insert cpqQuoteLine;
            
            invoiceit_s__Job__c job = new invoiceit_s__Job__c(invoiceit_s__Account__c = account.id,QTC__Opportunity__c = opp.id,invoiceit_s__Status__c = 'Draft',invoiceit_s__Billing_Contact__c = cont.Id,invoiceit_s__Shipping_Contact__c = cont.Id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id);
             insert job;
             invoiceit_s__Job_Product__c  jobProduct= new invoiceit_s__Job_Product__c(Name = 'jobProduct',invoiceit_s__Job__c = job.Id,invoiceit_s__Product_Code__c = '2016EFILEFEE');
             insert jobProduct;

             invoiceit_s__Job_Rate_Plan__c jobRP = new invoiceit_s__Job_Rate_Plan__c(Name = 'JobRP',invoiceit_s__Job_Product__c =jobProduct.Id);
             insert jobRP;

             invoiceit_s__Job_Rate_Plan_Charge__c charge = new invoiceit_s__Job_Rate_Plan_Charge__c(Name = 'jobRPC',invoiceit_s__Job_Rate_Plan__c =jobRP.Id,invoiceit_s__Status__c='Draft',invoiceit_s__Quantity__c = 12,invoiceit_s__Price_Type__c = 'Monthly',invoiceit_s__Accounting_Code__c = '12345',invoiceit_s__Unit_Price__c = 12);
             insert charge;
             invoiceit_s__Job_Rate_Plan_Charge__c charge1 = new invoiceit_s__Job_Rate_Plan_Charge__c(Name = 'jobRPC',invoiceit_s__Service_Activation_Date__c = system.TODAY(),invoiceit_s__Service_End_Date__c=system.TODAY().addMonths(4),invoiceit_s__Job_Rate_Plan__c =jobRP.Id,invoiceit_s__Status__c='Draft',invoiceit_s__Quantity__c = 12,invoiceit_s__Price_Type__c = 'Usage',Free_EFiles__c  =5454,invoiceit_s__Accounting_Code__c = '12345',invoiceit_s__Unit_Price__c = 12,QTC__Quote_Line__c = cpqQuoteLine.id);
             insert charge1;
             invoiceit_s__Job_Rate_Plan_Charge__c charge2 = new invoiceit_s__Job_Rate_Plan_Charge__c(Name = 'jobRPC',invoiceit_s__Next_Charge_Date__c = system.TODAY(),invoiceit_s__Service_End_Date__c=system.TODAY().addMonths(4),invoiceit_s__Job_Rate_Plan__c =jobRP.Id,invoiceit_s__Status__c='Draft',invoiceit_s__Quantity__c = 12,invoiceit_s__Price_Type__c ='OneTime',invoiceit_s__Accounting_Code__c = '12345',invoiceit_s__Unit_Price__c = 12);
             insert charge2;
             set<id> orderIds = new set<id>();
             orderIds.add(job.id);
             try{
                 IIT_CreateOrderchargefulfillment fullfillment  = new IIT_CreateOrderchargefulfillment();
                 fullfillment.createOrderfulfilment(orderIds);
             }catch(Exception ex){
             
             }
            invoiceit_s__Usage_Charge__c usage = new invoiceit_s__Usage_Charge__c();
            usage.invoiceit_s__Order_Rate_Plan_Charge__c = charge1.id;
            usage.invoiceit_s__Order__c = job.id;
            usage.Amount__c = 200;
            usage.invoiceit_s__End_Date__c = System.today().addDays(6);
            usage.invoiceit_s__Start_Date__c = System.today();
            usage.SKU_Code__c = '2016EFILEFEE'; 
            usage.invoiceit_s__Quantity__c = 12;
            usage.invoiceit_s__Status__c = 'Un-billed';
            usage.Original_Quantity__c = 12;
            insert usage;
            charge1.Reg_Code__c = 'nav12345';
            charge1.Reg_Code_Email_Status__c = 'Send Reg Code';
            update charge1;
            
            try {
            invoiceit_s__Usage_Charge__c usage1 = new invoiceit_s__Usage_Charge__c();
            //usage.invoiceit_s__Order_Rate_Plan_Charge__c = charge1.id;
            usage1.invoiceit_s__Order__c = job.id;
            usage1.Amount__c = 200;
            usage1.invoiceit_s__End_Date__c = System.today().addDays(6);
            usage1.invoiceit_s__Start_Date__c = System.today();
            usage1.SKU_Code__c = 'ATX-KR CCHBK REV'; 
            usage1.invoiceit_s__Quantity__c = 12;
            usage1.Original_Quantity__c = 12;
            insert usage1;
            } catch(exception ex) {
            
            }
            
            
    }
}
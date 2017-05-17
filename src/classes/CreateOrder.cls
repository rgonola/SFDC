global  class CreateOrder{
   
    public Staging Staging;
    
   global  class Staging {
        public DataControl DataControl;
        public Sfdc Sfdc;
        public Customer Customer;
        public Contacts[] Contacts;
        public Order Order;
        public Products[] Products;
        public Fees[] Fees;
        
    }
    
    global class DataControl{
        public String Event_ID;
        public String Sent_At;
        public String Event_Source;
     }
    
    global class Sfdc {
        public String SF_Account_ID;    //7421587
        public String SF_Invoice_ID;    //965874
        public String SF_Opportunity_ID;    //213654
        public String SF_Order_ID;  //321456
        public String SF_Quote_ID; 
        public String SF_CreateNote_ID;
       
    }
    global class Customer {
        public String PID;  //9
        public String ClientID; //63254
        public String Office;   //0
        public String Brand_Type;   //TW
        public String First_Name;   //Dilan
        public String Last_Name;    //Viloria
        public String Company;  //CCH
        public String Email;    //dilan@cchsfs.com
        public String Territory;
    }
    global class Contacts {
        public String Cnt_Type; //Shipping
        public String Phone;    //678-125-9658
        public String Fax;  //678-741-9222
        public String Mobile;   //678-741-9223
        public String Email;    //myshipping@cchsfs.com
        public String Addr1;    //2025 Barrett Pkwy
        public String Addr2;    //Apt 2145
        public String City; //Kennesaw
        public String State;    //GA
        public String Zip;  //30144-4785
        public String Country;  //USA
    }
    global class Order {
        public String STX_Invoice_Number;   //321456
        public String STX_Invoice_Sent; //6523874
        public String Description;  //Initial Order
        public String Addl_SLS_CD;  //02
        public String QuoteNum; //9863274
        public String QuoteType;    //Regular
        public String STX_Order_Number; //369852
        public Datetime STX_Order_Sent;   //21457
        public String SLS_CD;   //01
        public String STOL_Total_Tax;   //10.52
        public String Payment_Type; //CC
        public String Ord_Val;  //978.00
        public String Total_Shipping;   //10.00
        public String Ord_Source;   //WEB
        public String Web_Source;   //CART
        public String Train_Email;  //mytraining@cchsfs.com
        public String OrderType;    //Regular
    }
    global class Products {
        public String LineSequence; //1
        public String ItemID;   //ATX-1040
        public String ItemDescription;  //ATX 1040 Package
        public String Quantity; //1
        public String ProductStatus;  //IRSPUB
        public String PriceList;    //850.00
        public String PriceNet; //850.00
        public String PriceExtended;    //850.00
        public String Revision_Number;  //2016
        public String STOL_Tax; //10.52
        public String Sub_Start_Date;   //01-01-2016
        public String Sub_End_Date; //12-31-2016
        public String TRT_ID;   //874524587
        public String Up_Down_Grade;    //N
        public String Taxable;  //Y
        public String ItemClass;    //TRG
        public String CreditNoteNumber;
        public Assemblies[] Assemblies;
    }
    
    global class Fees {
        public String ItemID;   //ATX-1040
        public String Revision_Number;  //2016
        public String TimeStamp;  //2016
       
       /* public String LineSequence; //1
        public String ItemDescription;  //ATX 1040 Package
        public String Quantity; //1
        public String PriceList;    //850.00
        public String PriceNet; //850.00
        public String PriceExtended;    //850.00
        
        public String STOL_Tax; //10.52
        public String Sub_Start_Date;   //01-01-2016
        public String Sub_End_Date; //12-31-2016
        public String TRT_ID;   //874524587
        public String Up_Down_Grade;    //N
        public String Taxable;  //Y
        public String ItemClass;    //TRG*/
        public Tiers[] Tiers;
    }
    
     global class Assemblies {
        public String AssmSeq;  //1
        public String SKU;  //IRSPUB
        public String RevNo;    //2016
        public String DR_Template_CD;   //CDA
        public String DR_Template_Date; //01-01-2016
       
    }
    
    global class Tiers {
        public String TierLine;  //1
        public String StartUnit;  //IRSPUB
        public String EndUnit;    //2016
        public String UnitPrice;   //CDA
       // public String OrderRatePlanCharge; //01-01-2016
    }
    
    
    public static CreateOrder parse(String json){
        return (CreateOrder) System.JSON.deserialize(json, CreateOrder.class);
    }

    
}
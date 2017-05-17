global class ReplicateTokenJson{
    
    global ReplicateToken ReplicateToken;
    
    global class ReplicateToken {
        public Sfdc Sfdc;
        public Information Information;
        public Credit_Card_Details Credit_Card_Details;
        public Bank_Details Bank_Details;
        public Address Address;
    }
    global class Sfdc {
        public String SF_Account_ID;   
        public String SF_PaymentMethod_ID; 
    }
    global class Information {
        public String Billing_FirstName;    //14
        public String Billing_LastName; //1
        public String Billing_Email;    //Watts
        public String Account_Name; //AccountName
        public String PID; //27000015
        public String CID; //5421456
        public String Active;   //Yes
        public String Default_Check;  //UTS DEVELOPMENT
        public String Payment_Method;   //442088
        public String Payment_Profile_ID;   //ATX
    }
    global class Credit_Card_Details {
        public String Four_Digit_Card_Number;   //14
        public String Name_On_The_Card; //1
        public String Card_Type;    //Watts
        public String Card_Expiration_Month;    //AccountName
        public String Card_Expiration_Year; //Ye
        public String CVV;  //UTS DEVELOPMENT
    }
   global class Bank_Details {
        public String Bank_Account_number;  //14
        public String Bank_Account_name;    //1
        public String Bank_Account_Type;    //Watts
        public String Bank_Name;    //AccountName
        public String Bank_Routing_Code;    //Yes
    }
    global class Address {
        public String Billing_Address;  //14
        public String Billing_City; //1
        public String Billing_State;    //Watts
        public String Billing_Zip;  //AccountName
        public String Billing_Country;  //Yes
    }
    public static ReplicateTokenJson parse(String json){
        return (ReplicateTokenJson) System.JSON.deserialize(json, ReplicateTokenJson.class);
    }

   /* static testMethod void testParse() {
        String json=        '{'+
        '   "ReplicateToken": {'+
        '       "Sfdc": {'+
        '           "SF_Account_ID": "001E000001USSa5IAH",'+
        '           "SF_PM_ID": "001E000001USSa5IAH"'+
        '       },'+
        '       "Information": {'+
        '           "Billing_FirstName": "14",'+
        '           "Billing_LastName": "1",'+
        '           "Billing_Email": "Watts",'+
        '           "Account_Name": "AccountName",'+
        ,           "PID":  "27000032",'+
                    "CID": "5405485",'+
        '           "Active": "Yes",'+
        '           "Default": "UTS DEVELOPMENT",'+
        '           "Payment_method": "442088",'+
        '           "Payment_Profile_id": "ATX"'+
        '       },'+
        ''+
        '       "Credit_Card_Details": {'+
        '           "4Digit_Card_Number": "14",'+
        '           "Name_on_the_card": "1",'+
        '           "Card_Type": "Watts",'+
        '           "Card_expiration_Month": "AccountName",'+
        '           "Card_expiration_Year": "Yes",'+
        '           "CVV": "UTS DEVELOPMENT"'+
        ''+
        '       },'+
        ''+
        '       "Bank_Details": {'+
        '           "Bank_Account_number": "14",'+
        '           "Bank_Account_name": "1",'+
        '           "Bank_Account_Type": "Watts",'+
        '           "Bank_Name": "AccountName",'+
        '           "Bank_Routing_Code": "Yes"'+
        '       },'+
        ''+
        '       "Address": {'+
        '           "Billing_Address": "14",'+
        '           "Billing_City": "1",'+
        '           "Billing_State": "Watts",'+
        '           "Billing_Zip": "AccountName",'+
        '           "Billing_Country": "Yes"'+
        '       }'+
        ''+
        '   }'+
        '}';
        fromJSON obj = parse(json);
        System.assert(obj != null);
    } */
}
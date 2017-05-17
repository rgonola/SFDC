global class ReturnCustInfoJson{
public Result result;

global class Result{
    public String Status;   //Success
    public String requestRecievedFor;   //RETURN_CUST_INFO_WEB
    public String Message;
    public String ErrorCode;
    public String SF_Account_ID;    //001E000000N7r6YIAR
    public String PID;  //10060
    public String ClientID; //1430198
    public String Office;   //0
    public String Phone;    //7065551212
    public String Fax;  //7065551212
    public String MobilePhone;  //3333333333
    public String ContactEmailAddress;  //joe.herrin@cchsfs.com<mailto:joe.herrin@cchsfs.com>
    public String PrimaryContactFirstName;  //PAUL X
    public String PrimaryContactLastName;   //TEST5
    public String SecondaryContactFirstName;    //SUR
    public String SecondaryContactLastName; //TEST6
    public String CompanyName;  //TEST COMPANY 997
    public String BillingAddress1;  //3456 Testing Avenue 10
    public String BillingAddress2;  //Apt. Testing 1234577
    public String BillingCity;  //ROME
    public String BillingState; //GA
    public String BillingZip;   //30165
    public String BillingCountry;   //USA
    public String ShippingAddress1; //Joiner and Son Accounting
    public String ShippingAddress2; //ship line 963
    public String ShippingCity; //ROME
    public String ShippingState;    //GA
    public String ShippingZip;  //30165
    public String ShippingCountry;  //USA
   }
    public static ReturnCustInfoJson  parse(String json){
        return (ReturnCustInfoJson) System.JSON.deserialize(json,ReturnCustInfoJson.class);
    }

   
}
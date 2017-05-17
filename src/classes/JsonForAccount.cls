global class JsonForAccount{
    
    public ReplicateCustomer ReplicateCustomer;
    
    
    global class ReplicateCustomer {
        public Sfdc Sfdc;
        public Customer Customer;
        public Contacts[] Contacts;
    }
    
    global class tworeq{
        public TWO TWO;
       
    }
    
    global class Sfdc {
        public String SF_Account_ID;    //12345678
    }
    global class Customer {
        public String PID;  //3
        public String ClientID; //19448
        public String Office;   //0
        public String Brand_Type;   //ATX
        public String First_Name;   //Dilan
        public String Last_Name;    //Viloria
        public String Company;  //JW
        public String Email;    //dilan@cchsfs.com
    }
    
        global class TWO{
        public String PID;  //3
        public String CID; //19448
        public String Office;   //0
        public String SFDC_AccountID;   //ATX
        public String FirstName;   //Dilan
        public String LastName;    //Viloria
        public String CompanyName;  //JW
        public String Email;    //dilan@cchsfs.com
        public String PhoneNumber;
        public String Year;
        public String SKU;
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
    public static JsonForAccount parse(String json){
        return (JsonForAccount) System.JSON.deserialize(json, JsonForAccount.class);
    }

   /* static testMethod void testParse() {
        String json=        '{'+
        '  "ReplicateCustomer": {'+
        '    "Sfdc": { "SF_Account_ID": "12345678" },'+
        '    "Customer": {'+
        '      "PID": "3",'+
        '      "ClientID": "19448",'+
        '      "Office": "0",'+
        '      "Brand_Type": "ATX",'+
        '      "First_Name": "Dilan",'+
        '      "Last_Name": "Viloria",'+
        '      "Company": "JW",'+
        '      "Email": "dilan@cchsfs.com"'+
        '    },'+
        '    "Contacts":  '+
        '    ['+
        '        {'+
        '          "Cnt_Type": "Shipping",'+
        '          "Phone": "678-125-9658",'+
        '          "Fax": "678-741-9222",'+
        '          "Mobile": "678-741-9223",'+
        '          "Email": "myshipping@cchsfs.com",'+
        '          "Addr1": "2025 Barrett Pkwy",'+
        '          "Addr2": "Apt 2145",'+
        '          "City": "Kennesaw",'+
        '          "State": "GA",'+
        '          "Zip": "30144-4785",'+
        '          "Country": "USA"'+
        '        },'+
        '        {'+
        '          "Cnt_Type": "Mailing",'+
        '          "Phone": "678-125-9655",'+
        '          "Fax": "678-741-9211",'+
        '          "Mobile": "678-747-9229",'+
        '          "Email": "mymailing@cchsfs.com",'+
        '          "Addr1": "8964 Barrett Pkwy",'+
        '          "Addr2": "Suite 300",'+
        '          "City": "Kennesaw",'+
        '          "State": "GA",'+
        '          "Zip": "30144-4785",'+
        '          "Country": "USA"'+
        '        }'+
        '      ]'+
        '  }'+
        '}'+
        '';
        fromJSON obj = parse(json);
        System.assert(obj != null);
    }*/
}
global class Invoicejsonwrapper{

    public Cancel_Invoice Cancel_Invoice;
    
    global class Cancel_Invoice {
        public String Invoice_Number;   //INV-63057
    }
    
    public static Invoicejsonwrapper parse(String json){
        return (Invoicejsonwrapper) System.JSON.deserialize(json, Invoicejsonwrapper.class);
    }

    
}
public with sharing class transactionError {

	public static  transactionError instance{
				get{ if ( instance == null ) instance = new transactionError();
						 return instance;
					 }
				private set;
			}

	public  boolean errorFound    {get;set;}
	public  integer errorCode     {get;set;}
	public  string  errorMessage  {get;set;}

	private transactionError() {
		  errorFound    = false;
	    errorCode     = 0;
	    errorMessage  = null;
	}

}
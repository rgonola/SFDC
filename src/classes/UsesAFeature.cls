public with sharing class UsesAFeature {

/*
    public void GrabsFeatures()
	{
		List<idea> ideas = [Select ID, Body from Idea Limit 1];
		String content;
		if(ideas.size()==1) content = ideas[0].Body; 
	}
*/	
	public void DoesntGrabFeatures()
	{
		Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
		if(gd.ContainsKey('Idea'))
		{
			List<SObject> ideas = Database.Query('Select ID, Body from Idea Limit 1');
			String content;
			if(ideas.size()==1) content = (string)ideas[0].get('Body');
		}
	}

	// Older orgs may not have Categories enabled on Ideas
/*
    public void MissingFields()
	{
		List<idea> ideas = [Select ID, Categories from Idea Limit 1];
		String cats;
		if(ideas.size()==1) cats = ideas[0].Categories; 
	}

	public void SafeMissingFields()
	{
		if(IsIdeaCategoriesFieldPresent())
		{
			List<SObject> ideas = Database.Query('Select ID, Categories from Idea Limit 1');
			String content;
			if(ideas.size()==1) content = (string)ideas[0].get('Categories');
		}
	}
*/
	private static Boolean CategoriesFieldTested = false;
	private static Boolean CategoriesField = false;

	public Boolean IsIdeaCategoriesFieldPresent()
	{
		if(CategoriesFieldTested) return CategoriesField;
		CategoriesFieldTested = true;
		Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
		if(gd.ContainsKey('Idea'))
		{
			Schema.Describesobjectresult describeresult = gd.get('Idea').getDescribe();
			Map<String,Schema.Sobjectfield> ideafields = describeresult.fields.getmap();
			if(ideafields.containskey('Categories'))
			{
				CategoriesField = true;
			}
		}
		return CategoriesField;		
	}

}
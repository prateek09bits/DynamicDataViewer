/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-12-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class objectControllerLwc {
   // Method to get all standard and custom objects that are accessible
 @AuraEnabled(cacheable=true)
    public static List<String> getAllObjects() {
                List<String> objects = new List<String>();
        for (Schema.SObjectType sObj : Schema.getGlobalDescribe().values()) {
            Schema.DescribeSObjectResult res = sObj.getDescribe();
            if (res.isAccessible()) {
                objects.add(res.getName());
            }
        }
        if(objects.size()>0)
        {
        objects.sort();
        }
        return objects;
        
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getFields(String objectName) {
        try{
                Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
                List<Map<String, String>> fieldList = new List<Map<String, String>>();

                for (Schema.SObjectField f : fieldMap.values()) {
                    Schema.DescribeFieldResult dfr = f.getDescribe();
                    if (dfr.isAccessible()) {
                        fieldList.add(new Map<String, String>{
                            'label' => dfr.getLabel(),
                            'apiName' => dfr.getName(),
                            'editable' => String.valueOf(dfr.isUpdateable())
                        });
                    }
                }
                return fieldList;
        }
        catch(exception e)
        {
             System.debug('error');
            return null;
        }
        
    }

    @AuraEnabled
    public static List<SObject> getRecords(String objectName, List<String> fieldList, Integer limitSize, Integer offsetSize) {
        try{
                    if (fieldList == null || fieldList.isEmpty()) return new List<SObject>();
                    String query = 'SELECT ' + String.join(fieldList, ',') + ' FROM ' + objectName +
                                   ' LIMIT ' + limitSize + ' OFFSET ' + offsetSize;
                    return Database.query(query);
        }
        catch(exception e)
        {
             System.debug('error');
            return null;
        }
    }

    @AuraEnabled
    public static string updateRecords(List<SObject> updatedData) {
      
        try{
                
                update updatedData;
      			return 'done';
        }
        catch(exception e)
        {
            return null;
        }
          
        
    }
}
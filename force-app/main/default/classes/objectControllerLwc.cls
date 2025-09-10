/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-10-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class objectControllerLwc {
   // Method to get all standard and custom objects that are accessible
   // and queryable
 @AuraEnabled(cacheable=true)
    public static List<String> getAllObjects() {
        try
        {
        List<String> objects = new List<String>();
        for (Schema.SObjectType sObj : Schema.getGlobalDescribe().values()) {
            Schema.DescribeSObjectResult res = sObj.getDescribe();
            if (res.isQueryable()) {
                objects.add(res.getName());
            }
        }
        objects.sort();
        return objects;
    }
    catch(Exception e){
        System.debug('Error: ' + e.getMessage());
        return null;
    }
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
        catch(Exception e){
            System.debug('Error: ' + e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static List<SObject> getRecords(String objectName, List<String> fieldList, Integer limitSize, Integer offsetSize) {
        if (fieldList == null || fieldList.isEmpty()) return new List<SObject>();
        String query = 'SELECT ' + String.join(fieldList, ',') + ' FROM ' + objectName +
                       ' LIMIT ' + limitSize + ' OFFSET ' + offsetSize;
        return Database.query(query);
    }

    @AuraEnabled
    public static void updateRecords(List<SObject> updatedData, String objectName) {
        if (updatedData == null || updatedData.isEmpty()) return;
        List<SObject> sObjectsToUpdate = new List<SObject>();
        for (SObject record : updatedData) {
            sObjectsToUpdate.add(record);
        }
        update sObjectsToUpdate;
    }
}
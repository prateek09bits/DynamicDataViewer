declare module "@salesforce/apex/objectControllerLwc.getAllObjects" {
  export default function getAllObjects(): Promise<any>;
}
declare module "@salesforce/apex/objectControllerLwc.getFields" {
  export default function getFields(param: {objectName: any}): Promise<any>;
}
declare module "@salesforce/apex/objectControllerLwc.getRecords" {
  export default function getRecords(param: {objectName: any, fieldList: any, limitSize: any, offsetSize: any}): Promise<any>;
}
declare module "@salesforce/apex/objectControllerLwc.updateRecords" {
  export default function updateRecords(param: {updatedData: any, objectName: any}): Promise<any>;
}

import { LightningElement, track } from 'lwc';
import getAllObjects from '@salesforce/apex/objectControllerLwc.getAllObjects';
import getFields from '@salesforce/apex/objectControllerLwc.getFields';
import getRecords from '@salesforce/apex/objectControllerLwc.getRecords';
import updateRecords from '@salesforce/apex/objectControllerLwc.updateRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SalesforceObjectViewer extends LightningElement {
  @track objectOptions = [];
    @track selectedObject;
    @track fieldOptions = [];
    @track selectedFields = [];
    @track columns = [];
    @track data = [];
    @track draftValues = [];
    @track noRecords = false;

    // Modal state
    @track isModalOpen = false;

    offset = 0;
    limit = 10;
    isLoading = false;

    connectedCallback() {
        this.loadObjects();
    }

    async loadObjects() {
        try {
            const result = await getAllObjects();
            this.objectOptions = result.map(obj => ({ label: obj, value: obj }));
        } catch (error) {
            this.showToast('Error', 'Failed to load objects', 'error');
        }
    }

    async handleObjectChange(event) {
        this.selectedObject = event.detail.value;
        this.data = [];
        this.columns = [];
        this.noRecords = false;

        try {
            const fields = await getFields({ objectName: this.selectedObject });
            this.fieldOptions = fields.map(f => ({ label: f.label, value: f.apiName }));
        } catch (error) {
            this.showToast('Error', 'Unable to fetch fields', 'error');
        }
    }

    openFieldModal() {
        this.isModalOpen = true;
    }

    closeFieldModal() {
        this.isModalOpen = false;
    }

    handleFieldSelection(event) {
        this.selectedFields = event.detail.value;
    }

    async loadRecords() {
    this.offset = 0;  // reset when loading first time
    try {
        const records = await getRecords({
            objectName: this.selectedObject,
            fieldList: this.selectedFields,
            limitSize: this.limit,     // fetch 10
            offsetSize: this.offset
        });

        this.data = records;                // first 10
        this.noRecords = (records.length === 0);

        this.columns = this.selectedFields.map(field => ({
            label: this.fieldOptions.find(f => f.value === field).label,
            fieldName: field,
            editable: true
        }));

        this.isModalOpen = false; // close modal
    } catch (error) {
        this.showToast('Error', 'Unable to fetch records', 'error');
    }
}


    async handleSave(event) {
        try {
            await updateRecords({ updatedData: event.detail.draftValues, objectName: this.selectedObject });
            this.showToast('Success', 'Records updated successfully', 'success');
            this.draftValues = [];
            this.loadRecords();
        } catch (error) {
            this.showToast('Error', 'Failed to update records', 'error');
        }
    }

  async handleLoadMore() {
    this.isLoading = true; // show spinner
    this.offset += this.limit;  // move to next batch

    try {
        const moreData = await getRecords({
            objectName: this.selectedObject,
            fieldList: this.selectedFields,
            limitSize: this.limit,
            offsetSize: this.offset
        });

        // artificial delay (2 seconds)
        await new Promise(resolve => setTimeout(resolve, 2000));

        this.data = [...this.data, ...moreData];

        // Stop infinite loading if fewer than limit
        if (moreData.length < this.limit) {
            const table = this.template.querySelector('lightning-datatable');
            if (table) {
                table.enableInfiniteLoading = false;
            }
        }
    } catch (error) {
        this.showToast('Error', 'Error loading more data', 'error');
    } finally {
        this.isLoading = false; // hide spinner
    }
}




    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}
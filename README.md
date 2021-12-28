## Expense Tracker App With Receipt Scanning


### Description

1. Dashboard tab displays a pie chart based on expense category. <br/>
2. Logs tab displays the expenses added. <br/>
3. Expenses can be manually added, modified and deleted. <br/>
4. You can also add expenses by scaning receipts using camera icon that is present near Add. <br/>
5. User can sort the expenses by date or by amount and order by ascending or descending order. <br/>
6. User can filter the expenses and see Last Week's or Last Month's expenses. <br/>
7. Preferences tab can be used to set daily reminders for the user to log expenses for the day. <br/>

### Frameworks Used
    
 * VisionKit
 * UserNotifications
    
### Special Instructions

 * Use IOS version 15.1 for VisionKit to work properly. Version 15.0 has some known issues with VisionKit.<br/>
 * Scan Receipts cannot be tested using the Simulator because it uses Camera. <br/>
 * The App needs to be installed in the phone to test this particular feature.<br/>

### Scan Receipt Parser - Scope

1. Scan receipt feature will extract only the title(shop name) and total amount from the receipt. <br/>
2. The parser will read the receipt content line-by-line, and parses as explained below: <br/>
    * The first line in the receipt will be taken as the title(shop name)<br/>
    * The number that comes after the word 'total' or 'debit' will be taken as the total amount. <br/>
    * Current date will be taken as the 'purchased date' because of different date formats in different receipts. <br/>
    * The App will show a preview of the above parsed information. The user can modify it if needed before saving it to the expense logs. <br/>
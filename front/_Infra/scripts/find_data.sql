-- bm_StorageOperations
select * from front.dbo.bm_StorageOperations;

select 'insert into storage_operations(external_id, document_id, operation_id, product_id, vendor_id, storage_id, range_id, count, price, pricecost, total_price, taxed_percent, taxed_amount) values ('
+ cast(front.dbo.bm_StorageOperations.ID as varchar(max)) + ','
+ cast(front.dbo.bm_StorageOperations.DocumentID as varchar(max)) + ','
+ cast(front.dbo.bm_StorageOperations.OperationID as varchar(max)) + ','
+ cast(front.dbo.bm_StorageOperations.ProductID as varchar(max)) + ','
+ cast(front.dbo.bm_StorageOperations.VendorID as varchar(max)) + ','
+ cast(front.dbo.bm_StorageOperations.StorageID as varchar(max)) + ','
+ cast(front.dbo.bm_StorageOperations.RangeID as varchar(max)) + ','
+ cast(front.dbo.bm_StorageOperations.[Count] as varchar(max)) + ','
+ cast(front.dbo.bm_StorageOperations.Price as varchar(max)) + ','
+ cast(front.dbo.bm_StorageOperations.PriceCost as varchar(max)) + ','
+ cast(front.dbo.bm_StorageOperations.Amount as varchar(max)) + ','
+ cast(front.dbo.bm_StorageOperations.Taxed as varchar(max)) + ','
+ cast(front.dbo.bm_StorageOperations.TaxedAmount as varchar(max)) + ');'
as sql
from front.dbo.bm_StorageOperations;

-- bm_JournalBarnetDocs
select * from front.dbo.bm_JournalBarnetDocs;

select 'insert into document_headers(external_id, document_type_id, journal_id, document_sum, person_id, shift_id) values ('
+ cast(front.dbo.bm_JournalBarnetDocs.ID as varchar(max)) + ','
+ cast(front.dbo.bm_JournalBarnetDocs.DocumentTypeID as varchar(max)) + ','
+ cast(front.dbo.bm_JournalBarnetDocs.JournalID as varchar(max)) + ','
+ cast(front.dbo.bm_JournalBarnetDocs.Amount as varchar(max)) + ','
+ cast(front.dbo.bm_JournalBarnetDocs.PersonID as varchar(max)) + ','
+ cast(front.dbo.bm_JournalBarnetDocs.ShiftID as varchar(max)) + ');'
as sql
from front.dbo.bm_JournalBarnetDocs;

-- bm_StorageOperationsType
select * from front.dbo.bm_StorageOperationsType;

select 'insert into storage_operations_types(external_id, description, factor) values ('
+ cast(front.dbo.bm_StorageOperationsType.ID as varchar(max)) + ','''
+ front.dbo.bm_StorageOperationsType.[description] + ''','
+ cast(front.dbo.bm_StorageOperationsType.Factor as varchar(max)) + ');'
as sql
from front.dbo.bm_StorageOperationsType;

-- bm_JournalTypeDocuments
select * from front.dbo.bm_JournalTypeDocuments;

select 'insert into journal_document_types(external_id, description, journal_id, isparent) values ('
+ cast(front.dbo.bm_JournalTypeDocuments.ID as varchar(max)) + ','''
+ front.dbo.bm_JournalTypeDocuments.[description] + ''','
+ cast(front.dbo.bm_JournalTypeDocuments.JournalID as varchar(max)) + ','
+ cast(front.dbo.bm_JournalTypeDocuments.isParent as varchar(max))  + ');'
as sql
from front.dbo.bm_JournalTypeDocuments;

-- bm_JournalType
select * from front.dbo.bm_JournalType;

select 'insert into journal_types(external_id, name) values('
+ cast(front.dbo.bm_JournalType.ID as varchar(max)) + ','''
+ front.dbo.bm_JournalType.JournalName + ''');'
as sql
from front.dbo.bm_JournalType;

-- product
select * from front.dbo.product;

select 'insert into products(external_id, product_id, name, vendor_id, category_id, size_id, isused) values('
+ cast(front.dbo.product.ID as varchar(max)) + ','
+ cast(front.dbo.product.productid as varchar(max)) + ','''
+ front.dbo.product.[description] + ''','
+ cast(front.dbo.product.vendorid as varchar(max)) + ','
+ cast(front.dbo.product.CategoryID as varchar(max)) + ','
+ cast(front.dbo.product.SizeID as varchar(max)) + ','
+ cast(front.dbo.product.IsUse as varchar(max)) + ');'
as sql
from front.dbo.product;

-- vendors
select * from front.dbo.vendors;

select 'insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values ('
+ cast(front.dbo.vendors.id as varchar(max)) + ','''
+ front.dbo.vendors.clientid + ''','
+ cast(front.dbo.vendors.clientgroup as varchar(max)) + ','''
+ front.dbo.vendors.firstname + ''','
+ cast(front.dbo.vendors.IsUse as varchar(max)) + ');'
as sql
from front.dbo.vendors;

-- personnel
select * from front.dbo.personnel;

select 'insert into employees(external_id, firstname, lastname, middlename, security_access) values ('
+ cast(front.dbo.personnel.personid as varchar(max)) + ','''
+ front.dbo.personnel.firstname + ''','''
+ front.dbo.personnel.lastname + ''','''
+ front.dbo.personnel.middlename + ''','
+ cast(front.dbo.personnel.securityaccess as varchar(max)) + ');'
as sql
from front.dbo.personnel;

-- journal
select * from front.dbo.journal;

select 'insert into journal(external_line_id, line_type, receipt, cost, amount, total_cost, item_id, description, discount_percent, discount_amount, employee_id) values ('
+ cast(front.dbo.journal.transnumber as varchar(max)) + ','
+ cast(front.dbo.journal.transtype as varchar(max)) + ','
+ cast(front.dbo.journal.receiptn as varchar(max)) + ','
+ cast(front.dbo.journal.price as varchar(max)) + ','
+ cast(front.dbo.journal.quantity as varchar(max)) + ','
+ cast(front.dbo.journal.amount as varchar(max)) + ','
+ cast(front.dbo.journal.id as varchar(max)) + ','''
+ front.dbo.journal.[description] + ''','
+ cast(front.dbo.journal.discount as varchar(max)) + ','
+ cast(front.dbo.journal.discountamount as varchar(max)) + ','
+ cast(front.dbo.journal.loginid as varchar(max)) + ');'
as sql
from front.dbo.journal;

-- size
select * from front.dbo.size;

select 'insert into size(external_id, name, factor ) values ('
    + cast(front.dbo.size.id as varchar(max)) + ','''   
    + front.dbo.size.sizeid + ''','  
    + caST(front.dbo.size.portionrate as varchar(max))   + ');' 
    as sql
 from front.dbo.size

 -- bm_Journal_Details
 select * from front.dbo.bm_Journal_Details;

 select 'insert into journal_details(external_id, line_id, product_id, dish_id, weight_brutto, amount, range_id, range_amount, ticket_number, size_id, storage_id) values ('
 + cast(front.dbo.bm_Journal_Details.ID as varchar(max)) + ','
 + cast(front.dbo.bm_Journal_Details.SourceID as varchar(max)) + ','
 + cast(front.dbo.bm_Journal_Details.ProductID as varchar(max)) + ','
 + cast(front.dbo.bm_Journal_Details.BludoID as varchar(max)) + ','
 + cast(front.dbo.bm_Journal_Details.sBrutto as varchar(max)) + ','
 + cast(front.dbo.bm_Journal_Details.Quantity as varchar(max)) + ','
 + cast(front.dbo.bm_Journal_Details.RangeID as varchar(max)) + ','
 + cast(front.dbo.bm_Journal_Details.[Count] as varchar(max)) + ','
 + cast(front.dbo.bm_Journal_Details.TicketNumber as varchar(max)) + ','
 + cast(front.dbo.bm_Journal_Details.SizeID as varchar(max)) + ','
 + cast(front.dbo.bm_Journal_Details.StorageID as varchar(max)) + ');'
 as sql
 from front.dbo.bm_Journal_Details;

 -- transtype
 select * from front.dbo.transtype;

 select 'insert into trans_types(external_id, group_id, preview_group_type, description) values ('
 + cast(front.dbo.transtype.transtypeid as varchar(max)) + ','
 + cast(front.dbo.transtype.transgroupid as varchar(max)) + ','''
 + front.dbo.transtype.PreviewGroupType + ''','''
 + front.dbo.transtype.[description] + ''');'
 as sql
 from front.dbo.transtype;

 -- pricelist
 select * from front.dbo.pricelist;

 select 'insert into pricelist (external_id, document_id, cost, group_id, product_id) values ('
 + cast(front.dbo.pricelist.id as varchar(max)) + ','
 + cast(front.dbo.pricelist.DocumentID as varchar(max)) + ','
 + cast(front.dbo.pricelist.basecost as varchar(max)) + ','
 + cast(front.dbo.pricelist.groupid as varchar(max)) + ','
 + cast(front.dbo.pricelist.productid as varchar(max)) + ');'
 as sql
 from front.dbo.pricelist;

-- vendorgroup (добавь меня сам и удали пж)
select * from front.dbo.vendorgroup;

-- bm_PersonnelSecurity
select * from front.dbo.bm_PersonnelSecurity;

select 'insert into employee_access(external_id, employee_id, object_id, isuse) values('
+ cast(front.dbo.bm_PersonnelSecurity.ID as varchar(max)) + ','
+ cast(front.dbo.bm_PersonnelSecurity.PersonID as varchar(max)) + ','
+ cast(front.dbo.bm_PersonnelSecurity.ObjectID as varchar(max)) + ','
+ cast(front.dbo.bm_PersonnelSecurity.IsUse as varchar(max)) + ');'
as sql
from front.dbo.bm_PersonnelSecurity;

-- Анализ закупки продукции
-- Таблица операций хранилищ
select front.dbo.bm_StorageOperations.ID,DocumentID,OperationID,SourceID,BludoID,ProductID,VendorID,clientid,StorageID,RangeID,Price,Count,Amount,ReasonID,[Description]
from front.dbo.bm_StorageOperations
left join front.dbo.vendors on front.dbo.vendors.id = front.dbo.bm_StorageOperations.VendorID -- Связь с таблицей поставщиков
left join front.dbo.bm_ReasonDebit on front.dbo.bm_ReasonDebit.id = front.dbo.bm_StorageOperations.ReasonID -- Связь с таблицей списаний
go

-- Анализ продажи товара
-- Таблица продаж
select transnumber,receiptn,BonusValue,dater,transtype,front.dbo.journal.id,[description],quantity,price,front.dbo.journal.amount,discount,discountamount,loginid,firstname,lastname,middlename,customerid
from front.dbo.journal
left join front.dbo.personnel on front.dbo.personnel.personid = front.dbo.journal.loginid -- Связь с таблицей персонала
left join front.dbo.bm_BonusHistory on front.dbo.bm_BonusHistory.TicketNumber = front.dbo.journal.receiptn -- Связь с таблицей бонусов
left join front.dbo.bm_JournalBarnetDocs on front.dbo.bm_JournalBarnetDocs.TicketNumber = front.dbo.journal.receiptn -- Связь с таблицей чеков
go

-- Таблица себестоимости продаж
select front.dbo.bm_StorageOperations_Table.ID,DocumentID,OperationID,SourceID,BludoID,front.dbo.bm_StorageOperations_Table.Price,PriceCost,Count,front.dbo.bm_StorageOperations_Table.Amount,ReasonID,front.dbo.bm_ReasonDebit.[Description]
from front.dbo.bm_StorageOperations_Table
left join front.dbo.journal on front.dbo.journal.transnumber = front.dbo.bm_StorageOperations_Table.SourceID -- Связь с таблицей продаж
left join front.dbo.bm_ReasonDebit on front.dbo.bm_ReasonDebit.ID = front.dbo.bm_StorageOperations_Table.ReasonID -- Связь с таблицей списаний
go

-- Анализ работы персонала
-- Таблица сотрудников
select front.dbo.personnel.personid,firstname,lastname,middlename,ObjectID
from  front.dbo.personnel
left join front.dbo.journal on front.dbo.journal.loginid = front.dbo.personnel.personid -- Связь с таблицей продаж
left join front.dbo.bm_JournalBarnetDocs on front.dbo.bm_JournalBarnetDocs.PersonId = front.dbo.personnel.personid -- Связь с таблицей отчетов
left join front.dbo.bm_JournalSessions on front.dbo.bm_JournalSessions.PersonID = front.dbo.personnel.personid -- Связь с таблицей логов
left join front.dbo.bm_PersonnelSecurity on front.dbo.bm_PersonnelSecurity.PersonID = front.dbo.personnel.personid -- Связь с таблицей личных данных
go

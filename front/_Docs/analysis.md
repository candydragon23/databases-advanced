# Анализ закупки продукции

## bm_StorageOperations - операции склада

|Столбец|Назначение|Пример|
|-|-|-|
|ID|ID строки|4780435|
|DocumentID|Документ|388238|
|OperationID|Тип операции|1|
|SourceID|Строка чека|0|
|BludoID|Блюдо|0|
|ProductID|Товар|4366|
|VendorID|Поставщик|91|
|StorageID|Склад|41|
|RangeID|Размер|42|
|Price|Цена|250|
|Count|Количество|4.6|
|Amount|Сумма|1150|
|ReasonID|Причина списания|NULL|

Связаны с таблицами vendors через VendorID и bm_ReasonDebit через ReasonID

## bm_StorageOperationsType - типы операций

|Столбец|Назначение|Пример|
|-|-|-|
|ID|ID типа|5|
|Description|Название|Возврат|

## product - продукты

|Столбец|Назначение|Пример|
|-|-|-|
|id|ID|4341|
|productid|Внешний код товара|7054405|
|description|Наименование|Лук репчатый|
|CategoryID|Категория|200|
|SizeID|Единица измерения|42|
|vendorid|Поставщик|0|
|cost|Цена|0|

Связана с таблицей size через SizeID

## vendors - поставщики

|Столбец|Назначение|Пример|
|-|-|-|
|id|ID поставщика|94|
|clientid|Краткое имя|5 Армия|
|firstname|Наименование |5 Армия|

## pricelist - прайслист продуктов

|Столбец|Назначение|Пример|
|-|-|-|
|id|ID строки|113685|
|DocumentID|Документ|142417|
|productid|Товар|4541|
|groupid|Группа|2|
|basecost|Цена|130|
|vendorid|Поставщик|NULL|

# Анализ продажи товара

## journal - продажи

|Столбец|Назначение|Пример|
|-|-|-|
|transnumber|Номер строки транзакции |1675588|
|receiptn|Номер чека |14740696|
|dater|Дата|2020-11-11 10:09:39.000|
|transtype|Тип строки|101|
|id|Внешний код товара|271363|
|description|Наименование|Пицца К пиву 40 см|
|quantity|Количество|1|
|price|Цена|630|
|amount|Общая сумма|630|
|discount|Процент скидки|0|
|discountamount|Сумма скидки|0|
|loginid|Сотрудник|906|

Связана с таблицей personnel через loginid

## bm_Journal_Details - детализация продаж

|Столбец|Назначение|Пример|
|-|-|-|
|ID|ID строки|11530449|
|SourceID|Строка чека|1675591|
|ProductID|Товар|4372|
|BludoID|Блюдо|4451|
|sBrutto|Вес брутто|140|
|Quantity|Количество|1|
|Count|Количество ингредиента|0.14|
|TicketNumber|Номер чека|14740696|
|RangeID|Размер|42|
|SizeID|Единица|163|
|StorageID|Склад|41|

## bm_StorageOperations_Table - себестоимость продаж

|Столбец|Назначение|Пример|
|-|-|-|
|ID|ID строки|134202|
|DocumentID|Документ|388540|
|OperationID|Тип операции|2|
|SourceID|Строка чека|200634|
|BludoID|Блюдо|4641|
|ProductID|Товар|4397|
|Price|Цена|0|
|PriceCost|Себестоимость|0|
|Count|Количество|0|
|Amount|Общая сумма|0|
|ReasonID|Причина|24|

Связана с таблицами journal через SourceID и bm_ReasonDebit через ReasonID

# Анализ взаимоотношений с поставщиками

## vendors - поставщики

См. Анализ закупки продукции

## bm_JournalBarnetDocs - документы поступления

|Столбец|Назначение|Пример|
|-|-|-|
|ID|ID документа|1220|
|JournalID|Журнал|1|
|ShiftID|Смена|65|
|DocumentTypeID|Тип документа|2|
|DocumentNumber|Номер документа|4|
|Period|Дата|2013-07-24 10:00:00.000|
|CompanyID|Компания|6|
|TicketNumber|Номер чека|NULL|
|PersonID|Сотрудник|897|

Связана с таблицей journal через TicketNumber

## vendorgroup - группы поставщиков

|Столбец|Назначение|Пример|
|-|-|-|
|vendorgroupid|ID группы|31|
|description|Название|Поставщики|

# Анализ работы персонала

## personnel - сотрудники

|Столбец|Назначение|Пример|
|-|-|-|
|personid|ID сотрудника|900|
|firstname|Имя|Мария|
|lastname|Фамилия|Пакалюк|
|middlename|Отчество|Андреевна|

Связана с таблицами journal через loginid, bm_JournalBarnetDocs через PersonID, bm_JournalSessions через PersonID и bm_PersonnelSecurity через PersonID

## bm_BonusHistory - история бонусов

|Столбец|Назначение|Пример|
|-|-|-|
|ID|ID записи|5|
|ClientID|Клиент|3354|
|BonusValue|Значение бонуса|0|
|Period|Дата|2016-04-06 08:03:24.840|
|TicketNumber|Номер чека|NULL|
|PersonID|Сотрудник|897|

Связана с таблицей journal через TicketNumber

## journal - продажи 

См. Анализ продажи товара

## bm_JournalBarnetDocs - документы поступления

См. Анализ продажи товара

## bm_JournalSessions - логи

|Столбец|Назначение|Пример|
|-|-|-|
|ID|ID записи|5|
|Type|Тип сообщения|Система|
|Message|Текст|Идет обсуживание информационной базы данных|
|DateAdd|Дата|2019-10-10 10:10:37.047|
|PersonID|Сотрудник|897|

Связана с таблицей personnel через PersonID

## bm_PersonnelSecurity - личная информация сотрудников

|Столбец|Назначение|Пример|
|-|-|-|
|ID|ID записи|1401|
|PersonID|Сотрудник|906|
|ObjectID|Код объекта|40|

Связана с таблицей personnel через PersonID

# Анализ остатков

## bm_StorageOperations - движения склада

См. Анализ закупки продукции

## bm_ReasonDebit - причины списания

|Столбец|Назначение|Пример|
|-|-|-|
|ID|ID причины|23|
|Description|Название|На приготовление обедов|

Связана с таблицей bm_StorageOperations через ID

## bm_StorageOperations_Table -  списания

См. Анализ продажи товара
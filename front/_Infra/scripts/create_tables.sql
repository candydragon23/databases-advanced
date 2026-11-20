create database front;

do $$
begin
	begin
		-- storage operations
		create sequence seq_storage_operations;
		
		create table storage_operations (
			id bigint primary key default nextval('seq_storage_operations'),
			external_id bigint,
			document_id int,
			operation_id int,
			product_id int,
			vendor_id int,
			storage_id int,
			range_id int,
			count float,
			price float,
			pricecost float,
			total_price float,
			taxed_percent float,
			taxed_amount float,
			date_add timestamp default now()
		);

		-- document headers
		create sequence seq_document_headers;

		create table document_headers (
			id bigint primary key default nextval('seq_document_headers'),
			external_id int,
			document_type_id int,
			journal_id int,
			document_sum float,
			person_id int,
			shift_id int,
			date_add timestamp default now()
		);

		-- storage operations types
		create sequence seq_storage_operations_types;
		
		create table storage_operations_types (
			id bigint primary key default nextval('seq_storage_operations_types'),
			external_id int,
			description text,
			factor int
		);

		insert into storage_operations_types(external_id, description, factor) values (1,'Поступление',1);   
		insert into storage_operations_types(external_id, description, factor) values (2,'Списание',-1);     
		insert into storage_operations_types(external_id, description, factor) values (3,'Инвентаризация',1);
		insert into storage_operations_types(external_id, description, factor) values (4,'Перемещение',1);   
		insert into storage_operations_types(external_id, description, factor) values (5,'Возврат',1);

		-- journal document types
		create sequence seq_journal_document_types;
		
		create table journal_document_types (
			id bigint primary key default nextval('seq_journal_document_types'),
			external_id int,
			description text,
			journal_id int,
			isparent int
		);

		insert into journal_document_types(external_id, description, journal_id, isparent) values (1,'Ввод состава нового рецепта',1,0);    
		insert into journal_document_types(external_id, description, journal_id, isparent) values (2,'Редактирование рецепта',1,0);         
		insert into journal_document_types(external_id, description, journal_id, isparent) values (3,'Установка цен продуктов',1,0);        
		insert into journal_document_types(external_id, description, journal_id, isparent) values (4,'Поступление продуктов',3,0);          
		insert into journal_document_types(external_id, description, journal_id, isparent) values (5,'Списание продуктов',3,0);             
		insert into journal_document_types(external_id, description, journal_id, isparent) values (6,'Товарный чек',2,0);                   
		insert into journal_document_types(external_id, description, journal_id, isparent) values (7,'Перемещение продуктов',3,0);          
		insert into journal_document_types(external_id, description, journal_id, isparent) values (8,'Инвентаризация',3,0);                 
		insert into journal_document_types(external_id, description, journal_id, isparent) values (9,'Счет-фактура полученная',2,1);        
		insert into journal_document_types(external_id, description, journal_id, isparent) values (10,'Товарно-транспортная накладная',2,1);
		insert into journal_document_types(external_id, description, journal_id, isparent) values (11,'Поступление в кассу',4,0);           
		insert into journal_document_types(external_id, description, journal_id, isparent) values (12,'Изъятие из кассы',4,0);              
		insert into journal_document_types(external_id, description, journal_id, isparent) values (13,'Поступление изделий',5,0);           
		insert into journal_document_types(external_id, description, journal_id, isparent) values (14,'Возврат изделий',5,0);               
		insert into journal_document_types(external_id, description, journal_id, isparent) values (15,'Реализация продукции',2,1);          
		insert into journal_document_types(external_id, description, journal_id, isparent) values (16,'Списание изделий',5,0);              
		insert into journal_document_types(external_id, description, journal_id, isparent) values (17,'Приходно-кассовый ордер',4,0);       
		insert into journal_document_types(external_id, description, journal_id, isparent) values (18,'Расходно-кассовый ордер',4,0);       
		insert into journal_document_types(external_id, description, journal_id, isparent) values (19,'Предварительный заказ',5,1);

		-- journal types
		create sequence seq_journal_types;

		create table journal_types (
			id bigint primary key default nextval('seq_journal_types'),
			external_id int,
			name text
		);

		insert into journal_types(external_id, name) values(1,'Хозяйственный учет');
		insert into journal_types(external_id, name) values(2,'Финансовый учет');   
		insert into journal_types(external_id, name) values(3,'Складской учет');    
		insert into journal_types(external_id, name) values(4,'Кассовый учет');     
		insert into journal_types(external_id, name) values(5,'Производство');      
		insert into journal_types(external_id, name) values(7,'Бронирование'); 

		-- products
		create sequence seq_products;

		create table products(
			id bigint primary key default nextval('seq_products'),
			external_id int,
			product_id int,
			name text,
			vendor_id int,
			category_id int,
			size_id int,
			isused int
		);

		-- vendors
		create sequence seq_vendors;

		create table vendors (
			id bigint primary key default nextval('seq_vendors'),
			external_id int,
			vendor_id text,
			vendor_group int,
			name text,
			isuse int
		);

		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (90,'Габур',32,'ИП Габур',0);                                   
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (91,'Габур',31,'ИП Габур',1);                                   
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (92,'Столярская',31,'ИП Столярская',1);                         
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (93,'Столярская',31,'ИП Столярская',0);                         
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (94,'5 Армия',31,'5 Армия',0);                                  
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (95,'Вираж',31,'ООО Вираж',1);                                  
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (96,'Пепсико',31,'ООО Пепсико Холдингс',0);                     
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (97,'Авангард',31,'ООО Авангард',0);                            
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (98,'Молочные продукты',31,'Молочные продукты',0);              
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (99,'Лидер',31,'ООО Лидер',0);                                  
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (100,'Консерватор (Захаров)',31,'ООО Консерватор (Захаров)',0); 
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (101,'Рузавина',31,'Рузавина',0);                               
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (102,'Кока- кола',31,'Кока- кола',1);                           
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (103,'Алида',31,'ООО Алида',0);                                 
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (104,'Упак торг',31,'ООО Упак торг',0);                         
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (105,'Элит Трейд',31,'ООО Элит Трейд',0);                       
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (106,'ПЭТ Бутылка',31,'ПЭТ Бутылка',0);                         
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (107,'Овощи',31,'Овощи Сатурн',1);                              
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (108,'Покупка в розницу',31,'Розничная торговля',1);            
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (109,'СБС',31,'ООО "Система"',0);                               
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (110,'Кладовы',31,'ИП Кладов (Капитал-Технология)',1);          
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (111,'СХ Белореченское',31,'СХ ОАО Белореченское',1);           
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (112,'ООО МЕТРО',31,'ООО МЕТРО КЭШ ЭНД КЕРРИ',1);               
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (113,'Мир специй',31,'ООО "Мир специй"',0);                     
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (114,'Клецко Д.А.',31,'ИП Клецко Д.А.',0);                      
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (115,'Сибирский холод',31,'ИП Титова',0);                       
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (116,'ИП Хухрянский',31,'ИП Хухрянский',0);                     
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (117,'ООО "Сибирский холод"',31,'ООО "Сибирский холод"',0);     
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (118,'Переработка',31,'Переработка',0);                         
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (119,'"Айвенго"',31,'ООО "Фабрика мороженого "Айвенго"',0);     
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (120,'ИП Лятифов',31,'ИП Лятифов Элшан Бахрам оглы',0);         
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (121,'ИП Усачев',31,'ИП Усачев Денис Игоревич',0);              
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (122,'Риконт',31,'ООО "Риконт"',0);                             
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (123,'Лидер Мука',31,'ИП Нарожных Т.С.',1);                     
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (124,'ООО "Индустрия"',31,'ООО "Индустрия"',0);                 
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (125,'Пивной мир',31,'ООО "Пивной мир"',0);                     
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (126,'ООО "Балтбир"',31,'ООО "Балтбир"',0);                     
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (127,'Деликатес',31,'ООО "Деликатес"',0);                       
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (128,'Футурум',31,'ООО "Футурум"',0);                           
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (129,'ЗПВ',31,'ЗПВ',0);                                         
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (130,'ООО Торгсервис Кеги',31,'ООО Торгсервис Кеги',0);         
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (131,'ООО "Экспресс"',31,'ООО "Экспресс"',1);                   
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (132,'Гастроном',31,'Гастроном',0);                             
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (133,'Выравнивание остатка',31,'Выравнивание остатка',0);       
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (134,'ИП Пыткин Э.А.',31,'ИП Пыткин Э.А.',0);                   
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (196,'Конвертация Barnet',31,'Конвертация Barnet',0);           
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (197,'ИП Бельских А.Б.',31,'ИП Бельских А.Б.',0);               
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (198,'ООО Партнер',31,'ООО Партнер',0);                         
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (199,'ООО Торгсервис Иркутск',31,'ООО Торгсервис Иркутск',1);   
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (200,'ООО "Элит Трейд"',31,'ООО "Элит Трейд"',1);               
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (201,'ZEN  19',31,'ZEN 19',0);                                  
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (202,'Светофор',31,'Светофор',1);                               
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (203,'ZEN 33',31,'ZEN 33',0);                                   
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (204,'Командор',31,'Командор',1);                               
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (205,'ООО Экспресс Кока-Кола',31,'ООО Экспресс Кока-Кола',0);   
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (206,'ООО Виктория Н',31,'ООО Виктория Н',0);                   
		insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values (207,'Молочная доставка',31,'ООО"Молочная доставка"',0);

		-- storages
		create sequence seq_storages;

		create table storages (
			id bigint primary key default nextval('seq_storages'),
			external_id int,
			name text
		);

		insert into storages(external_id, name) values (41, 'Склад');

		-- employees
		create sequence seq_employees;

		create table employees (
			id bigint primary key default nextval('seq_employees'),
			external_id int,
			firstname text,
			lastname text,
			middlename text,
			security_access int
		);

		insert into employees(external_id, firstname, lastname, middlename, security_access) values (897,'Администратор Barnet','','',9);                    
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (898,'Татьяна','Безик','Сергеевна',9);                   
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (899,'Ольга','Шипицына','Вячеславовна',9);               
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (900,'Мария','Пакалюк','Андреевна',1);                   
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (901,'Кристина','Скубало','',1);                         
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (902,'Татьяна','Кустикова','',1);                        
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (903,'Анна','Нагорная','',1);                            
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (904,'Касса 1','Кафе 1','',9);                           
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (905,'Касса 2','Кафе 2','',3);                           
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (906,'Доставка','Доставка','',3);                        
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (907,'Услуги гостиниц','Услуги гостиниц','',1);          
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (969,'Алена','Кушавина','Александровна',1);              
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (970,'Татьяна','Макаренко','Дмитриевна',1);              
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (971,'Валентина','Васильева','Владимировна',1);          
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (972,'Наталья','Черная','Владимировна',1);               
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (973,'Александр','Никулин','Викторович',1);              
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (974,'Татьяна','Быстрова','Владимировна',1);             
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (975,'Яна','Берг','Юрьевна',1);                          
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (976,'Карина','Черная','Игоревна',1);                    
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (977,'Алина','Семенова','Денисовна',1);                  
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (978,'Анастасия','Шведова','Александровна',1);           
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (979,'Мария','Пионова','Андреевна',1);                   
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (980,'Ксения','Болгарова','Александровна',1);            
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (981,'Ирина','Смирнова','Владимировна',1);               
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (982,'Елена','Шевченко','Вениаминовна',1);               
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (983,'Юлия','Чернобай','Сергеевна',1);                   
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (984,'Андрей','Ражавикин','Александрович',1);            
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (985,'Антон','Майборский','Сергеевич',1);                
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (986,'Анастасия','Англичанова','Валерьевна',1);          
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (987,'Алина','Семенова','Денисова',1);                   
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (988,'Валерия','Медведева','Дмитриевна',1);              
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (989,'Ирина','Кульпинская','Сергеевна',1);               
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (990,'Кристина','Горбатенко','Юрьевна',1);               
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (991,'Елена','Шибаева','Петровна',1);                    
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (992,'Алена','Крицкая','Константиновна',1);              
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (993,'Дмитрий','Черных','Алексеевич',1);                 
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (994,'Александра','Модина','Борисовна',1);               
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (995,'Александра','Плотникова','Андреевна',1);           
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (996,'Наталья','Кротова','Викторовна',1);                
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (997,'Злата','Пьянкова','Олеговна',1);                   
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (998,'Татьяна','Безик','Сергевна',1);                    
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (999,'Александра','Станиславская','Тимофеевна',1);       
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1000,'Дарья','Свешникова','Игоревна',1);                
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1001,'Вероника','Писарева','Олеговна',1);               
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1002,'Анастасия','Губанова','Вадимовна',1);             
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1003,'Диана','Баженова','Игоревна',1);                  
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1004,'Максим','Емельянов','',1);                        
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1005,'Денис','Пимкин','Анатольевич',1);                 
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1006,'Вероника','Смолина','Александровна',1);           
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1007,'Ольга','Гострик','Александровна',1);              
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1008,'Лидия','АЛЕНТЬЕВА  (Миронова)','Александровна',1);
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1009,'Яна','Глебова','Александровна',1);                
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1010,'Анна','Гагулина','Дмитриевна',1);                 
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1011,'Елена','Дёмкина','Александровна',1);              
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1012,'Татьяна','Кайданова','Витальевна',1);             
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1013,'Валентина','Толмачева','Владимировна',1);         
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1014,'Валентина','Хетчикова','Сергеевна',1);            
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1015,'Алина','Борисенко','Витальевна',1);               
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1016,'Павел','Иванов','',1);                            
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1017,'Ирина','Лопатина','Алексеевна',1);                
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1018,'Светлана','Белова','Николаевна',1);               
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1019,'Елена','Шатохина','Васильевна',1);                
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1020,'Анна','Морозова','Сергеевна',1);                  
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1021,'Виктория','Базанова','Романовна',1);              
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1022,'Тамара','Тхагапсова','Валерьевна',9);             
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1023,'Евгения','Мингазова','Алексеевна',1);             
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1024,'Анастасия','Агальцова','Алексеевна',1);           
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1025,'Ольга','Васильчук','Дмитриевна',1);               
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1026,'Роза','Раджабова','',1);                          
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1027,'Артем','Кожан','Васильевич',1);                   
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1028,'Полина','Громышева','Николаевна',1);              
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1029,'Галина','Попова','Викторовна',1);                 
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1030,'Алексей','Крутиков','Андреевич',1);               
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1031,'Нина','Чумак','Александровна',1);                 
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1032,'Елена','Шевченко','Вениамина',1);                 
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1033,'Татьяна','Митрошенко','Анатольевна',1);           
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1034,'Ольга','Чеченева','Евгеньевна',1);                
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1035,'Николай','Кибирев','Александрович',1);            
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1036,'Екатерина','Бархатова','Владимировна',1);         
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1037,'Денис','Пимкин','',1);                            
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1038,'Семён','Мешков','Владимирович',1);                
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1039,'Анастасия','Полушина','Николаевна',1);            
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1040,'Виктория','Зыкова','Сергеевна',1);                
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1041,'Кристина','Скубало','Сергеевна',1);               
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1042,'Никита','Цапенко','',1);                          
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1043,'Виталий','Уваров','',1);                          
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1044,'Артем','Кожан','',1);                             
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1045,'Антонина','Дьяченко','Владимировна',1);           
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1046,'Татьяна','Чистякова','',1);                       
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1047,'Наталья','Смирнова','',1);                        
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1048,'Виталий','Хмелевской','Олегович',1);              
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1049,'Анна','Панова','Сергеевна',1);                    
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1050,'Никита','Федоренко','Алексеевич',1);              
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1051,'Владислав','Калигин','Ярославович',1);            
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1052,'Костя','Балахнин','',1);                          
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1053,'Оксана','Шпак','',1);                             
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1054,'Денис','Днепровский','Павлович',1);               
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1055,'Муроджон','Хасанов','',1);                        
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1056,'Екатерина','Кондратьева','',1);                   
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1057,'Радэма','Бабкина','Анатольевна',1);               
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1058,'Алена','Тайшихина','Александровна',1);            
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1059,'Валерия','Зайчикова','Денисовна',1);              
		insert into employees(external_id, firstname, lastname, middlename, security_access) values (1060,'Света','Белова','',1);

		-- journal
		create sequence seq_journal;

		create table journal (
			id bigint primary key default nextval('seq_journal'),
			external_line_id int,
			line_type int,
			receipt int,
			cost float,
			amount float,
			total_cost float,
			item_id int,
			description text,
			discount_percent float,
			discount_amount float,
			employee_id int
		);

		-- size
		create sequence seq_size;

		create table size(
			id bigint primary key default nextval('seq_size'),
			external_id int,
			name text,
			factor float
		);

		insert into size(external_id, name, factor ) values (1,'порция',1.000);         
		insert into size(external_id, name, factor ) values (2,'100г',100.000);         
		insert into size(external_id, name, factor ) values (3,'Бут.500мл.',500.000);   
		insert into size(external_id, name, factor ) values (4,'50 мл',50.000);         
		insert into size(external_id, name, factor ) values (5,'1 день',1.000);         
		insert into size(external_id, name, factor ) values (6,'г',1.000);              
		insert into size(external_id, name, factor ) values (7,'мл',1.000);             
		insert into size(external_id, name, factor ) values (8,'300мл',300.000);        
		insert into size(external_id, name, factor ) values (9,'50мл',50.000);          
		insert into size(external_id, name, factor ) values (10,'200г',200.000);        
		insert into size(external_id, name, factor ) values (11,'SNG',1.000);           
		insert into size(external_id, name, factor ) values (12,'Бут.330мл',330.000);   
		insert into size(external_id, name, factor ) values (13,'20г',20.000);          
		insert into size(external_id, name, factor ) values (14,'40г',40.000);          
		insert into size(external_id, name, factor ) values (15,'150г',150.000);        
		insert into size(external_id, name, factor ) values (16,'190г',190.000);        
		insert into size(external_id, name, factor ) values (17,'180г',180.000);        
		insert into size(external_id, name, factor ) values (18,'30г',30.000);          
		insert into size(external_id, name, factor ) values (19,'Бут.250мл',250.000);   
		insert into size(external_id, name, factor ) values (20,'Ч400мл',400.000);      
		insert into size(external_id, name, factor ) values (21,'пачка',1.000);         
		insert into size(external_id, name, factor ) values (22,'30Л',30000.000);       
		insert into size(external_id, name, factor ) values (23,'10мл',1.000);          
		insert into size(external_id, name, factor ) values (24,'Бут.750мл.',750.000);  
		insert into size(external_id, name, factor ) values (25,'Бут.350мл',350.000);   
		insert into size(external_id, name, factor ) values (26,'10г',10.000);          
		insert into size(external_id, name, factor ) values (27,'350мл',200.000);       
		insert into size(external_id, name, factor ) values (28,'140г',140.000);        
		insert into size(external_id, name, factor ) values (29,'500мл',500.000);       
		insert into size(external_id, name, factor ) values (30,'280мл',280.000);       
		insert into size(external_id, name, factor ) values (31,'120 мл',120.000);      
		insert into size(external_id, name, factor ) values (32,'250мл',250.000);       
		insert into size(external_id, name, factor ) values (33,'340мл',340.000);       
		insert into size(external_id, name, factor ) values (34,'185мл',185.000);       
		insert into size(external_id, name, factor ) values (35,'75мл',75.000);         
		insert into size(external_id, name, factor ) values (36,'60мл',60.000);         
		insert into size(external_id, name, factor ) values (37,'80мл',80.000);         
		insert into size(external_id, name, factor ) values (38,'310мл',310.000);       
		insert into size(external_id, name, factor ) values (39,'литр',1000.000);       
		insert into size(external_id, name, factor ) values (40,'1000 г',1000.000);     
		insert into size(external_id, name, factor ) values (41,'50 г',50.000);         
		insert into size(external_id, name, factor ) values (42,'кг',1000.000);         
		insert into size(external_id, name, factor ) values (43,'Бут.700мл',700.000);   
		insert into size(external_id, name, factor ) values (44,'Бут.600мл',600.000);   
		insert into size(external_id, name, factor ) values (45,'0,5 литра',500.000);   
		insert into size(external_id, name, factor ) values (46,'0,3 литра',300.000);   
		insert into size(external_id, name, factor ) values (47,'200мл',1.000);         
		insert into size(external_id, name, factor ) values (48,'150  мл',1.000);       
		insert into size(external_id, name, factor ) values (49,'150мл',150.000);       
		insert into size(external_id, name, factor ) values (50,'пакет',1.000);         
		insert into size(external_id, name, factor ) values (51,'5л',5000.000);         
		insert into size(external_id, name, factor ) values (52,'850г',850.000);        
		insert into size(external_id, name, factor ) values (53,'500г',500.000);        
		insert into size(external_id, name, factor ) values (54,'550г',550.000);        
		insert into size(external_id, name, factor ) values (55,'570г',570.000);        
		insert into size(external_id, name, factor ) values (56,'400г',400.000);        
		insert into size(external_id, name, factor ) values (57,'250г',250.000);        
		insert into size(external_id, name, factor ) values (58,'160г',160.000);        
		insert into size(external_id, name, factor ) values (59,'48г',48.000);          
		insert into size(external_id, name, factor ) values (60,'90г',90.000);          
		insert into size(external_id, name, factor ) values (61,'0,97л',970.000);       
		insert into size(external_id, name, factor ) values (62,'уп 24шт',24.000);      
		insert into size(external_id, name, factor ) values (63,'100мл',100.000);       
		insert into size(external_id, name, factor ) values (64,'Бут.375мл',375.000);   
		insert into size(external_id, name, factor ) values (65,'Бут.640мл',640.000);   
		insert into size(external_id, name, factor ) values (66,'Бут.610мл',610.000);   
		insert into size(external_id, name, factor ) values (67,'Бут.580мл',580.000);   
		insert into size(external_id, name, factor ) values (68,'Упаковка 100',100.000);
		insert into size(external_id, name, factor ) values (69,'шт',1.000);            
		insert into size(external_id, name, factor ) values (70,'Пачка 50',50.000);     
		insert into size(external_id, name, factor ) values (71,'80 г',80.000);         
		insert into size(external_id, name, factor ) values (72,'Бут 1,25',1250.000);

		-- journal details
		create sequence seq_journal_details;

		create table journal_details(
			id bigint primary key default nextval('seq_journal_details'),
			external_id int,
			line_id int,
			product_id int,
			dish_id int,
			weight_brutto float,
			amount float,
			range_id int,
			range_amount float,
			ticket_number int,
			size_id int,
			storage_id int
		);
		
		-- trans types
		create sequence seq_trans_types;

		create table trans_types(
			id bigint primary key default nextval('seq_trans_types'),
			external_id int,
			group_id int,
			preview_group_type text,
			description text
		);
		
		insert into trans_types(external_id, group_id, preview_group_type, description) values (14,14,'POS','Rent');                               
		insert into trans_types(external_id, group_id, preview_group_type, description) values (15,15,'POS','Lottery');                            
		insert into trans_types(external_id, group_id, preview_group_type, description) values (101,1,'POS','PLU Sales');                          
		insert into trans_types(external_id, group_id, preview_group_type, description) values (102,1,'POS','Refund');                             
		insert into trans_types(external_id, group_id, preview_group_type, description) values (103,1,'POS','RA');                                 
		insert into trans_types(external_id, group_id, preview_group_type, description) values (104,1,'POS','PO');                                 
		insert into trans_types(external_id, group_id, preview_group_type, description) values (105,1,'POS','Singles');                            
		insert into trans_types(external_id, group_id, preview_group_type, description) values (111,1,'DebitProducts','Списание по себестоимости');
		insert into trans_types(external_id, group_id, preview_group_type, description) values (112,1,'Manufacture','Выпуск готовой продукции');                                                                                                                                          
		insert into trans_types(external_id, group_id, preview_group_type, description) values (201,2,'POS','Payment');                            
		insert into trans_types(external_id, group_id, preview_group_type, description) values (211,2,'POS','Cash');                               
		insert into trans_types(external_id, group_id, preview_group_type, description) values (212,2,'POS','USD');                                
		insert into trans_types(external_id, group_id, preview_group_type, description) values (213,2,'POS','Master Card');                        
		insert into trans_types(external_id, group_id, preview_group_type, description) values (214,2,'POS','Client Card');                        
		insert into trans_types(external_id, group_id, preview_group_type, description) values (215,2,'POS','Debit');                              
		insert into trans_types(external_id, group_id, preview_group_type, description) values (216,2,'POS','Visa');                               
		insert into trans_types(external_id, group_id, preview_group_type, description) values (217,2,'POS','AExspress');                          
		insert into trans_types(external_id, group_id, preview_group_type, description) values (218,2,'POS','Change');                             
		insert into trans_types(external_id, group_id, preview_group_type, description) values (221,2,'POS','$5');                                 
		insert into trans_types(external_id, group_id, preview_group_type, description) values (222,2,'POS','$10');                                
		insert into trans_types(external_id, group_id, preview_group_type, description) values (223,2,'POS','$20');                                
		insert into trans_types(external_id, group_id, preview_group_type, description) values (224,2,'POS','$50');                                
		insert into trans_types(external_id, group_id, preview_group_type, description) values (225,2,'POS','$100');                               
		insert into trans_types(external_id, group_id, preview_group_type, description) values (301,3,'POS','Login');                              
		insert into trans_types(external_id, group_id, preview_group_type, description) values (302,3,'POS','Receipt on/off');                     
		insert into trans_types(external_id, group_id, preview_group_type, description) values (303,3,'POS','Cancel');                             
		insert into trans_types(external_id, group_id, preview_group_type, description) values (304,3,'POS','Void');                               
		insert into trans_types(external_id, group_id, preview_group_type, description) values (305,3,'POS','The End of Day');                     
		insert into trans_types(external_id, group_id, preview_group_type, description) values (306,3,'POS','Exit');                               
		insert into trans_types(external_id, group_id, preview_group_type, description) values (307,3,'POS','Customer ID');                        
		insert into trans_types(external_id, group_id, preview_group_type, description) values (308,3,'POS','Search');                             
		insert into trans_types(external_id, group_id, preview_group_type, description) values (309,3,'POS','Clear');                              
		insert into trans_types(external_id, group_id, preview_group_type, description) values (310,3,'POS','Reports');                            
		insert into trans_types(external_id, group_id, preview_group_type, description) values (311,3,'POS','No Sale');                            
		insert into trans_types(external_id, group_id, preview_group_type, description) values (312,3,'POS','Receipt print');                      
		insert into trans_types(external_id, group_id, preview_group_type, description) values (313,3,'POS','.00');                                
		insert into trans_types(external_id, group_id, preview_group_type, description) values (314,3,'POS','.');                                  
		insert into trans_types(external_id, group_id, preview_group_type, description) values (315,3,'POS','Receipt Not Active');                 
		insert into trans_types(external_id, group_id, preview_group_type, description) values (320,3,'POS','Digits');                             
		insert into trans_types(external_id, group_id, preview_group_type, description) values (330,3,'POS','<-');                                 
		insert into trans_types(external_id, group_id, preview_group_type, description) values (331,3,'POS','->');                                 
		insert into trans_types(external_id, group_id, preview_group_type, description) values (332,3,'POS','esc');                                
		insert into trans_types(external_id, group_id, preview_group_type, description) values (333,3,'POS','Backspace');                          
		insert into trans_types(external_id, group_id, preview_group_type, description) values (334,3,'POS','Delete');                             
		insert into trans_types(external_id, group_id, preview_group_type, description) values (335,3,'POS','Line Up');                            
		insert into trans_types(external_id, group_id, preview_group_type, description) values (336,3,'POS','Line Down');                          
		insert into trans_types(external_id, group_id, preview_group_type, description) values (337,3,'POS','Page Up');                            
		insert into trans_types(external_id, group_id, preview_group_type, description) values (338,3,'POS','Page Down');                          
		insert into trans_types(external_id, group_id, preview_group_type, description) values (339,3,'POS','Menu');                               
		insert into trans_types(external_id, group_id, preview_group_type, description) values (341,3,'POS','Letters');                            
		insert into trans_types(external_id, group_id, preview_group_type, description) values (381,3,'POS','Financial Report');                   
		insert into trans_types(external_id, group_id, preview_group_type, description) values (382,3,'POS','Category  Report');                   
		insert into trans_types(external_id, group_id, preview_group_type, description) values (383,3,'POS','Product   Report');                   
		insert into trans_types(external_id, group_id, preview_group_type, description) values (384,3,'POS','Hourly    Report');                   
		insert into trans_types(external_id, group_id, preview_group_type, description) values (385,3,'POS','Journal   Report');                                                                                                                                                       
		insert into trans_types(external_id, group_id, preview_group_type, description) values (401,4,'POS','Quantity');                           
		insert into trans_types(external_id, group_id, preview_group_type, description) values (402,4,'POS','Hold/Recall');                        
		insert into trans_types(external_id, group_id, preview_group_type, description) values (403,4,'POS','New  Set of Transactions');           
		insert into trans_types(external_id, group_id, preview_group_type, description) values (404,4,'POS','Help');                               
		insert into trans_types(external_id, group_id, preview_group_type, description) values (405,4,'POS','Setup Keyboard');                     
		insert into trans_types(external_id, group_id, preview_group_type, description) values (406,4,'POS','GST Shift');                          
		insert into trans_types(external_id, group_id, preview_group_type, description) values (407,4,'POS','PST Shift');                          
		insert into trans_types(external_id, group_id, preview_group_type, description) values (408,4,'POS','Change');                             
		insert into trans_types(external_id, group_id, preview_group_type, description) values (409,4,'POS','Price');                              
		insert into trans_types(external_id, group_id, preview_group_type, description) values (410,4,'POS','Discount');

		-- pricelist
		create sequence seq_pricelist;

		create table pricelist(
			id bigint primary key default nextval('seq_pricelist'),
			external_id int,
			document_id int,
			cost float,
			group_id int,
			product_id int
		);

		-- vendors groups
		create sequence seq_vendors_groups;

		create table vendors_groups(
			id bigint primary key default nextval('seq_vendors_groups'),
			description text
		);

		insert into vendors_groups(description) values ('Поставщики'), ('Без названия');

		-- employee access
		create sequence seq_employee_access;

		create table employee_access(
			id bigint primary key default nextval('seq_employee_access'),
			external_id int,
			employee_id int,
			object_id int,
			isuse int
		);
	end;
commit;
end $$;
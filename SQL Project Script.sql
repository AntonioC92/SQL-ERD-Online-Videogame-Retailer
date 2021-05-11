#Antonio Caruso's SQL Script 
# Student Number:  19203608
#Submission Date : 20/04/2020
# Project Title: SQL Script for Antonio Caruso Online Videogame Retailer 

# PART B
##1) Creation of the Antonio_Caruso_Online_Videogame_Retailer

CREATE DATABASE Antonio_Caruso_Online_Videogame_Retailer;
USE Antonio_Caruso_Online_Videogame_Retailer;


#2) Creation of Tables 

## Generation of calendar table for year 2019.  Source: Halstead(2012). Available at: https://gist.github.com/bryhal/4129042 

USE Antonio_Caruso_Online_Videogame_Retailer;

DROP TABLE IF EXISTS dates;
CREATE TABLE dates (
idDate INTEGER PRIMARY KEY,
fulldate DATE NOT NULL,
year INTEGER NOT NULL,
month INTEGER NOT NULL,
day INTEGER NOT NULL,
quarter INTEGER NOT NULL,
week INTEGER NOT NULL,
dayOfWeek INTEGER NOT NULL,
weekend INTEGER NOT NULL,
UNIQUE td_ymd_idx (year,month,day),
UNIQUE td_dbdate_idx (fulldate)

) Engine=innoDB;


DROP PROCEDURE IF EXISTS fill_date_dimension;
DELIMITER //
CREATE PROCEDURE fill_date_dimension(IN startdate DATE,IN stopdate DATE)
BEGIN
DECLARE currentdate DATE;
SET currentdate = startdate;
WHILE currentdate < stopdate DO
INSERT INTO dates VALUES (
YEAR(currentdate)*10000+MONTH(currentdate)*100 + DAY(currentdate),
currentdate,
YEAR(currentdate),
MONTH(currentdate),
DAY(currentdate),
QUARTER(currentdate),
WEEKOFYEAR(currentdate),

CASE DAYOFWEEK(currentdate)-1 WHEN 0 THEN 7 ELSE DAYOFWEEK(currentdate)-1 END ,
CASE DAYOFWEEK(currentdate)-1 WHEN 0 THEN 1 WHEN 6 then 1 ELSE 0 END);
SET currentdate = ADDDATE(currentdate,INTERVAL 1 DAY);
END WHILE;
END
//
DELIMITER ;

TRUNCATE TABLE dates;
CALL fill_date_dimension('2019-01-01','2019-12-31');
OPTIMIZE TABLE dates;


## Creation of other tables


CREATE TABLE CustomerDetails
( 
CustomerId VARCHAR(250),
FirstName VARCHAR(250),
LastName VARCHAR(250),
Phone VARCHAR(250),
Email VARCHAR(250),
City VARCHAR(250),
Address VARCHAR(250),
ZipCode VARCHAR(250),
PRIMARY KEY (CustomerId)
);

CREATE TABLE Orders
(
OrderId VARCHAR(250),
CustomerId VARCHAR(250),
OrderStatus VARCHAR (250),
OrderDate VARCHAR(250),
RequiredDate VARCHAR(250),
ShippedDate VARCHAR(250),
GrandTotal DECIMAL (5,2),
PaymentId VARCHAR(250),
PRIMARY KEY (OrderId)
);


CREATE TABLE OrderItems
(
ItemId VARCHAR(250),
OrderId VARCHAR(250),
QuantitySold INT,
Price DECIMAL (3,1),
StockId  VARCHAR(250),
PRIMARY KEY (ItemId)
);

create table Stocks(
	StockId INT,
	Title VARCHAR(46),
	Price DECIMAL(3,1),
	QuantityPurchased INT,
	StockLevel INT,
	SupplierId VARCHAR(250),
    PRIMARY KEY (StockId)
);

CREATE TABLE Suppliers
(
SupplierId VARCHAR(250),
SupplierName VARCHAR(250),
SupplierAddress VARCHAR(250),
SupplierPhone VARCHAR(250),
SupplierEmail VARCHAR(250),
SupplierCity VARCHAR(250),
SupplierZipCode VARCHAR(250),
PRIMARY KEY (SupplierId)
);

CREATE TABLE Payments
(
PaymentId VARCHAR(250),
OrderId VARCHAR(250),
PaymentChannel VARCHAR(250),
PaymentMethod VARCHAR(250),
PaymentStatus VARCHAR(250),
DateOfPayment VARCHAR(250),
GrandTotal DECIMAL (5,2),
PRIMARY KEY (PaymentId)
);


CREATE TABLE Returns
(
ReturnId VARCHAR(250),
ItemId VARCHAR (250),
OrderId VARCHAR(250),
QuantityReturned INT,
RefundAmount DECIMAL (3,1),
PRIMARY KEY (ReturnId)
);

##
#3 Insert Values into tables

INSERT INTO CustomerDetails (CustomerId, FirstName, LastName, Phone, Email, City, Address, ZipCode)
VALUES
 ('Cus01', 'Joe', 'Harrison',   '083-2345988', 'joeharrison@gmail.com',    'Dublin',      'Hill Street-41', 'D042325'),
 ('Cus02', 'Bill', 'Monaghan',  '085-551234', 'billmonaghan@gmail.com',    'Galway',     'Rondan Street-50', 'G043225'), 
 ('Cus03', 'Frank','Paceville', '086-9995823','frankpaceville@outlook.com', 'Cork',      'Galvan Street-32', 'C061334'), 
 ('Cus04', 'Mark','Donell',     '083-08395833', 'markdonell@gmail.com',     'Dublin',    'George’s Street-12', 'D031145'),
 ('Cus05', 'Ciara','Murphy',    '085-22568995', 'ciaramurphy@outlook.com',  'Kildare',     'Cow’s Lane-22', 'K023346'),
 ('Cus06', 'Niamh','Walsh',     '083-09765833', 'niamhwalsh12@gmail.com',   'Dublin',     'Stoneybatter-106', 'D072817'),
 ('Cus07', 'Rosin','McIvor',    '085-09655884', 'rosinmcivor@gmail.com',    'Wexford',    'Cow’s Lane-88', 'W098542'),
 ('Cus08', 'Aine','Fox',        '086-3396419', 'foxaine@outlook.com',       'Dublin',     'Malahide Road-115', 'D022215'),
 ('Cus09', 'Patrick','Lynch',   '086-3072524', 'patricklynch@outlook.com', 'Waterford',   'Lower Baggot St-99', 'P51NV2T'),
 ('Cus10','Declan','Seery',    '086-1216106', 'declanseery33@gmail.com',   'Sligo',      'Capel Street-87', 'F91DFP9'),
 ('Cus11', 'Gary','Kelly',     '085-8305833', 'garykelly5@gmail.com',     'Waterford',  'George’s Street-33', 'P51NV2O'),
 ('Cus12', 'John','Smith',     '083-1913133', 'johnsmith@outlook.com',     'Dublin',      'Moland House-18', 'D083345'),
 ('Cus13', 'Regina','Doyle',   '085-1751154', 'doyleregina@outlook.com',    'Sligo',      'Malahide Road-87', 'F22AFP9'),
 ('Cus14','MaryAnn','McCarthy', '087-6968621', 'maryannmccarthy@gmail.com',  'Dublin',    'Stoneybatter-40', 'D182245'),
 ('Cus15', 'Christina','Kennedy', '087-2800011', 'christinakennedy1@outlook.com', 'Waterford', 'George’s Street-44', 'P51DF2T'),
 ('Cus16', 'Daniel','Murray',     '083-0125744', 'danielmurray@gmail.com',     'Cork',       'Lower Baggot St-28', 'C12Q711A'),
 ('Cus17', 'Hellen','Quinn',     '085-5664221', 'hellenquin@gmail.com',        'Dublin',     'Crown Alley-30', 'D171765'),
 ('Cus18', 'Fiona','Connolly',   '083-6498661', 'fiona.connolly@gmail.com',     'Galway',   'Malahide Road-16', 'G22DR20'),
 ('Cus19', 'Sean','Carroll',    '087-2645156', 'seancarroll.11@outlook.com',    'Dublin',    'Appian Way-50', 'D091992'),
 ('Cus20', 'Conor','Daly',      '087-2848352', 'conor.daly@outlook.com',        'Cork',      'Capel Street-78', 'C039925'),
 ('Cus21', 'Gavin','Dunne',     '087-6878528', 'dunnegavin@outlook.com',        'Wexford',   'Sutton Park-103b', 'P29NV2T'),
 ('Cus22', 'Cian','Wilson',     '087-1042352', 'c.wilson@gmail.com',             'Dublin',   'Stoneybatter-54', 'D064511'),
 ('Cus23', 'Liam','Brennan',    '087-6712755', 'lian.brennan@gmail.com',        'Sligo',     'Moland House-53', 'F91WWE9'),
 ('Cus24', 'Damien','Collins', '086-8146836', 'damiencollins@outlook.com',     'Dublin',     'George’s Street-75', 'D031245'),
 ('Cus25', 'Christian','Clarke', '086-0985833', 'clarkchris@outlook.com',      'Galway',     'Malahide Road-89', 'H53CR20'),
 ('Cus26', 'Cathal','Hughes',    '087-6421878', 'c.hughes@gmail.com',         'Cork',        'Lower Baggot St-111', 'C12N67A'),
 ('Cus27', 'Eoin','Brown',     '087-2739736', 'eoinbrown@outlook.com',        'Wexford',     'Moland House-09', 'Y34Y195'),
 ('Cus28', 'Ciaran','Nolan',   '085-1541317', 'ciaranolan@outlook.com',       'Sligo',       'Crown Alley-10', 'F91FDP9'),
 ('Cus29', 'Brian','Flynn',    '087-4530434', 'brianflynn.8@gmail.com',       'Dublin',      'George’s Street-31', 'D132115'),
 ('Cus30', 'Jennifer','Boyle', '085-08395833', 'jenniferboyle@gmail.com',    'Waterford',    'Capel Street-105', 'W090654');


SELECT * FROM CustomerDetails ORDER BY CustomerId ASC; #To view the values 
##

INSERT INTO Orders(OrderId, CustomerId, OrderStatus, OrderDate, RequiredDate, ShippedDate, GrandTotal, PaymentId)
 VALUES                                                                                       
 ('Ord01',  'Cus01','Completed',   '2019-01-09', '2019-01-16', '2019-01-12', 123.6, 'Pay01'),    
 ('Ord02',  'Cus02','Completed',   '2019-01-15', '2019-01-22', '2019-01-18', 116.3, 'Pay02'),    
 ('Ord03',  'Cus03','Completed',   '2019-01-20', '2019-01-27', '2019-01-23', 183.1, 'Pay03'),   
 ('Ord04',  'Cus04','Completed',   '2019-02-04', '2019-02-11', '2019-02-07', 237.5, 'Pay04'),    
 ('Ord05',  'Cus05','Completed',   '2019-02-07', '2019-02-14', '2019-02-10', 249.0, 'Pay05'),    
 ('Ord06',  'Cus06','Completed',  '2019-02-13', '2019-02-20', '2019-02-16',  240.7, 'Pay06'),    
 ('Ord07',  'Cus07','Completed',  '2019-02-15', '2019-02-22', '2019-02-18',  260.8, 'Pay07'),    
 ('Ord08',  'Cus08','Completed',   '2019-03-06', '2019-03-13', '2019-03-09', 243.5, 'Pay08'),   
 ('Ord09',  'Cus09','Completed',   '2019-03-08', '2019-03-15', '2019-03-11', 339.6, 'Pay09'),   
 ('Ord10', 'Cus10','Completed', '2019-03-17', '2019-03-24', '2019-03-20',  305.9, 'Pay10'),    
 ('Ord11', 'Cus11','Completed', '2019-04-03', '2019-04-10', '2019-04-06',  376.1, 'Pay11'),    
 ('Ord12', 'Cus12','Reviewed',  '2019-04-10', '2019-04-17', '2019-04-13',  263.8, 'Pay12'),    
 ('Ord13', 'Cus13','Completed','2019-05-11', '2019-05-18', '2019-05-14',   385.1, 'Pay13'),     
 ('Ord14', 'Cus14','Completed', '2019-05-24', '2019-05-31', '2019-05-27',  243.2, 'Pay14'),      
 ('Ord15', 'Cus15','Completed', '2019-06-11', '2019-06-18', '2019-06-14',  233.4, 'Pay15'),     
 ('Ord16', 'Cus16','Completed', '2019-06-15', '2019-06-22', '2019-06-18',  167.2, 'Pay16'),      
 ('Ord17', 'Cus17','Completed', '2019-07-04', '2019-07-11', '2019-07-07',  301.2, 'Pay17'),      
 ('Ord18', 'Cus18','Completed', '2019-07-17', '2019-07-24', '2019-07-20',  455.7, 'Pay18'),       
 ('Ord19', 'Cus19','Reviewed',  '2019-07-21', '2019-07-28', '2019-07-24',  255.5, 'Pay19'),       
 ('Ord20', 'Cus20','Completed', '2019-08-05', '2019-08-12', '2019-08-08',  556.7, 'Pay20'),     
 ('Ord21', 'Cus21','Completed', '2019-09-10', '2019-09-17', '2019-09-13',  290.1, 'Pay21'),    
 ('Ord22', 'Cus22','Completed', '2019-09-14', '2019-09-21', '2019-09-17',  302.8, 'Pay22'),      
 ('Ord23', 'Cus23','Completed', '2019-10-03', '2019-10-10', '2019-10-06',  460.3, 'Pay23'),      
 ('Ord24', 'Cus24','Completed', '2019-10-17', '2019-10-24', '2019-10-20',  517.6,  'Pay24'),      
 ('Ord25', 'Cus25','Completed', '2019-11-12', '2019-11-19', '2019-11-15',  513.1,  'Pay25'),      
 ('Ord26', 'Cus26','Completed', '2019-11-20', '2019-11-27', '2019-11-23',  352.9,  'Pay26'),      
 ('Ord27', 'Cus27','Completed', '2019-12-03', '2019-12-10', '2019-12-06',  437.3 , 'Pay27'),     
 ('Ord28', 'Cus28','Completed', '2019-12-05', '2019-12-12', '2019-12-08',  580.9 , 'Pay28'),      
 ('Ord29', 'Cus29','Completed', '2019-12-08', '2019-12-15', '2019-12-11',  588.5 , 'Pay29'),       
 ('Ord30', 'Cus30','Completed', '2019-12-09', '2019-12-16', '2019-12-12',  983.7,  'Pay30') ;  


SELECT * FROM Orders ORDER BY OrderId ASC; #To view the values 
##

INSERT INTO OrderItems(ItemId, OrderId, QuantitySold, Price, StockId)
VALUES
('Fin1',     'Ord01',    1,  50.2,  1),
('Twil2',    'Ord01',    1,  73.4,  2),
('Dist24',   'Ord02',    1,  69.6,  24),
('Light25',  'Ord02',    1,  46.7,  25),
('Tyr43',    'Ord03',    1,  61.2,  43),
('Tri44',    'Ord03',    1,  55.6,  44),
('Cel45',    'Ord03',    1,  66.3,  45),
('Conc63',   'Ord04',    1,  74.2,  63),
('Arm64',    'Ord04',    1,  62.2,  64),
('Putr65',   'Ord04',    1,  53.2,  65),
('Danc85',   'Ord04',    1,  47.9,  85),
('Thlig192', 'Ord05',    1,  48.5,  192),
('Pro202',   'Ord05',    1,  57.9,  202),
('Fer172',   'Ord05',    1,  69.8,  172),
('Soli161',  'Ord05',    1,  72.8,  161),
('Sku290',   'Ord06',    1,  61.5,  290),
('Ete305',   'Ord06',    1,  74.7,  305),
('Nigh279',  'Ord06',    1,  45.3,  279),
('Ear260',   'Ord06',    1,  59.3,  260),
('Orb373',   'Ord07',    1,  74.3,  373),
('Fort398',  'Ord07',    1,  65.0,  398),
('Mace226',  'Ord07',    1,  56.5,  226), 
('Lia420',   'Ord07',    1,  53.1,  420),
('Amn539',   'Ord08',    1,  74.5,  539),
('Prom530',  'Ord08',    1,  49.8,  530),
('Nightm511','Ord08',    1,  63.9,  511),
('Mour492',  'Ord08',    1,  55.3,  492),
('Cat12',    'Ord09',    1,  70.3,  12),
('Wil612',   'Ord09',    1,  64.3,  612),
('Hate677',  'Ord09',    1,  68.0,  677),
('Corr702',  'Ord09',    1,  71.0,  702),
('Come466',  'Ord09',    1,  66.0,  466),
('Bloo981',  'Ord10',   1,  59.9,  981),
('End982',   'Ord10',   1,  72.5,  982),
('Howl990',  'Ord10',   1,  61.4,  990),
('Nima959',  'Ord10',   1,  49.6,  959),
('Wor949',   'Ord10',   1,  66.5,  949),
('War1000',  'Ord11',   1,  60.1,  1000),
('World999', 'Ord11',   1,  72.9,  999),
('Cele998',  'Ord11',   1,  66.1,  998),
('Curv997',  'Ord11',   1,  62.1,  997),
('Veng996',  'Ord11',   1,  67.7,  996),
('Brut984',  'Ord11',   1,  47.2,  984),
('Andu50',   'Ord12',   1,  54.7,  50),
('Dev38',    'Ord12',   1,  57.7,  38),
('TheCha29', 'Ord12',   1,  52.3,  29),
('Thun30',   'Ord12',   1,  51.5,  30),
('Stor60',   'Ord12',   1,  47.6,  60),
('Prim107',  'Ord13',   1,  48.8,  107),
('Brutal110','Ord13',   1,  51.0,  110),
('Skate833', 'Ord13',   1,  72.9,  833),  
('Gho262',   'Ord13',   1,  49.6,  262),
('TheEnd240','Ord13',   1,  63.8,  240),
('Drago300', 'Ord13',   1,  72.2,  300), 
('Rit501',   'Ord13',   1,  51.2,  501),
('Stormg16', 'Ord14',   1,  54.3,  16),
('TheM135',  'Ord14',   1,  48.6,  135), 
('TheOc',    'Ord14',   1,  46.7,  14),
('Bald20',   'Ord14',   1,  73.4,  20),
('Exte84',   'Ord15',   1,  67.2,  84),
('DancIr85', 'Ord15',   1,  47.9,  85),
('Pri40',    'Ord15',   1,  55.3,  40),
('Mend41',   'Ord15',   1,  63.0,  41),
('Conv35',   'Ord16',   1,  63.7,  35),
('TheLig36', 'Ord16',   1,  47.5,  36),
('Conve37',  'Ord16',   1,  56.0,  37),
('Death385', 'Ord17',   1,  67.7,  385),
('Barb386',  'Ord17',   1,  51.5,  386),
('Inter387', 'Ord17',   1,  46.3,  387),
('Enl371',   'Ord17',   1,  66.5,  371),
('Ghostl372','Ord17',   1,  69.2,  372),
('Mal456',   'Ord18',   1,  46.8,  456),
('Cry457',   'Ord18',   1,  55.8,  457),
('Harm458',  'Ord18',   1,  53.6,  458),
('Retri479', 'Ord18',   1,  62.7,  479),
('Hell480',  'Ord18',   1,  73.8,  480),
('Chan481',  'Ord18',   1,  62.9,  481),
('Ox469',    'Ord18',   1,  53.5,  469),
('Sold445',  'Ord18',   1,  46.4,  445),
('Betr610',  'Ord19',   1,  70.6,  610),
('Sorr611',  'Ord19',   1,  64.5,  611),
('Liarsk615','Ord19',   1,  59.5,  615),
('Final620', 'Ord19',   1,  60.9,  620),
('Ritl751',  'Ord20',   1,  57.5,  751),
('Promib752','Ord20',   1,  70.4,  752),
('Theat753', 'Ord20',   1,  53.0,  753),
('FalSt754', 'Ord20',   1,  56.2,  754),
('Concoa777', 'Ord20',  1,  54.7,  777),
('Twili800',  'Ord20',  1,  71.9,  800),
('Thir900',   'Ord20',  1,  65.9,  900),
('Ghola901',  'Ord20',  1,  58.9,  901),
('Frost129',  'Ord21',  1,  55.6,  129), 
('Conquer296','Ord21',  1,  54.5,  296),
('Flam297',   'Ord21',  1,  55.4,  297),
('Maliw280',  'Ord21',  1,  60.5,  280),
('Rele314',   'Ord21',  1,  47.5,  314),
('Fai422',    'Ord22',  1,  51.9,  422),
('Catacl430', 'Ord22',  1,  58.3,  430),
('Knig408',   'Ord22',  1,  74.9,  408),
('Inf399',    'Ord22',  1,  66.1,  399),
('Und367',    'Ord22',  1,  51.6,  367),
('Rei97',     'Ord23',  1,  59.6,  97),
('Barb101',   'Ord23',  1,  50.9,  101),
('Lig102',    'Ord23',  1,  57.1,  102),
('Curvsn103', 'Ord23',  1,  45.2,  103),
('Desp104',   'Ord23',  1,  62.2,  104),
('Malwhi105', 'Ord23',  1,  68.0,  105),
('Finalit106','Ord23',  1,  62.1,  106),
('ThunderR39','Ord23',  1,  56.2,   39),
('Deci14',    'Ord24',  1,  64.8,   14),
('Pen13',     'Ord24',  1,  71.5,   13),
('CataR12',   'Ord24',  1,  70.3,   12),
('Rag11',     'Ord24',  1,  63.2,   11),
('Bloodr10',  'Ord24',  1,  52.8,   10),
('Blor9',     'Ord24',  1,  69.5,    9),
('Promisn8',  'Ord24',  1,  51.1,    8),
('Primsn107', 'Ord24',  1,  48.8,  107),
('Seren3'   , 'Ord25',  1,  62.5,    3),
('Destfer4' , 'Ord25',  1,  73.5,    4),
('Magm5',     'Ord25',  1,  69.6,    5),
('Cod6',      'Ord25',  1,  66.2,    6),
('TheOcp19',  'Ord25',  1,  46.7,   19),
('Catasi18',  'Ord25',  1,  70.5,   18),
('Morn17',    'Ord25',  1,  68.8,   17),
('Zea169',    'Ord25',  1,  49.8,  169), 
('Willbr231', 'Ord26',  1,  58.1,  231),
('Desi232',   'Ord26',  1,  52.9,  232),
('Blofo233',  'Ord26',  1,  72.8,  233),
('Comheir234','Ord26',  1,  54.4,  234),
('Redwar179', 'Ord26',  1,  53.5,  179), 
('Van241',    'Ord26',  1,  50.9,  241),
('Wamo250',   'Ord27',  1,  57.1,  250),
('Blogo251',  'Ord27',  1,  60.7,  251),
('Wacro252',  'Ord27',  1,  72.8,  252),
('Brugra253', 'Ord27',  1,  60.2,  253),
('Dola254',   'Ord27',  1,  72.9,  254),
('Hobe255',   'Ord27',  1,  64.0,  255),
('Trit340',   'Ord27',  1,  49.6,  340),
('Destru335', 'Ord28',  1,  48.7,  335),
('Battbro336','Ord28',  1,  54.6,  336),
('Infvo337',  'Ord28',  1,  49.8,  337),
('Treach338', 'Ord28',  1,  46.9,  338),
('Mendw339',  'Ord28',  1,  68.9,  339),
('Yea182',    'Ord28',  1,  73.6,  182),
('Jackl341',  'Ord28',  1,  65.8,  341),
('Enchla342', 'Ord28',  1,  52.7,  342),
('Lastrea343','Ord28',  1,  71.1,  343),
('Wrairo344', 'Ord28',  1,  68.3,  344),
('Wragi347',  'Ord29',  1,  46.7,  347),
('Retrigi348','Ord29',  1,  53.5,  348),
('Domla349',  'Ord29',  1,  68.5,  349),
('Falle350',  'Ord29',  1,  60.5,  350),
('Twita351',  'Ord29',  1,  68.7,  351),
('VengeW352', 'Ord29',  1,  58.2,  352),
('Flabe353',  'Ord29',  1,  60.0,  353),
('Cawrai354', 'Ord29',  1,  71.2,  354),
('Sunho355',  'Ord29',  1,  52.8,  355),
('Extgua356', 'Ord29',  1,  48.4,  356),
('Domina360', 'Ord29',  1,  64.7,  360),
('Thula361',  'Ord29',  1,  56.7,  361),
('Godcru400', 'Ord30',  1,  74.2,  400),
('Lubo401',   'Ord30',  1,  67.8,  401),
('Def402',    'Ord30',  1,  68.4,  402), 
('Mad403',    'Ord30',  1,  58.8,  403),
('Faple404',  'Ord30',  1,  71.8,  404),
('Whibe405',  'Ord30',  1,  45.1,  405),
('Deso406',   'Ord30',  1,  60.9,  406),
('Rageb407',  'Ord30',  1,  65.6,  407),
('KnighCh408','Ord30',  1,  74.9,  408),
('Corla409',  'Ord30',  1,  72.6,  409),
('Granta410', 'Ord30',  1,  54.8,  410),
('Sucpu249',  'Ord30',  1,  52.3,  249),
('Celco998',  'Ord30',  1,  66.1,  998),
('Cursnr997', 'Ord30',  1,  62.1,  997),
('Vengwr996', 'Ord30',  1,  67.7,  996);

SELECT * FROM OrderItems ORDER BY OrderId ASC; # To View the values


##
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (1, 'Finality', 50.2, 57, 80, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (2, 'Twilight Wire', 73.4, 53, 61, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (3, 'Serenity, Destroyer of Woe', 62.5, 68, 146, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (4, 'Destiny, Ferocity of the Lion', 73.5, 41, 151, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (5, 'Magma', 69.6, 38, 174, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (6, 'Call of Duty: Modern Warfare 2', 66.2, 72, 89, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (7, 'Ferocious Obsidian Snare', 74.4, 55, 162, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (8, 'Promised Snare', 51.1, 46, 148, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (9, 'Bloodied Riata', 69.5, 44, 71, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (10, 'Bloodrage', 52.8, 44, 127, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (11, 'Rage, Boon of the Serpent', 63.2, 53, 177, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (12, 'Cataclysm, Riata of Wraiths', 70.3, 61, 145, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (13, 'Pendulum, Betrayer of the Light', 71.5, 81, 131, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (14, 'Decimation, Token of the East', 64.8, 80, 143, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (15, 'Sorrow''s Ironbark Whip', 72.5, 72, 107, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (16, 'Stormguard Snare', 54.3, 83, 129, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (17, 'Morningstar', 68.8, 80, 169, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (18, 'Cataclysmic Silver Snare', 70.5, 76, 85, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (19, 'The Oculus, Piercer of Lost Hope', 46.7, 35, 124, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (20, 'Baldur''s Gate II: Shadows of Amn', 73.4, 68, 144, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (21, 'Zealous Titanium Snare', 63.5, 40, 63, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (22, 'Zealous Wire', 66.3, 89, 106, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (23, 'Homage, Slayer of the Oracle', 70.6, 89, 180, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (24, 'Disturbance', 69.6, 52, 155, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (25, 'Lightning Adamantite Wire', 46.7, 53, 98, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (26, 'Trinity', 66.9, 50, 141, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (27, 'Military Riata', 74.2, 86, 171, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (28, 'Flimsy Steel Snare', 57.4, 52, 60, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (29, 'The Chancellor', 52.3, 30, 93, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (30, 'Thunder-Forged Belt', 51.5, 63, 111, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (31, 'Ghost Skeletal Whip', 62.5, 65, 116, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (32, 'Lightbane, Reaper of Magic', 48.6, 84, 86, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (33, 'Valkyrie, Conqueror of the Damned', 60.0, 61, 91, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (34, 'Trauma, Riata of the Harvest', 68.3, 57, 174, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (35, 'Convergence', 63.7, 66, 125, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (36, 'The Light, Tribute of Honor2', 47.5, 85, 115, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (37, 'Convergence, Last Hope of the Forgotten', 56.0, 89, 145, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (38, 'Devastation, Breaker of Fury', 57.7, 58, 90, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (39, 'Thunder, Reaper of Eternity', 56.2, 35, 168, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (40, 'Pride', 55.3, 43, 128, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (41, 'Mended Riata', 63.0, 33, 154, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (42, 'Trauma, Riata of the Harvest', 58.7, 40, 162, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (43, 'Tyrannical Skeletal Riata', 61.2, 56, 169, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (44, 'Trinity', 55.6, 37, 147, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (45, 'Celeste, Conqueror of Desecration', 66.3, 30, 96, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (46, 'Thirsty Iron Crop', 73.2, 53, 180, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (47, 'Oblivion, Reach of Perdition', 56.8, 76, 129, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (48, 'Skullcrusher, Last Hope of the Dreadlord', 63.3, 51, 149, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (49, 'Twilight''s Ivory Snare', 63.8, 74, 137, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (50, 'Anduril, Reaper of Burdens', 54.7, 80, 150, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (51, 'Desire''s Adamantite Whip', 45.4, 46, 145, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (52, 'Tenderiser, Terror of Blight', 57.0, 47, 132, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (53, 'Fusion Lariat', 61.9, 30, 82, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (54, 'Witherbrand', 72.6, 64, 123, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (55, 'Apocalypse', 61.4, 81, 78, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (56, 'Sentinel Snare', 55.2, 63, 135, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (57, 'King''s Legacy, Ferocity of Power', 63.5, 74, 114, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (58, 'Blood-Forged Whip', 65.8, 37, 179, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (59, 'Remorseful Whip', 50.1, 34, 67, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (60, 'Storm, Slayer of Blight', 47.6, 49, 64, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (61, 'Enigma', 67.8, 39, 166, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (62, 'Chaos, Ravager of the Oracle', 49.1, 41, 87, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (63, 'Concussion, Crusader of Pride''s Fall', 74.2, 65, 130, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (64, 'Armageddon', 62.2, 84, 120, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (65, 'Putrid Bronze Lash', 53.2, 44, 65, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (66, 'Singing Skeletal Wire', 68.3, 65, 177, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (67, 'Enlightened Riata', 53.8, 55, 128, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (68, 'Convergence', 45.2, 77, 170, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (69, 'Madden NFL 2003', 50.6, 68, 124, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (70, 'Frostwind, Snare of the Gladiator', 51.7, 38, 68, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (71, 'Portal 2', 67.1, 71, 127, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (72, 'Homage, Conqueror of Assassins', 53.5, 53, 101, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (73, 'Swan Song, Defiler of Vengeance', 71.4, 46, 74, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (74, 'Apocalyptic Ironbark Crop', 54.3, 45, 67, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (75, 'The Sundering', 62.4, 54, 109, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (76, 'Primitive Bronzed Lash', 68.1, 81, 166, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (77, 'Frostwind, Etcher of the Empty Void', 66.0, 83, 66, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (78, 'LittleBigPlanet', 65.7, 60, 165, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (79, 'Bloodvenom Snare', 72.9, 54, 62, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (80, 'Prime Belt', 72.7, 88, 110, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (81, 'Bonesnapper, Call of Darkness', 58.3, 45, 121, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (82, 'Silence', 62.5, 54, 78, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (83, 'Stormguard Lariat', 55.7, 73, 178, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (84, 'Extermination', 67.2, 64, 106, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (85, 'Dancing Ironbark Snare', 47.9, 35, 78, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (86, 'Cyclone, Whip of Power', 73.7, 82, 122, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (87, 'Gladiator Lash', 57.2, 58, 143, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (88, 'Celeste, Soul of the Protector', 63.5, 44, 61, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (89, 'Thunderfury Ivory Crop', 70.8, 37, 113, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (90, 'Faithkeeper, Might of the Oracle', 58.2, 81, 164, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (91, 'Battlestar, Dawn of Pride', 67.6, 89, 99, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (92, 'Dawnbreaker, Oath of Phantoms', 63.7, 61, 98, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (93, 'Tremor, Memory of Time-Lost Memories', 46.3, 80, 140, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (94, 'Vicious Whip', 55.6, 46, 167, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (95, 'Cyclone, Whip of Power', 60.0, 56, 88, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (96, 'Eveningstar', 69.9, 43, 111, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (97, 'Reign, Reaper of the Forgotten', 59.6, 86, 138, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (98, 'Engraved Gilded Snare', 63.4, 54, 119, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (99, 'Crying Bone Lash', 47.3, 67, 81, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (100, 'Winter''s Bite, Pledge of the Damned', 48.1, 36, 124, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (101, 'Barbarian Lash', 50.9, 65, 162, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (102, 'Lightning', 57.1, 74, 112, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (103, 'Curved Snare2', 45.2, 83, 66, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (104, 'Despair', 62.2, 65, 114, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (105, 'Malificent Whip2', 68.0, 81, 106, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (106, 'Finality', 62.1, 72, 107, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (107, 'Primitive Snare', 48.8, 37, 146, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (108, 'Thunderfury Ivory Crop', 53.1, 44, 113, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (109, 'Reign, Slayer of the Cataclysm', 74.0, 54, 140, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (110, 'Brutalizer', 51.0, 79, 168, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (111, 'Nightfall', 49.8, 36, 123, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (112, 'Dawnbreaker, Oath of Phantoms', 73.7, 30, 178, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (113, 'Cataclysm Iron Wire', 66.8, 34, 154, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (114, 'Corpsemaker, Token of Putrefaction', 52.9, 68, 147, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (115, 'Shamanic Silver Lariat', 52.5, 84, 122, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (116, 'Nighttime, Might of the Emperor', 48.5, 45, 72, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (117, 'Inherited Steel Wire', 61.9, 61, 162, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (118, 'Spectral Skeletal Wire', 73.1, 59, 118, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (119, 'Baneful Riata', 55.2, 42, 139, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (120, 'Sorrow''s Wire', 55.3, 82, 130, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (121, 'Flimsy Steel Snare', 55.4, 34, 173, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (122, 'Extinction, Guardian of Degradation', 46.9, 70, 95, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (123, 'Termination, Last Stand of the East', 64.9, 45, 118, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (124, 'Honor''s Call', 69.7, 77, 130, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (125, 'Reckoning', 53.8, 45, 149, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (126, 'Promised Belt', 53.8, 44, 171, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (127, 'Back Breaker, Executioner of the Burning Sun', 56.1, 81, 64, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (128, 'Enlightened Riata', 66.6, 74, 149, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (129, 'Frostwind, Annihilation of the Caged Mind', 55.6, 61, 121, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (130, 'Misery''s End, Memory of the Banished', 55.6, 66, 92, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (131, 'Heartcrusher, Betrayer of Twilight''s End', 54.3, 54, 154, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (132, 'Thundersoul Obsidian Wire', 49.5, 40, 108, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (133, 'Champion''s Gilded Belt', 57.0, 81, 172, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (134, 'Solitude''s Belt', 69.4, 40, 109, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (135, 'The Minotaur', 48.6, 30, 94, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (136, 'Harmonized Belt', 58.2, 89, 123, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (137, 'Blazefury Belt', 58.9, 63, 133, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (138, 'Ghost Titanium Lariat', 62.2, 63, 167, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (139, 'Frostsmash', 51.4, 54, 153, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (140, 'Shadow Lasso', 55.8, 52, 123, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (141, 'Soul Infused Golden Crop', 46.7, 44, 85, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (142, 'Primitive Snare', 66.4, 38, 141, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (143, 'Stonefist', 53.9, 82, 153, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (144, 'Ghastly Lasso', 68.0, 41, 154, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (145, 'Brutality', 72.2, 53, 77, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (146, 'Primal Bronzed Snare', 62.0, 47, 100, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (147, 'Acrid Steel', 66.7, 40, 104, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (148, 'Agony', 49.5, 85, 171, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (149, 'Peacekeeper, Reaper of the Phoenix', 65.2, 50, 180, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (150, 'Crash, Betrayer of Fools', 60.3, 39, 62, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (151, 'Due Diligence, Executioner of Magic', 69.2, 72, 118, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (152, 'Thundersoul Wire', 65.1, 81, 108, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (153, 'Thunder Titanium Whip', 74.1, 85, 77, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (154, 'Gladiator Lash', 50.4, 60, 113, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (155, 'Ghost Titanium Lariat', 55.7, 72, 97, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (156, 'Storm, Slayer of Blight', 52.4, 80, 63, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (157, 'Lazarus', 56.5, 39, 111, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (158, 'The Light, Tribute of Honor', 60.1, 68, 158, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (159, 'Replica Ironbark Belt', 55.9, 62, 165, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (160, 'Retirement, Guardian of Shadows', 71.3, 66, 164, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (161, 'Solitude''s Belt', 72.8, 40, 83, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (162, 'Barbarian Lash', 67.8, 84, 168, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (163, 'Conqueror''s Lasso', 49.6, 63, 124, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (164, 'Warlord''s Crop', 70.6, 34, 81, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (165, 'Wretched Belt', 65.4, 69, 171, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (166, 'Trauma, Breaker of the Covenant', 55.4, 40, 80, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (167, 'The Minotaur', 56.4, 88, 114, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (168, 'Knight''s Fall', 61.3, 63, 105, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (169, 'Zealous Titanium Snare', 49.8, 81, 144, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (170, 'Stormguard Snare', 55.4, 86, 150, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (171, 'Magma, Breaker of Timeless Battles', 52.7, 30, 154, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (172, 'Ferocious Lariat', 69.8, 68, 80, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (173, 'Final Fantasy IX', 50.4, 86, 117, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (174, 'Endbringer', 47.6, 81, 144, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (175, 'Peacekeeper Steel Riata', 73.0, 90, 162, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (176, 'The Light, Tribute of Honor', 65.9, 48, 86, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (177, 'Faithkeeper', 71.8, 47, 158, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (178, 'Headache', 48.3, 74, 117, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (179, 'Red Dwarf', 53.5, 81, 148, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (180, 'Brutalizer', 64.4, 45, 72, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (181, 'Prime Belt', 57.9, 57, 134, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (182, 'Yearning Glass Whip', 73.6, 30, 144, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (183, 'Banished Ebon Wire', 70.4, 46, 145, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (184, 'Defender Whip', 46.3, 67, 120, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (185, 'Putrid Steel Riata', 64.8, 62, 130, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (186, 'Wicked', 58.6, 83, 120, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (187, 'Broken Metal', 65.5, 67, 162, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (188, 'Earthwarden, Lasso of Mystery', 64.7, 71, 137, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (189, 'The Minotaur, Call of Lost Voices', 58.9, 49, 142, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (190, 'Red Dwarf, Memory of the Light', 57.4, 90, 145, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (191, 'The Minotaur, Call of Lost Voices', 50.4, 45, 78, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (192, 'The Light, Tribute of Honor', 48.5, 90, 75, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (193, 'Twilight''s Golden Wire', 58.4, 77, 172, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (194, 'Storm', 48.5, 85, 176, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (195, 'Broken Metal', 71.5, 72, 69, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (196, 'Primitive Mithril Wire', 57.0, 69, 173, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (197, 'Devotion, Voice of Ending Hope', 58.5, 85, 157, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (198, 'The Minotaur, Call of Lost Voices', 50.4, 73, 148, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (199, 'Arched Titanium Lariat', 69.5, 69, 82, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (200, 'Morningstar', 49.3, 42, 139, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (201, 'Lightning Adamantite Wire', 68.5, 38, 92, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (202, 'Prophecy, Reaper of Pride''s Fall', 57.9, 67, 148, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (203, 'Celeste, Soul of the Protector', 45.4, 31, 65, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (204, 'Malice, Whisper of Eternal Struggles', 53.9, 89, 180, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (205, 'Knightly Obsidian Whip', 48.0, 77, 126, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (206, 'Convergence, Whisper of Shifting Sands', 70.4, 89, 64, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (207, 'Singing Bone Snare', 73.2, 67, 64, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (208, 'Convergence', 67.5, 83, 140, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (209, 'Trauma', 67.6, 38, 135, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (210, 'Trinity', 50.2, 84, 155, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (211, 'Knightfall, Champion of the Sky', 51.4, 58, 126, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (212, 'Dragonstrike, Call of Mountains', 56.3, 49, 94, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (213, 'Light''s Bane, Wire of the Prince', 59.6, 50, 144, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (214, 'Bulletzone', 53.0, 52, 158, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (215, 'Savage Belt', 67.1, 51, 168, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (216, 'King''s Defender, Pledge of the West', 62.7, 88, 135, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (217, 'Harmonized Belt', 62.1, 89, 169, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (218, 'Nightmare Lash', 62.4, 80, 160, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (219, 'The Ambassador', 71.4, 80, 167, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (220, 'Nightmare, Lash of Oblivion', 58.4, 85, 90, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (221, 'Red Dwarf, Memory of the Light', 61.7, 61, 110, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (222, 'Soul Infused Golden Crop', 48.8, 83, 148, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (223, 'Mended Wire', 54.9, 51, 132, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (224, 'Victor Lasso', 66.5, 33, 108, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (225, 'Crush, Conqueror of Dark Souls', 72.6, 36, 70, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (226, 'Macerator, Lasso of Shifting Sands', 56.5, 40, 72, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (227, 'Pride, Soul of Fallen Souls', 49.3, 42, 174, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (228, 'Madden NFL 2003', 54.8, 64, 86, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (229, 'Shooting Star', 74.6, 38, 80, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (230, 'Malevolent Snare', 51.5, 55, 122, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (231, 'Willbreaker2', 58.1, 49, 63, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (232, 'Desire''s Golden Lash', 52.9, 65, 170, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (233, 'Blood-Forged Golden Snare', 72.8, 37, 106, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (234, 'Cometfall, Heirloom of Heroes', 54.4, 80, 117, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (235, 'Prophecy, Reaper of Pride''s Fall', 54.2, 43, 112, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (236, 'Zealous Wire', 63.1, 88, 83, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (237, 'Guiding Star, Piercer of Lost Hope', 53.0, 79, 81, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (238, 'War Snare', 59.2, 64, 69, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (239, 'Putrid Bronze Lash', 67.8, 75, 93, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (240, 'The End', 63.8, 89, 131, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (241, 'Vanquisher', 50.9, 62, 113, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (242, 'Eternal Rest', 50.0, 51, 134, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (243, 'Cryptmaker, Favor of the Immortal', 75.0, 74, 120, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (244, 'Halo 2', 50.5, 84, 91, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (245, 'Last Rites, Vengeance of Hatred', 46.0, 83, 113, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (246, 'Silent Whip', 63.5, 46, 70, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (247, 'Hollow Lariat', 69.1, 39, 83, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (248, 'Retirement', 56.4, 69, 160, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (249, 'Sucker Punch', 52.3, 64, 109, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (250, 'Warmonger', 57.1, 89, 156, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (251, 'Blood-Forged Golden Snare', 60.7, 71, 63, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (252, 'Warlord''s Crop', 72.8, 80, 125, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (253, 'Brutalizer, Riata of Degradation', 60.2, 37, 94, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (254, 'Doom Bronze Lasso', 72.9, 64, 76, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (255, 'Hope''s Belt', 64.0, 37, 158, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (256, 'Grimace', 61.7, 30, 84, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (257, 'Blood-Forged Whip', 67.9, 82, 114, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (258, 'Hopeless Crop', 47.9, 61, 74, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (259, 'Lightning Adamantite Wire', 57.0, 43, 172, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (260, 'Earthwarden', 59.3, 83, 150, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (261, 'Shamanic Lariat', 50.5, 78, 131, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (262, 'Ghost Mithril Snare', 49.6, 73, 117, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (263, 'Cold-Forged Silver Lariat', 63.6, 53, 138, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (264, 'Ghostwalker', 61.6, 68, 103, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (265, 'Guardian''s Ebon Snare', 67.8, 65, 79, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (266, 'Silence, Cry of the East', 58.0, 88, 179, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (267, 'Spinefall, Hope of Decay', 62.7, 40, 82, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (268, 'Amnesia', 62.2, 40, 91, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (269, 'Challenger''s Bronzed Lash', 71.3, 77, 133, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (270, 'Exiled Whip', 65.1, 87, 64, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (271, 'Dragonstrike, Lariat of Putrefaction', 73.8, 42, 70, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (272, 'Corrupted Belt', 60.0, 62, 91, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (273, 'Galaxy', 70.5, 90, 65, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (274, 'Soul Ironbark Whip', 55.0, 42, 153, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (275, 'Ferocious Lariat', 60.5, 41, 155, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (276, 'Spectral-Forged Whip', 59.7, 72, 116, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (277, 'Stormherald, Boon of the Queen', 50.5, 74, 165, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (278, 'Firesoul Lasso', 67.1, 42, 83, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (279, 'Nightfall', 45.3, 68, 102, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (280, 'Malificent Whip', 60.5, 46, 72, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (281, 'Typhoon, Conqueror of Eternal Rest', 67.2, 42, 162, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (282, 'Cataclysm, Breaker of Storms', 61.8, 74, 145, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (283, 'Morningstar', 52.5, 58, 150, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (284, 'Harmonized Bone Lariat', 62.8, 77, 129, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (285, 'Final Fantasy IX', 46.1, 90, 107, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (286, 'Hailstorm Mithril Whip', 50.8, 41, 101, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (287, 'Spectral Iron Riata', 61.0, 32, 119, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (288, 'Atuned Skeletal Snare', 50.2, 35, 148, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (289, 'Fireguard Belt', 70.1, 74, 92, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (290, 'Skullcrusher, Wit of the Falling Sky', 61.5, 83, 107, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (291, 'Twilight''s Belt', 54.2, 52, 123, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (292, 'Exiled Belt', 53.7, 65, 84, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (293, 'Heartcrusher', 69.6, 39, 125, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (294, 'Devotion, Pledge of the Basilisk', 56.9, 81, 106, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (295, 'Wicked Mithril Lasso', 51.6, 30, 150, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (296, 'Conqueror''s Silver Crop', 54.5, 74, 97, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (297, 'Flaming Obsidian Crop', 55.4, 62, 158, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (298, 'Stormcaller', 53.8, 33, 133, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (299, 'Kinslayer', 53.9, 36, 139, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (300, 'Dragonmaw', 72.2, 57, 161, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (301, 'Cataclysmic Obsidian Riata', 72.2, 53, 108, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (302, 'Battleworn Bronze Riata', 57.2, 61, 75, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (303, 'Harmony, Tribute of Misery', 53.6, 81, 135, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (304, 'King''s Defender, Defiler of Putrefaction', 61.0, 52, 113, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (305, 'Eternal Rest', 74.7, 77, 110, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (306, 'Silence, Cry of the East', 59.3, 39, 79, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (307, 'Flaming Obsidian Crop', 52.3, 44, 115, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (308, 'Skullcrusher, Belt of Timeless Battles', 74.2, 79, 141, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (309, 'Guiding Star, Heirloom of the Covenant', 65.9, 55, 160, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (310, 'Cyclone', 61.4, 41, 72, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (311, 'Chieftain', 74.4, 50, 177, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (312, 'Bloodrage, Cunning of Shadow Strikes', 52.5, 30, 169, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (313, 'Twilight Iron Whip', 60.6, 63, 98, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (314, 'Relentless Obsidian Belt', 47.5, 83, 125, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (315, 'Barbarian Titanium Crop', 64.6, 62, 104, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (316, 'Trainee''s Iron Crop', 57.1, 72, 109, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (317, 'Reign, Reaper of the Forgotten', 49.6, 59, 74, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (318, 'The Sundering, Betrayer of Ashes', 66.8, 31, 124, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (319, 'Mended Whip', 46.8, 35, 130, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (320, 'World of Goo', 60.7, 85, 158, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (321, 'Putrid Bronze Lash', 49.2, 36, 61, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (322, 'Old Age', 59.9, 49, 149, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (323, 'Frostsmash', 48.7, 34, 77, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (324, 'Galaxy, Wire of Mystery', 50.4, 54, 121, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (325, 'Twilight''s Ivory Snare', 66.1, 40, 151, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (326, 'Remorseful Whip', 59.7, 87, 168, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (327, 'Ghastly Lasso', 68.3, 81, 85, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (328, 'Pure Wire', 55.9, 72, 144, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (329, 'Hurricane', 56.1, 50, 171, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (330, 'Ashes', 62.3, 41, 180, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (331, 'Ghost Snare', 65.3, 73, 171, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (332, 'Fortune''s Lasso', 74.1, 84, 180, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (333, 'Cyclone, Whip of Power', 45.2, 34, 132, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (334, 'Echo, Snare of the Earth', 51.2, 45, 135, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (335, 'Destruction', 48.7, 46, 138, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (336, 'Battleworn Bronze Riata', 54.6, 54, 103, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (337, 'Infinity, Voice of the Lasting Night', 49.8, 84, 142, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (338, 'Treachery''s Ironbark Wire', 46.9, 74, 66, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (339, 'Mended Wire', 68.9, 87, 135, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (340, 'Trinity2', 49.6, 54, 102, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (341, 'Jackhammer, Last Stand of the Harvest', 65.8, 40, 68, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (342, 'Enchanted Lasso', 52.7, 41, 138, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (343, 'Last Chance, Reaper of the Lone Wolf', 71.1, 49, 113, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (344, 'Wrathful Ironbark Lariat', 68.3, 83, 139, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (345, 'Vacancy', 46.2, 33, 143, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (346, 'The Light, Cunning of the Depth', 55.7, 69, 143, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (347, 'Wrathful Gilded Whip', 46.7, 41, 122, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (348, 'Retribution Gilded Lasso', 53.5, 67, 178, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (349, 'Doom Bronze Lasso2', 68.5, 49, 98, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (350, 'Falling Star, Legacy of Lost Voices', 60.5, 37, 90, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (351, 'Twilight''s Steel Riata2', 68.7, 37, 87, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (352, 'Vengeful Wire', 58.2, 34, 142, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (353, 'Flaming Belt', 60.0, 32, 89, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (354, 'Cataclysm, Riata of Wraiths', 71.2, 79, 82, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (355, 'Sundown, Hope of Timeless Battles', 52.8, 63, 167, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (356, 'Extinction, Guardian of Degradation', 48.4, 65, 73, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (357, 'Devourer', 67.3, 72, 96, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (358, 'Refined Wire', 53.0, 67, 118, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (359, 'Dawnbreaker, Slayer of Subtlety', 64.0, 57, 140, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (360, 'Dominance', 64.7, 37, 83, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (361, 'Thunderstorm Lasso', 56.7, 42, 132, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (362, 'The Ambassador, Cunning of Grace', 50.6, 90, 128, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (363, 'Corrupted Gilded Lariat', 63.6, 71, 165, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (364, 'Wolf', 72.2, 60, 88, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (365, 'Nightbane', 52.6, 60, 96, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (366, 'Swan Song, Defiler of Vengeance', 61.1, 64, 166, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (367, 'Undoing', 51.6, 79, 168, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (368, 'Last Chance, Defender of Frozen Hells', 68.3, 62, 157, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (369, 'Last Rites, Allegiance of the North', 47.4, 30, 93, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (370, 'LittleBigPlanet', 71.7, 77, 68, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (371, 'Enlightened Riata', 66.5, 51, 154, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (372, 'Ghostly Steel Lasso2', 69.2, 50, 153, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (373, 'Orbit, Wire of Burdens', 74.3, 49, 117, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (374, 'Diabolical Crop', 73.9, 42, 132, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (375, 'Maneater', 66.2, 67, 76, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (376, 'Patience, Incarnation of Pride''s Fall', 60.7, 86, 152, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (377, 'Blood Infused Bronzed Riata', 73.3, 71, 78, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (378, 'Stormrider', 73.4, 90, 164, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (379, 'Doom, Call of Reckoning', 56.2, 67, 99, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (380, 'Morningstar, Conqueror of the Dreadlord', 71.4, 77, 175, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (381, 'Victor Lasso', 51.7, 30, 135, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (382, 'Doom Iron Riata', 52.8, 69, 175, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (383, 'Flaming Obsidian Crop', 61.1, 73, 83, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (384, 'Ghostwalker, Hope of Pride''s Fall', 73.7, 71, 156, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (385, 'Deathraze, Piercer of the Ancients', 67.7, 72, 146, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (386, 'Barbaric Steel Wire', 51.5, 53, 172, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (387, 'Interrogator, Legacy of the Fallen', 46.3, 43, 70, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (388, 'Military Ebon Lash', 61.8, 62, 161, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (389, 'Jawbone', 66.4, 41, 95, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (390, 'Sorrow''s Skeletal Wire', 66.8, 67, 118, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (391, 'Homage, Slayer of the Oracle', 49.6, 65, 121, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (392, 'Bloodied Wire', 74.8, 52, 162, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (393, 'Flaming Mithril Riata', 50.1, 57, 72, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (394, 'Arondite', 48.5, 61, 83, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (395, 'War Lariat', 45.7, 45, 129, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (396, 'Demise, Belt of Frozen Hells', 52.3, 33, 108, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (397, 'Inherited Steel Wire', 59.9, 86, 150, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (398, 'Fortune''s Lasso', 65.0, 43, 169, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (399, 'Infamy', 66.1, 75, 113, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (400, 'Godslayer, Crusader of the Stars', 74.2, 67, 90, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (401, 'Lustful Bone Wire', 67.8, 67, 143, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (402, 'Defender Whip', 68.4, 47, 82, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (403, 'Madden NFL 2003', 58.8, 34, 129, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (404, 'Falling Star, Pledge of the Sun', 71.8, 43, 113, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (405, 'Whistling Belt', 45.1, 69, 95, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (406, 'Desolation', 60.9, 68, 163, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (407, 'Rage, Boon of the Serpent', 65.6, 44, 108, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (408, 'Knightfall, Champion of the Sky', 74.9, 74, 81, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (409, 'Corroded Lariat', 72.6, 44, 144, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (410, 'Gran Turismo 3: A-Spec', 54.8, 41, 174, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (411, 'Whirlwind, Incarnation of Immortality', 49.4, 37, 73, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (412, 'Twilight Lash', 55.2, 33, 165, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (413, 'Ruby Infused Belt', 47.4, 77, 137, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (414, 'Singing Riata', 69.3, 80, 119, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (415, 'Requiem', 68.0, 51, 73, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (416, 'Good Morning, Hope of Putrefaction', 60.9, 82, 156, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (417, 'Von Karma''s Whip, Riata of Phantoms', 58.1, 40, 66, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (418, 'Promised Whip', 51.7, 70, 68, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (419, 'Earthwarden, Last Hope of Secrecy', 60.0, 82, 124, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (420, 'Liar''s Skeletal Riata', 53.1, 89, 167, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (421, 'Rage, Boon of the Serpent', 69.6, 75, 62, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (422, 'Faith''s Ironbark Lash', 51.9, 69, 94, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (423, 'Convergence, Breaker of the Lionheart', 60.1, 72, 128, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (424, 'Soul-Forged Bronzed Lasso', 49.8, 77, 107, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (425, 'Spectral Skeletal Wire', 67.3, 37, 132, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (426, 'Soul-Forged Bronzed Lasso', 54.8, 52, 137, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (427, 'Ferocious Lash', 72.4, 60, 103, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (428, 'Flaming Mithril Riata', 69.9, 76, 118, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (429, 'Silent Iron Crop', 51.6, 65, 100, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (430, 'Cataclysm Iron Wire', 58.3, 60, 106, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (431, 'Abomination', 63.2, 75, 160, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (432, 'Sorrow''s Wire', 60.2, 36, 60, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (433, 'Hateful Steel Lash', 49.9, 34, 162, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (434, 'The Minotaur, Call of Lost Voices', 63.8, 73, 153, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (435, 'Savagery', 67.5, 54, 92, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (436, 'Celeste, Hope of Bloodlust', 62.8, 30, 78, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (437, 'Earthwarden, Ferocity of Twilight''s End', 64.3, 84, 169, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (438, 'Falcon, Tribute of Nightmares', 56.5, 77, 89, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (439, 'Orbit, Executioner of Conquered Worlds', 68.9, 75, 86, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (440, 'Tank, Protector of Ashes', 61.6, 34, 83, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (441, 'Shooting Star', 67.1, 33, 129, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (442, 'Decimation, Glory of Illuminated Dreams', 57.9, 64, 145, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (443, 'Firesoul Lasso', 53.6, 44, 113, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (444, 'Harbinger', 53.9, 70, 65, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (445, 'Soldier''s Belt', 46.6, 59, 100, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (446, 'Interrogator', 72.1, 89, 152, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (447, 'War-Forged Ebon Lasso', 54.4, 48, 98, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (448, 'Firesoul Lasso', 55.0, 70, 149, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (449, 'Desolation', 47.9, 84, 179, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (450, 'Remorse, Ender of Desecration', 67.7, 67, 110, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (451, 'Tormented Obsidian Lash', 56.7, 76, 147, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (452, 'Spinefall, Hope of Decay', 65.7, 69, 172, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (453, 'Peacekeeper Adamantite Crop', 61.6, 37, 172, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (454, 'Falling Star, Pledge of the Sun', 68.3, 36, 135, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (455, 'Hopeless Crop', 71.6, 42, 159, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (456, 'Malicious Adamantite Snare', 46.8, 89, 153, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (457, 'Crying Bone Lash', 55.8, 48, 132, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (458, 'Harmonized Iron Snare', 53.6, 82, 141, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (459, 'Patience', 59.6, 50, 151, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (460, 'Curved Snare', 68.0, 48, 165, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (461, 'Dragonstrike, Might of the Leviathan', 56.9, 88, 168, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (462, 'Desire''s Snare', 58.3, 36, 157, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (463, 'Echo, Soul of Visions', 60.9, 49, 171, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (464, 'Corruption, Sculptor of the Ancients', 54.1, 81, 74, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (465, 'Storm-Weaver', 52.1, 87, 179, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (466, 'Comet, Vengeance of Immortality', 66.0, 38, 78, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (467, 'Vengeful Golden Wire', 72.8, 62, 102, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (468, 'Shadowfury, Hope of Shifting Sands', 49.4, 74, 70, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (469, 'Oxheart', 53.5, 89, 128, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (470, 'Lightbane', 65.2, 47, 118, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (471, 'Knight''s Fall, Cunning of the Moonwalker', 63.5, 68, 122, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (472, 'Primitive Bronzed Lash', 51.8, 77, 144, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (473, 'Malificent Whip', 68.3, 48, 170, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (474, 'Brutality', 72.4, 78, 101, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (475, 'Primitive Bronzed Lash', 68.1, 70, 76, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (476, 'Improved Snare', 54.1, 32, 63, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (477, 'Winter''s Bite, Pledge of the Damned', 47.6, 54, 107, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (478, 'The Sundering, Betrayer of Ashes', 69.4, 88, 79, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (479, 'Retribution Titanium Lariat', 62.7, 71, 95, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (480, 'Hell''s Scream, Favor of Eternal Glory', 73.8, 84, 104, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (481, 'Chance, Executioner of the Immortal', 62.9, 30, 168, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (482, 'The Void', 64.2, 65, 113, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (483, 'Stonefist, Wire of Shifting Worlds', 71.6, 67, 166, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (484, 'Engraved Gilded Snare', 59.1, 81, 119, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (485, 'Timeworn Lash', 56.7, 35, 103, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (486, 'Peacekeeper, Reaper of the Phoenix', 74.6, 30, 144, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (487, 'Skullcrusher, Last Hope of the Dreadlord', 69.6, 66, 113, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (488, 'Sorcerer''s Riata', 67.7, 62, 66, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (489, 'Cometfall, Heirloom of Heroes', 61.6, 63, 96, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (490, 'Lazarus, Betrayer of the Void', 59.0, 34, 139, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (491, 'Lightbane, Betrayer of Blessed Fortune', 72.2, 86, 164, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (492, 'Mourning Iron Wire', 55.3, 43, 173, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (493, 'King''s Legacy, Champion of Blood', 51.8, 39, 160, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (494, 'Brutality Ironbark Lasso', 74.3, 72, 165, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (495, 'Peacekeeper Adamantite Riata', 63.4, 41, 173, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (496, 'Deathraze, Piercer of the Ancients', 54.9, 63, 117, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (497, 'Ritual Lash', 68.2, 58, 143, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (498, 'Doom Whip', 46.3, 51, 137, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (499, 'Flimsy Crop', 48.1, 64, 162, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (500, 'Shadow Crop', 51.4, 30, 179, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (501, 'Ritual Lash2', 51.2, 66, 158, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (502, 'Nightglow', 45.4, 82, 153, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (503, 'Celeste, Bringer of Bloodlust', 60.8, 41, 115, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (504, 'Spinefall, Might of the King', 48.8, 62, 136, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (505, 'Antique Skeletal Lasso', 60.9, 84, 121, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (506, 'Stormrider, Crop of Thunder', 45.6, 63, 143, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (507, 'Spinefall, Might of the King', 56.2, 85, 112, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (508, 'Bonesnapper', 67.3, 54, 176, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (509, 'Whistling Lash', 68.0, 87, 90, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (510, 'Twilight, Conqueror of Thunder', 64.5, 54, 94, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (511, 'Nightmare Steel Riata', 63.9, 31, 61, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (512, 'Convergence, Breaker of the Lionheart', 65.6, 35, 145, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (513, 'Dominion', 45.4, 67, 128, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (514, 'Chance, Executioner of the Immortal', 69.7, 77, 110, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (515, 'Red Dwarf, Memory of the Light', 67.5, 64, 93, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (516, 'The Chief', 45.5, 36, 171, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (517, 'Furious Ebon Lariat', 72.1, 45, 66, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (518, 'Hopeless Crop', 45.5, 78, 138, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (519, 'Apocalypse Ironbark Riata', 73.4, 48, 160, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (520, 'Rigormortis, Riata of the Insane', 51.3, 32, 162, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (521, 'Blood Infused Bronzed Riata', 45.7, 68, 66, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (522, 'Lightbane', 73.2, 33, 88, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (523, 'Flaming Belt', 71.5, 60, 85, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (524, 'Dragonstrike, Bringer of Broken Families', 66.1, 56, 92, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (525, 'Wizards of the Blazing Law', 55.2, 77, 118, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (526, 'Loyal Adamantite Belt', 66.3, 63, 161, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (527, 'Apocalypse Wire', 60.7, 60, 63, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (528, 'Knight''s Honor, Incarnation of Twisted Visions', 69.4, 67, 146, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (529, 'Furious Ebon Lasso', 57.3, 68, 119, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (530, 'Promised Belt2', 49.8, 46, 172, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (531, 'Peacemaker', 47.6, 73, 88, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (532, 'Sorrow''s Ironbark Whip', 73.5, 75, 153, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (533, 'Nirvana', 49.5, 88, 146, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (534, 'Flaming Obsidian Crop', 53.2, 56, 150, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (535, 'Oathbreaker, Lariat of Cunning', 67.8, 89, 167, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (536, 'Twilight', 67.7, 45, 106, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (537, 'Exiled Belt', 66.2, 50, 142, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (538, 'Cosmos, Executioner of the Lost', 72.2, 73, 177, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (539, 'Amnesia, Riata of the South', 74.5, 49, 62, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (540, 'Hopeless Steel Lasso', 66.4, 48, 115, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (541, 'Thirsting Lash', 60.0, 39, 97, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (542, 'Soul Bronze Lasso', 72.3, 81, 113, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (543, 'Anduril, Reaper of Burdens', 74.5, 59, 128, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (544, 'Convergence', 73.4, 85, 96, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (545, 'Lightbane, Betrayer of Blessed Fortune', 68.0, 38, 158, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (546, 'Heartcrusher', 72.2, 38, 77, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (547, 'Falling Star, Pledge of the Sun', 73.2, 51, 139, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (548, 'Knight''s Fall, Cunning of the Moonwalker', 59.2, 77, 177, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (549, 'Unholy Ivory Snare', 65.8, 43, 172, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (550, 'The Ambassador', 56.1, 65, 145, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (551, 'Bloodquench', 56.9, 38, 72, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (552, 'Bloodvenom Obsidian Belt', 55.7, 57, 142, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (553, 'Blood-Forged Whip', 49.5, 45, 169, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (554, 'Falling Star, Ferocity of the Burning Sun', 58.8, 88, 173, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (555, 'Rage, Boon of the Serpent', 56.5, 40, 91, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (556, 'Reckoning', 71.3, 82, 116, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (557, 'Malevolent Snare', 52.8, 51, 132, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (558, 'Brutalizer, Whisper of Hatred', 49.1, 74, 95, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (559, 'Concussion', 48.7, 30, 145, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (560, 'Shooting Star, Voice of Denial', 67.5, 59, 125, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (561, 'Frenzy', 63.1, 55, 97, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (562, 'Deserted Adamantite Whip', 74.2, 53, 175, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (563, 'Fury', 61.8, 76, 66, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (564, 'Supremacy, Glory of Executions', 50.6, 65, 103, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (565, 'Agony, Ferocity of Wizardry', 71.9, 78, 129, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (566, 'Victor Lasso', 46.9, 38, 159, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (567, 'Cataclysm Iron Wire', 45.5, 75, 141, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (568, 'Ghost Mithril Lasso', 53.7, 39, 178, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (569, 'Lockjaw, Glory of Souls', 67.9, 33, 167, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (570, 'Nightfall, Ender of Stealth', 60.2, 74, 79, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (571, 'Tank, Incarnation of the Enigma', 66.7, 89, 74, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (572, 'Mended Whip', 47.5, 48, 122, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (573, 'Hell''s Scream, Favor of Eternal Glory', 50.4, 42, 62, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (574, 'The Warden, Prophecy of Phantoms', 74.6, 69, 60, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (575, 'Soul Infused Snare', 66.4, 60, 93, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (576, 'Conqueror Adamantite Lariat', 46.4, 62, 134, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (577, 'Wretched Belt', 69.4, 56, 110, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (578, 'Ritual Lash', 49.9, 53, 179, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (579, 'The Oculus, Champion of the Claw', 60.3, 78, 173, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (580, 'Vindictive Snare', 46.0, 62, 124, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (581, 'Incarnated Ebon Belt', 68.6, 38, 159, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (582, 'Brutality', 72.0, 58, 174, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (583, 'Back Breaker, Executioner of the Burning Sun', 53.9, 69, 169, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (584, 'Brutality Lash', 53.8, 49, 60, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (585, 'Twilight, Conqueror of Thunder', 68.6, 33, 176, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (586, 'Battleworn Lasso', 64.7, 32, 174, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (587, 'Treachery''s Ironbark Wire', 54.6, 36, 115, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (588, 'Emergency', 71.7, 38, 148, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (589, 'Prime Wire', 46.4, 55, 133, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (590, 'Hateful Titanium Lasso', 56.2, 54, 169, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (591, 'Enchanted Wire', 62.2, 46, 156, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (592, 'Zealous Titanium Snare', 45.5, 51, 66, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (593, 'Storm', 75.0, 89, 85, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (594, 'King''s Legacy, Champion of Blood', 68.5, 34, 65, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (595, 'Greedy Obsidian Snare', 70.4, 81, 150, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (596, 'Warlord''s Silver Wire', 45.4, 36, 98, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (597, 'Primitive Bronzed Lash', 50.9, 52, 116, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (598, 'Antique Snare', 70.1, 40, 163, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (599, 'Cometfall', 54.9, 67, 156, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (600, 'Ritual Lash', 50.4, 77, 100, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (601, 'Twilight Lash', 73.0, 33, 115, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (602, 'Falling Star, Pledge of the Sun', 64.2, 86, 81, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (603, 'Oathkeeper', 50.9, 50, 172, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (604, 'Nightmare Lash', 46.8, 38, 148, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (605, 'Brutality Lash', 72.9, 59, 73, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (606, 'Possessed Lasso', 52.6, 86, 142, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (607, 'Morningstar', 68.1, 45, 165, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (608, 'Conqueror''s Lasso', 65.2, 85, 162, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (609, 'War Lariat', 68.7, 83, 180, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (610, 'Betrayal', 70.6, 32, 119, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (611, 'Sorrow''s Ironbark Whip', 64.5, 74, 101, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (612, 'Willbreaker', 64.3, 60, 80, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (613, 'Blind Justice, Breaker of Insanity', 68.4, 80, 150, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (614, 'Improved Belt', 63.7, 53, 63, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (615, 'Liar''s Skeletal Riata2', 59.5, 68, 116, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (616, 'Heartcrusher', 73.4, 45, 117, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (617, 'Frostwind, Annihilation of the Caged Mind', 69.3, 63, 146, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (618, 'Blind Justice, Prophecy of Fallen Souls', 52.2, 51, 160, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (619, 'Warlord''s Lasso', 65.1, 87, 125, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (620, 'Final Fantasy IX', 60.9, 64, 158, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (621, 'Furious Ebon Lasso', 68.0, 79, 127, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (622, 'Storm, Slayer of Blight', 68.1, 59, 171, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (623, 'Supremacy, Glory of Executions', 73.6, 41, 103, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (624, 'Legacy, Wire of Lost Voices', 56.4, 69, 153, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (625, 'Harvester', 48.3, 56, 176, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (626, 'Treachery, Whip of the Night Sky', 56.0, 48, 106, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (627, 'Wrathful Lasso', 50.0, 34, 177, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (628, 'Desolation', 53.1, 86, 144, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (629, 'Perfect Storm', 70.5, 63, 114, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (630, 'Ghastly Lasso', 50.0, 73, 149, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (631, 'Convergence, Soul of the East', 48.8, 50, 134, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (632, 'Bloodvenom Snare', 74.3, 85, 177, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (633, 'Lament, Whisper of Necromancy', 51.5, 68, 110, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (634, 'Whirlwind, Incarnation of Immortality', 51.6, 58, 96, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (635, 'Willbreaker, Ender of Bloodlust', 58.0, 86, 94, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (636, 'Frenzy', 53.7, 41, 156, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (637, 'Raging Bronzed Whip', 57.4, 55, 167, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (638, 'Back Breaker, Executioner of the Burning Sun', 46.0, 79, 64, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (639, 'Concussion, Oath of Silence', 63.3, 59, 175, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (640, 'Bloodweep, Lash of Torment', 73.4, 40, 177, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (641, 'Ancient Lasso', 57.4, 35, 164, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (642, 'Dragon''s Steel Whip', 71.3, 56, 173, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (643, 'Harmonized Glass Wire', 60.7, 81, 142, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (644, 'Jawbone', 68.2, 44, 109, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (645, 'Bloodspiller, Dawn of Wraiths', 71.1, 31, 154, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (646, 'Last Chance, Wacker of Anguish', 49.5, 42, 99, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (647, 'Tormented Lash', 66.6, 70, 99, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (648, 'Grand Theft Auto: Vice Cit', 51.1, 63, 162, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (649, 'Vengeance', 73.3, 36, 148, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (650, 'Apocalyptic Whip', 60.4, 74, 131, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (651, 'Soldier''s Bronze Riata', 70.1, 84, 79, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (652, 'Gladiator''s Belt', 74.6, 87, 149, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (653, 'Frostwind, Annihilation of the Caged Mind', 61.5, 86, 64, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (654, 'Piety', 58.1, 64, 173, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (655, 'Soul Infused Golden Crop', 53.3, 41, 98, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (656, 'Soul Infused Snare', 56.1, 85, 173, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (657, 'Wretched Adamantite Lash', 57.6, 54, 179, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (658, 'Refined Snare', 64.3, 81, 105, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (659, 'Sorrow''s Wire', 46.0, 71, 123, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (660, 'Oathbreaker, Lariat of Cunning', 46.0, 38, 127, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (661, 'Spinefall', 64.9, 54, 63, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (662, 'Hopeless Steel Lasso', 63.0, 87, 68, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (663, 'Earthwarden', 71.3, 67, 129, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (664, 'Pendulum, Betrayer of the Light', 48.4, 48, 174, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (665, 'Oxheart', 50.7, 32, 89, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (666, 'Apocalypse Mithril Riata', 65.6, 42, 180, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (667, 'Shatterskull, Belt of the Queen', 63.1, 46, 140, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (668, 'Honor''s Call', 53.9, 86, 155, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (669, 'Crush, Token of Torment', 65.2, 31, 152, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (670, 'Magma, Breaker of Timeless Battles', 48.0, 53, 127, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (671, 'Fate', 49.0, 88, 158, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (672, 'The End, Glory of Fury', 65.7, 51, 66, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (673, 'Warden''s Crop', 72.8, 80, 116, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (674, 'Amnesia', 46.8, 70, 105, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (675, 'Brutality, Heirloom of the Flame', 67.3, 89, 129, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (676, 'Treachery', 69.7, 67, 148, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (677, 'Hateful Steel Lash', 68.0, 49, 72, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (678, 'Mourning Titanium Riata', 51.6, 65, 146, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (679, 'Faithkeeper, Might of the Oracle', 67.4, 56, 61, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (680, 'Blackout, Foe of Broken Dreams', 52.7, 55, 97, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (681, 'Cyclone', 58.7, 73, 103, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (682, 'Thunderstorm Belt', 66.9, 33, 163, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (683, 'Wolf, Reaver of Broken Dreams', 51.3, 86, 86, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (684, 'Fury''s Gaze, Belt of Stealth', 57.7, 81, 119, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (685, 'Oathkeeper', 46.6, 86, 157, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (686, 'Rapture, Memory of Blessings', 65.0, 36, 114, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (687, 'Nightglow', 50.2, 57, 119, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (688, 'Earthshaper', 47.5, 36, 78, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (689, 'Desire''s Golden Lash', 60.4, 36, 139, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (690, 'Peacemaker', 62.2, 43, 131, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (691, 'Nightmare', 67.3, 39, 125, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (692, 'Battleworn Bronze Riata', 55.2, 59, 142, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (693, 'Icebreaker, Oath of the Harvest', 65.0, 66, 93, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (694, 'Enchanted Wire', 74.7, 35, 142, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (695, 'Howling Whip', 74.4, 83, 82, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (696, 'Convergence, Whisper of Shifting Sands', 66.6, 57, 153, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (697, 'Amnesia, Riata of the South', 57.8, 55, 87, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (698, 'Battlestar, Cunning of Power', 60.5, 48, 111, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (699, 'Vengeful Whip', 55.4, 33, 69, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (700, 'Incarnated Ebon Belt', 48.4, 32, 92, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (701, 'Amnesia, Riata of the South', 53.2, 30, 60, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (702, 'Corrupted Bronzed Lash', 71.0, 89, 79, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (703, 'Thunderfury Ivory Crop', 61.8, 73, 88, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (704, 'Diabolical Crop', 75.0, 50, 118, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (705, 'Hell''s Scream', 62.0, 39, 61, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (706, 'Broken Metal', 55.5, 78, 87, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (707, 'Pride, Soul of Fallen Souls', 56.0, 48, 132, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (708, 'Enchanted Lasso', 69.6, 35, 103, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (709, 'Harmonized Iron Snare', 70.6, 84, 139, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (710, 'Wolf, Foe of Desecration', 66.9, 47, 163, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (711, 'Echo', 74.6, 62, 65, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (712, 'Light''s Bane, Piercer of the Shadows', 57.6, 58, 114, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (713, 'Magma, Breaker of Timeless Battles', 50.2, 61, 145, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (714, 'Cataclysm, Breaker of Storms', 67.1, 77, 126, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (715, 'The Void', 53.0, 50, 142, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (716, 'Icebreaker', 47.7, 89, 154, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (717, 'Pride, Soul of Fallen Souls', 68.0, 83, 62, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (718, 'Blazeguard', 63.6, 75, 97, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (719, 'Shadow Lasso', 45.1, 66, 112, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (720, 'Cyclone, Gift of the Daywalker', 67.6, 43, 79, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (721, 'Fortune''s Bronzed Riata', 68.8, 67, 75, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (722, 'Scourgeborne', 61.9, 60, 164, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (723, 'Orbit, Butcher of Immortality', 63.0, 81, 149, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (724, 'Persuasion', 57.1, 46, 117, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (725, 'Requiem', 50.2, 44, 135, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (726, 'Endbringer, Ferocity of the Harvest', 47.0, 85, 74, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (727, 'Cataclysm, Sculptor of Trials', 60.5, 62, 69, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (728, 'Darkness Bone Whip', 48.0, 63, 119, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (729, 'Fierce Lash', 50.6, 83, 138, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (730, 'Amnesia, Gift of the Leviathan', 62.2, 88, 65, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (731, 'Warbringer, Cunning of Heroes', 46.7, 37, 115, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (732, 'Gladiator''s Iron Whip', 53.0, 58, 82, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (733, 'Cold-Forged Silver Lariat', 49.5, 77, 121, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (734, 'Bonesnapper, Call of Darkness', 46.9, 73, 155, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (735, 'Endbringer, Sculptor of Corruption', 52.1, 68, 88, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (736, 'Promised Belt', 56.6, 50, 173, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (737, 'Tormented Silver Lasso', 51.2, 90, 155, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (738, 'Trainee''s Belt', 56.5, 47, 130, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (739, 'Crimson', 52.7, 35, 156, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (740, 'Dragonfist', 53.9, 84, 140, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (741, 'Hopeless Crop', 57.9, 74, 144, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (742, 'Fortune''s Lasso', 57.3, 56, 104, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (743, 'Bone Warden', 64.0, 35, 149, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (744, 'Endbringer, Ferocity of the Harvest', 63.3, 31, 148, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (745, 'Crying Bone Lash', 47.7, 78, 89, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (746, 'Orbit, Wire of Burdens', 63.0, 58, 91, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (747, 'Vengeful Obsidian Whip', 57.8, 38, 129, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (748, 'Serenity, Destroyer of Woe', 52.3, 41, 112, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (749, 'Banished Ebon Wire', 68.1, 35, 103, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (750, 'Anduril, Reaper of Burdens', 70.5, 44, 103, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (751, 'Ritual Lash', 57.5, 55, 147, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (752, 'Promised Belt', 70.4, 66, 75, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (753, 'The Attack of Faded Intent', 53.0, 75, 115, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (754, 'Falling Star, Riata of Blessed Fortune', 56.2, 81, 150, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (755, 'Concussion, Crusader of Pride''s Fall', 62.3, 62, 79, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (756, 'Grimace', 49.8, 45, 133, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (757, 'Guardian''s Wire', 57.5, 74, 113, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (758, 'Prophecy, Conqueror of Justice', 50.2, 87, 108, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (759, 'Knight''s Honor, Memory of Giantslaying', 62.4, 70, 108, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (760, 'Cosmos, Executioner of the Lost', 67.5, 52, 102, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (761, 'Devotion, Voice of Ending Hope', 48.0, 51, 179, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (762, 'Thunderfury Whip', 63.9, 68, 97, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (763, 'Raging Ironbark Snare', 51.4, 75, 153, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (764, 'Haunted Whip', 67.7, 61, 123, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (765, 'Anduril, Reaper of Burdens', 62.3, 73, 90, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (766, 'Blood Infused Bronzed Riata', 56.4, 51, 146, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (767, 'Masters of the Karaoke - Gold Edition', 69.6, 68, 127, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (768, 'Zealous Titanium Snare', 68.8, 67, 177, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (769, 'Worldslayer, Last Hope of Deception', 61.9, 81, 135, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (770, 'The Sundering', 61.2, 52, 104, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (771, 'Cataclysm, Call of Frost', 57.0, 75, 166, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (772, 'Hell''s Scream, Favor of Eternal Glory', 61.9, 68, 76, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (773, 'Rusty Lasso', 55.8, 51, 98, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (774, 'Curved Snare', 67.0, 68, 109, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (775, 'Perfect Storm', 66.8, 38, 134, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (776, 'Interrogator, Hope of Giants', 52.4, 90, 124, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (777, 'Concussion, Oath of Silence', 54.7, 49, 159, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (778, 'Abomination, Conqueror of Ancient Power', 71.2, 32, 153, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (779, 'Sundown, Last Stand of Broken Dreams', 72.3, 89, 164, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (780, 'Vanquisher', 46.3, 47, 154, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (781, 'Blazeguard', 53.6, 59, 173, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (782, 'The Minotaur, Conqueror of Regret', 73.8, 89, 103, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (783, 'Ghost Gilded Lariat', 65.1, 83, 92, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (784, 'Fireguard Lariat', 56.3, 65, 130, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (785, 'Grieving Whip', 54.1, 37, 63, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (786, 'Ferocious Lash', 68.9, 70, 74, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (787, 'Willbreaker, Ender of Bloodlust', 67.4, 37, 90, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (788, 'Harmonized Iron Snare', 51.2, 45, 122, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (789, 'Soul Infused Whip', 57.1, 68, 131, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (790, 'Cataclysm Iron Wire', 71.6, 83, 80, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (791, 'Putrid Bronze Lash', 52.5, 76, 124, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (792, 'Last Rites, Allegiance of the North', 66.0, 43, 153, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (793, 'Lazarus', 69.1, 42, 131, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (794, 'Twilight Lash', 48.3, 74, 81, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (795, 'Soldier''s Adamantite Snare', 69.8, 55, 74, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (796, 'Limbo', 58.4, 65, 66, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (797, 'Thunder, Reaper of Eternity', 69.1, 62, 179, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (798, 'Lazarus, Foe of the Damned', 68.1, 57, 70, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (799, 'Agony, Incarnation of the Undying', 71.4, 65, 180, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (800, 'Twilight''s Steel Riata', 71.9, 38, 88, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (801, 'Tank, Protector of Ashes', 68.2, 44, 171, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (802, 'Jackhammer, Last Stand of the Harvest', 67.8, 53, 68, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (803, 'Endbringer, Ferocity of the Harvest', 67.7, 31, 62, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (804, 'Twilight''s Lasso', 74.5, 54, 158, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (805, 'Corrupted Gilded Lariat', 62.0, 38, 176, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (806, 'Fireguard Lariat', 48.6, 82, 104, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (807, 'The Sundering, Betrayer of Ashes', 62.1, 63, 88, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (808, 'Dragon''s Obsidian Lasso', 72.6, 31, 93, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (809, 'Ghost Mithril Lasso', 63.3, 84, 63, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (810, 'Maneater', 65.7, 42, 158, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (811, 'Lightbringer, Etcher of Pride', 72.7, 55, 166, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (812, 'Dominance', 69.3, 61, 74, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (813, 'Termination, Glory of Burdens', 68.3, 33, 116, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (814, 'Mourning Star, Executioner of Due Diligence', 48.2, 72, 91, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (815, 'Rigormortis, Riata of the Insane', 55.5, 54, 139, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (816, 'Light''s Bane, Wire of the Prince', 45.7, 37, 112, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (817, 'The Attack of Faded Intent', 49.3, 51, 60, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (818, 'Frail Silver Whip', 47.1, 89, 121, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (819, 'Betrayal', 68.9, 70, 173, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (820, 'Thunderguard Obsidian Lash', 58.9, 79, 75, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (821, 'Barbarian Lash', 73.2, 47, 167, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (822, 'Call of Duty: Modern Warfare 2', 65.6, 65, 175, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (823, 'Thundersoul Obsidian Wire', 58.7, 71, 130, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (824, 'Treachery''s Bone Lash', 51.2, 33, 112, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (825, 'Dancing Wire', 57.7, 81, 123, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (826, 'Curved Snare', 58.7, 48, 177, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (827, 'Piety', 45.4, 61, 110, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (828, 'Storm, Slayer of Blight', 56.2, 87, 171, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (829, 'Improved Belt', 64.8, 39, 71, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (830, 'Thunder-Forged Belt', 72.0, 36, 148, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (831, 'Dragonstrike, Call of Mountains', 45.5, 46, 136, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (832, 'Corroded Lariat', 50.0, 64, 117, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (833, 'Skatezone', 72.9, 78, 75, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (834, 'Improved Belt', 69.7, 43, 143, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (835, 'Terror Ivory Wire', 45.6, 80, 65, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (836, 'Fierce Wire', 47.5, 83, 76, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (837, 'Interrogator, Legacy of the Fallen', 48.7, 46, 146, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (838, 'Thunderfury Lasso', 70.5, 36, 75, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (839, 'Kinslayer', 56.8, 74, 166, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (840, 'Wretched Obsidian Lash', 60.2, 79, 179, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (841, 'Challenger''s Titanium Belt', 52.2, 53, 64, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (842, 'Mourning Iron Wire', 48.5, 47, 82, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (843, 'Hero Titanium Riata', 74.0, 70, 91, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (844, 'Lazarus', 49.8, 45, 128, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (845, 'Silent Wire', 59.5, 76, 66, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (846, 'Legionnaire''s Ironbark Wire', 47.2, 83, 179, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (847, 'Wretched Adamantite Lash', 74.3, 89, 74, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (848, 'Echo, Soul of Visions', 65.5, 41, 127, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (849, 'Flaming Mithril Riata', 52.6, 38, 171, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (850, 'Dragonstrike, Lariat of Putrefaction', 58.9, 74, 145, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (851, 'Soul Infused Golden Crop', 61.8, 55, 66, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (852, 'Orbit, Executioner of Conquered Worlds', 68.8, 36, 135, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (853, 'Heartcrusher, Betrayer of Twilight''s End', 48.4, 65, 151, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (854, 'Echo, Snare of the Earth', 50.0, 37, 140, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (855, 'Lazarus, Snare of Mercy', 65.9, 89, 63, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (856, 'Good Morning, Whip of Infinite Trials', 46.3, 48, 137, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (857, 'Trainee''s Iron Crop', 62.0, 42, 153, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (858, 'Last Rites', 70.5, 81, 82, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (859, 'Stormguard Glass Crop', 46.7, 84, 165, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (860, 'Catastrophe, Last Hope of Bloodlust', 47.2, 65, 162, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (861, 'Stormbringer, Last Stand of Giants', 55.6, 64, 95, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (862, 'Victor Lariat', 55.6, 72, 151, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (863, 'Agony, Incarnation of the Undying', 53.9, 86, 68, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (864, 'Victor Lariat', 71.5, 63, 67, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (865, 'Warbringer, Cunning of Heroes', 65.6, 31, 165, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (866, 'Warbringer, Cunning of Heroes', 48.2, 37, 164, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (867, 'Stormbringer, Last Stand of Giants', 45.3, 74, 71, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (868, 'Heartcrusher, Betrayer of Twilight''s End', 58.4, 85, 104, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (869, 'Magma, Breaker of Timeless Battles', 64.7, 50, 150, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (870, 'Peacekeeper Steel Riata', 45.9, 53, 88, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (871, 'Renewed Crop', 63.9, 88, 152, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (872, 'Infused Mithril Belt', 62.4, 53, 128, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (873, 'Barbarian Wire', 64.2, 62, 63, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (874, 'Lightbane, Reaper of Magic', 52.8, 50, 155, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (875, 'Catastrophe, Last Hope of Bloodlust', 45.7, 84, 164, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (876, 'Orenmir, Promise of Time-Lost Memories', 57.8, 63, 72, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (877, 'Rusty Wire', 69.4, 38, 117, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (878, 'Thundersoul Wire', 59.0, 63, 87, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (879, 'Bloodspiller, Dawn of Wraiths', 61.2, 31, 127, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (880, 'Shenmue II', 47.7, 58, 156, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (881, 'Worldbreaker', 57.7, 64, 149, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (882, 'Legionaire, Bond of Hell''s Games', 48.1, 49, 71, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (883, 'Fury', 57.5, 44, 86, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (884, 'Possessed Bone Lariat', 64.3, 39, 111, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (885, 'Ghost Skeletal Whip', 70.8, 41, 73, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (886, 'Punisher', 46.9, 44, 99, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (887, 'Soul Infused Whip', 48.7, 38, 147, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (888, 'Earthwarden, Ferocity of Twilight''s End', 68.8, 43, 138, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (889, 'Bonesnapper, Call of Darkness', 66.4, 70, 147, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (890, 'Zealous Wire', 48.4, 53, 142, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (891, 'Warp Whip', 71.3, 78, 69, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (892, 'Corrupted Gilded Lariat', 61.9, 77, 111, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (893, 'Lusting Lariat', 70.4, 48, 80, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (894, 'Thundersoul Wire', 69.2, 48, 98, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (895, 'Last Chance, Bringer of the Serpent', 70.3, 35, 99, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (896, 'Rising Tide, Annihilation of Bloodlust', 63.2, 71, 164, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (897, 'Raging Ebon Wire', 47.5, 69, 179, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (898, 'Orenmir, Promise of Time-Lost Memories', 49.9, 77, 114, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (899, 'Darkness Riata', 54.2, 38, 84, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (900, 'Thirsty Ebon Lash', 65.9, 85, 126, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (901, 'Ghostly Steel Lasso', 58.9, 77, 117, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (902, 'Conqueror''s Silver Crop', 69.2, 80, 148, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (903, 'Peacekeeper Steel Riata', 72.7, 54, 156, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (904, 'Harmonized Bronze Lariat', 65.6, 49, 80, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (905, 'Runed Titanium Crop', 57.5, 75, 73, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (906, 'Crash, Betrayer of Fools', 52.4, 59, 148, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (907, 'Armageddon, Cry of Cunning', 72.5, 50, 80, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (908, 'Shooting Star', 45.7, 59, 143, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (909, 'Homage, Lasso of Ended Dreams', 45.5, 60, 158, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (910, 'Rage, Boon of the Serpent', 74.5, 67, 140, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (911, 'Nighttime, Dawn of Terror', 57.8, 56, 132, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (912, 'Fury''s Gaze, Belt of Stealth', 66.6, 72, 82, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (913, 'The Void', 69.8, 60, 121, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (914, 'Vacancy, Ender of Broken Families', 64.5, 56, 82, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (915, 'Midnight', 74.7, 71, 76, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (916, 'Brutality Ironbark Lasso', 57.0, 42, 81, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (917, 'Light''s Bane, Wire of the Prince', 52.4, 66, 109, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (918, 'Destiny, Lash of Broken Dreams', 71.6, 86, 116, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (919, 'Ruby Infused Belt', 59.2, 51, 162, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (920, 'Lightning, Defiler of Lost Hope', 68.7, 65, 147, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (921, 'Vengeance', 56.3, 78, 180, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (922, 'Orbit, Wire of Burdens', 49.8, 55, 149, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (923, 'Devine, Piercer of Riddles', 60.4, 49, 104, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (924, 'Conqueror Adamantite Lariat', 46.4, 58, 110, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (925, 'Piece Maker', 58.0, 34, 158, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (926, 'Inherited Crop', 65.6, 61, 111, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (927, 'Earthwarden, Last Hope of Secrecy', 63.4, 41, 62, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (928, 'Pride''s Crop', 73.9, 75, 174, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (929, 'Fierce Wire', 50.3, 76, 98, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (930, 'Devourer, Riata of the Forsaken', 62.8, 85, 89, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (931, 'Silent Wire', 66.7, 40, 107, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (932, 'Vengeful Golden Wire', 64.1, 69, 143, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (933, 'Endbringer, Legacy of Denial', 58.4, 83, 70, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (934, 'Patience', 68.9, 78, 144, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (935, 'Shamanic Riata', 62.8, 72, 163, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (936, 'Malificent Whip', 50.1, 72, 62, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (937, 'Faithkeeper', 51.4, 87, 161, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (938, 'Crush, Token of Torment', 66.0, 81, 157, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (939, 'Supremacy, Glory of Executions', 70.1, 39, 125, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (940, 'Guiding Star, Heirloom of the Covenant', 68.5, 79, 163, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (941, 'Thundersoul Wire', 59.1, 58, 155, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (942, 'Decimation, Token of the East', 48.2, 61, 73, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (943, 'Typhoon, Champion of Broken Dreams', 67.4, 31, 72, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (944, 'Convergence, Soul of the East', 48.0, 64, 115, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (945, 'Cold-Forged Silver Lariat', 74.6, 42, 175, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (946, 'Firesoul Lasso', 70.9, 32, 156, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (947, 'Limbo', 69.7, 42, 82, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (948, 'Vengeance', 66.9, 31, 130, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (949, 'Worldslayer', 66.5, 74, 94, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (950, 'Piece Maker', 49.6, 72, 119, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (951, 'Midnight, Reaver of the Void', 50.4, 79, 95, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (952, 'Echo, Soul of Visions', 53.1, 74, 77, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (953, 'Possessed Ebon Riata', 46.9, 48, 164, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (954, 'Thirsting Lash', 54.6, 74, 141, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (955, 'Darkness Whip', 69.7, 37, 79, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (956, 'Agony, Ferocity of Wizardry', 57.9, 85, 106, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (957, 'Demonic Crop', 48.2, 47, 128, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (958, 'Eclipse, Might of the Storm', 69.1, 56, 124, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (959, 'Nightmare', 49.6, 66, 137, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (960, 'Corpsemaker, Token of Putrefaction', 45.7, 89, 127, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (961, 'Bloodweep, Lash of Torment', 55.0, 53, 162, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (962, 'The Ambassador, Cunning of Grace', 59.6, 84, 62, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (963, 'Homage', 74.0, 70, 72, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (964, 'Darkness Whip', 52.8, 84, 62, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (965, 'Typhoon, Secret of Trials', 63.5, 39, 91, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (966, 'Woeful Riata', 51.6, 36, 135, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (967, 'Savagery', 70.0, 58, 125, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (968, 'War-Forged Mithril Whip', 56.4, 70, 75, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (969, 'Frostwind', 70.3, 78, 125, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (970, 'Thunderstorm Riata', 54.3, 45, 72, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (971, 'Thunderfury Lasso', 73.7, 89, 88, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (972, 'Silent Whip', 47.1, 37, 121, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (973, 'Challenger Steel Riata', 71.4, 45, 101, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (974, 'Ash', 72.0, 64, 75, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (975, 'Misty Bronze Snare', 59.0, 47, 174, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (976, 'Darkness Crop', 55.2, 59, 144, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (977, 'Hurricane', 49.1, 59, 161, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (978, 'Twilight''s Ivory Snare', 65.8, 42, 141, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (979, 'Singing Skeletal Wire', 60.0, 33, 145, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (980, 'Armageddon, Annihilation of Deception', 59.7, 80, 94, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (981, 'Bloodquench, Wacker of the Ancients', 59.9, 34, 129, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (982, 'Endbringer', 72.5, 35, 91, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (983, 'Peacekeeper Gilded Snare', 61.6, 60, 81, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (984, 'Brutality Ironbark Lasso', 47.2, 54, 149, 'GR4');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (985, 'Falcon, Tribute of Nightmares', 59.0, 70, 121, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (986, 'Incarnated Ebon Belt', 61.6, 56, 94, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (987, 'Ritual Gilded Wire', 49.5, 66, 148, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (988, 'Howling Whip', 70.5, 62, 155, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (989, 'Crush, Token of Torment', 67.0, 59, 109, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (990, 'Howling Whip', 61.4, 36, 114, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (991, 'The Void', 52.0, 34, 167, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (992, 'LittleBigPlanet', 50.9, 56, 162, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (993, 'Rigormortis, Slayer of Delusions', 72.3, 89, 62, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (994, 'The Warden, Prophecy of Phantoms', 48.2, 88, 155, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (995, 'Stormfury Riata', 71.3, 68, 91, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (996, 'Vengeful Golden Wire', 67.7, 64, 180, 'WG3');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (997, 'Curved Snare3', 62.1, 66, 179, 'IG5');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (998, 'Celeste, Conqueror of Desecration', 66.1, 71, 133, 'GC2');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (999, 'Worldbreaker', 72.9, 87, 73, 'GA1');
insert into Stocks (StockId, Title, Price, QuantityPurchased, StockLevel, SupplierId) values (1000, 'Warmonger', 60.1, 65, 144, 'GR4');



SELECT * FROM Stocks ORDER BY StockId ASC; # To View the values
##

Insert into Suppliers( SupplierId, SupplierName, SupplierAddress, SupplierPhone, SupplierEmail, SupplierCity, SupplierZipCode)
VALUES
  ('GA1','Gamestop', 'Henry street-51',      '01-6574352', 'Gamestop@info.ie',   'Dublin', 'D042599'),
  ('GC2','Gamechanger','Shandon Street-48',  '01-8967859', 'Gamechanger@info.ie', 'Cork', 'C073672'),
  ('WG3','Wholegame', 'Abbeygate Street-32', '01-3456732', 'Wholegame@info.ie',  'Galway', 'HD058769'),
  ('GR4','Gamerange', 'Gallydon Street-27',  '01-4567892', 'Gamerange@info.ie',  'Wexford', 'WD08818'),
  ('IG5','Ingaming', 'Thomas Street-32',     '01-3675489', 'Ingaming@info.ie',   'Kildare', 'R51A021');

SELECT * FROM Suppliers ; #to view the values
##

 INSERT INTO Payments(PaymentId,OrderId,PaymentChannel,PaymentMethod,PaymentStatus,DateOfPayment,GrandTotal)
VALUES 
('Pay01', 'Ord01',  'Mobile', 'CC', 'Paid', '2019-01-09', 123.6),
('Pay02', 'Ord02',  'Mobile', 'CC', 'Paid', '2019-01-15', 116.3),
('Pay03', 'Ord03',  'Mobile', 'CC', 'Paid', '2019-01-20', 183.1),
('Pay04', 'Ord04',  'Mobile', 'CC', 'Paid', '2019-02-04', 237.5),
('Pay05', 'Ord05',  'Online', 'CC', 'Paid', '2019-02-07', 249.0),
('Pay06', 'Ord06',  'Online', 'CC', 'Paid', '2019-02-13', 240.7),
('Pay07', 'Ord07',  'Mobile', 'DC', 'Paid', '2019-02-15', 260.8),
('Pay08', 'Ord08',  'Online', 'DC', 'Paid', '2019-03-06', 243.5),
('Pay09', 'Ord09',  'Mobile', 'CC', 'Paid', '2019-03-08', 339.6),
('Pay10', 'Ord10', 'Mobile', 'CC', 'Paid', '2019-03-17', 305.9),
('Pay11', 'Ord11', 'Mobile', 'CC', 'Paid', '2019-04-03', 376.1),
('Pay12', 'Ord12', 'Online', 'DC', 'Partially-Refunded', '2019-04-10',263.8),
('Pay13', 'Ord13', 'Online', 'DC', 'Paid', '2019-05-11', 385.1),
('Pay14', 'Ord14', 'Mobile', 'CC', 'Paid', '2019-05-24', 243.2),
('Pay15', 'Ord15', 'Mobile', 'CC', 'Paid', '2019-06-11', 233.4),
('Pay16', 'Ord16', 'Mobile', 'CC', 'Paid', '2019-06-15', 167.2),
('Pay17', 'Ord17', 'Mobile', 'CC', 'Paid', '2019-07-04', 301.2),
('Pay18', 'Ord18', 'Mobile', 'CC', 'Paid', '2019-07-17', 455.7),
('Pay19', 'Ord19', 'Mobile', 'CC', 'Partially-Refunded', '2019-07-21', 255.5),
('Pay20', 'Ord20', 'Mobile', 'CC', 'Paid', '2019-08-05', 556.7),
('Pay21', 'Ord21', 'Online', 'CC', 'Paid', '2019-09-10', 290.1),
('Pay22', 'Ord22', 'Mobile', 'CC', 'Paid', '2019-09-14', 302.8),
('Pay23', 'Ord23', 'Mobile', 'CC', 'Paid', '2019-10-03', 460.3),
('Pay24', 'Ord24', 'Mobile', 'CC', 'Paid', '2019-10-17', 517.6),
('Pay25', 'Ord25', 'Mobile', 'CC', 'Paid', '2019-11-12', 513.1),
('Pay26', 'Ord26', 'Mobile', 'CC', 'Paid', '2019-11-20', 352.9),
('Pay27', 'Ord27', 'Mobile', 'CC', 'Paid', '2019-12-03', 437.3),
('Pay28', 'Ord28', 'Mobile', 'CC', 'Paid', '2019-12-05', 580.9),
('Pay29', 'Ord29', 'Mobile', 'CC', 'Paid', '2019-12-08', 588.5),
('Pay30', 'Ord30', 'Mobile', 'CC', 'Paid', '2019-12-09', 983.7);

SELECT * FROM Payments ORDER BY PaymentId ; #to view the values
##

INSERT INTO Returns ( ReturnId, ItemId, OrderId, QuantityReturned, RefundAmount)
VALUES

('Ret12-50',  'Andu50' , 'Ord12', 1, 54.7),      
('Ret12-38',  'Dev38'  , 'Ord12', 1, 57.7),     
('Ret19-610', 'Betr610', 'Ord19', 1, 70.6),
('Ret19-611', 'Sorr611', 'Ord19', 1, 64.5);

SELECT * FROM Returns;


#  Part C
## Question 1. Create a View showing all transactions for a given week in your business. 

USE Antonio_Caruso_Online_Videogame_Retailer;

CREATE VIEW Weekly_December_Transactions AS
SELECT PaymentId, PaymentMethod, DateOfPayment, GrandTotal FROM Payments
WHERE DateOfPayment BETWEEN '2019-12-03' and '2019-12-09';

SELECT * FROM Weekly_December_Transactions;



## Question 2. Create a trigger that stores stock levels once a sale takes place. 

DELIMITER $$
CREATE TRIGGER Update_Stock_Level_After_New_Sale
AFTER INSERT ON OrderItems
FOR EACH ROW BEGIN
UPDATE stocks
SET StockLevel = StockLevel - New.QuantitySold
WHERE StockId = New.StockId;

END$$
DELIMITER ;

# Following code used to test the trigger, screenshots available in the project report

INSERT INTO OrderItems (ItemId, OrderId, QuantitySold,Price,StockId)
VALUES ('Pendubet13', 'Ord30', 3, 71.5, 13);

SELECT StockLevel, StockId FROM Stocks WHERE StockId = 13;

DELETE FROM OrderItems 
WHERE ItemId = 'Pendubet13';


# 
# Question 3 Create a View of the stock (By Supplier) purchased by me

CREATE VIEW Stocks_Purchased_Displayed_By_Supplier AS
SELECT suppliers.SupplierName as 'Supplier Name',
suppliers.SupplierId as 'Supplier ID',
stocks.Title as 'Item Title',
stocks.StockId as 'Stock ID',
stocks.QuantityPurchased as 'Quantity of Stocks Purchased',
stocks.StockLevel as 'Stock Level'
FROM stocks, suppliers
WHERE Stocks.SupplierId=Suppliers.SupplierId
ORDER BY suppliers.SupplierName ;

SELECT * FROM Stocks_Purchased_Displayed_By_Supplier;


#Question 4. Create a View of Total stock sold to general public (group by supplier). 

CREATE VIEW Total_Stocks_Sold_Displayed_By_Supplier AS
SELECT SupplierId, SUM(QuantitySold)
FROM OrderItems
INNER JOIN Stocks
ON OrderItems.StockId=Stocks.StockId
GROUP BY SupplierId;

SELECT * FROM Total_Stocks_Sold_Displayed_By_Supplier ;

##
##
#Question 5- Detail and total all transactions (SALES) for the month-to-date (Note: End of December as thid Database refers to year 2019). (A Group By with Roll-Up)
 
 SELECT
 COALESCE (DateOfPayment,'DecemberTotal') AS DateOfPayment, dates.Month, dates.Year, SUM(GrandTotal)
 FROM Payments
 INNER JOIN dates
 ON payments.DateOfPayment=dates.fulldate
 WHERE dates.month = 12 and dates.year = year
 GROUP BY DateOfPayment WITH ROLLUP;


# Question 6-  Detail and total all SALES for the year-to-date. (A Group By with Roll-Up)
SELECT 
 COALESCE (DateOfPayment,'YearlyGrandTotal') AS DateOfPayment, SUM(GrandTotal) 
 FROM Payments
 GROUP BY DateOfPayment WITH ROLLUP; 
 
 
 #Question 7-  Detail & total transactions broken down on a monthly basis for 1 year. (A Group By with Roll-Up)
 
 SELECT dates.Month, dates.Year, SUM(GrandTotal)
 FROM Payments
 INNER JOIN dates
 ON payments.DateOfPayment=dates.fulldate
 WHERE dates.month = month and dates.year = year 
 GROUP BY month WITH ROLLUP;
 
 #Extra number 7-  Show refund amount provided broken down
 SELECT dates.Month, dates.Year, SUM(RefundAmount)
 FROM Payments
 INNER JOIN dates
 ON payments.DateOfPayment=dates.fulldate
 LEFT JOIN returns
 ON Payments.OrderId= returns.OrderId
 WHERE dates.month = month and dates.year = year 
 GROUP BY month WITH ROLLUP;
 
 
#Question 8. Display the growth in sales/services (as a percentage) for your business, from the 1st month of opening until now 

SELECT dates.month, dates.year, concat(round(GrandTotal * 100.0 / (SELECT SUM(GrandTotal) FROM Payments),2),'%') AS Growth
FROM Payments
INNER JOIN dates
ON payments.DateOfPayment=dates.fulldate
WHERE dates.month= month and dates.year = year
GROUP BY month;


##
# Question 9. Create a Data Mart. SHOULD ONLY CONTAIN results only from Views  (Questions 1, 3 and 4 ONLY)

Create Database DataMart_Antonio_Caruso_Online_Videogame_Retailer;
USE DataMart_Antonio_Caruso_Online_Videogame_Retailer;

#To answer Question 1. View showing all transactions for a given week in your business. 
Create Table DataMart_Antonio_Caruso_Online_Videogame_Retailer.Query1_Data SELECT * FROM Antonio_Caruso_Online_Videogame_Retailer.Weekly_December_Transactions; 

#To answer Question 3. Create a View of stock (by supplier) purchased by you.
Create Table DataMart_Antonio_Caruso_Online_Videogame_Retailer.Query3_Data SELECT * FROM Antonio_Caruso_Online_Videogame_Retailer.Stocks_Purchased_Displayed_By_Supplier; 

#To answer Question 4. Create a View of Total stock sold to general public (group by supplier). 
Create Table DataMart_Antonio_Caruso_Online_Videogame_Retailer.Query4_Data SELECT * FROM Antonio_Caruso_Online_Videogame_Retailer.Total_Stocks_Sold_Displayed_By_Supplier; 


# Views Stored into Data Mart Tables
SELECT * FROM DataMart_Antonio_Caruso_Online_Videogame_Retailer.Query1_Data;
SELECT * FROM DataMart_Antonio_Caruso_Online_Videogame_Retailer.Query3_Data;
SELECT * FROM DataMart_Antonio_Caruso_Online_Videogame_Retailer.Query4_Data;


 

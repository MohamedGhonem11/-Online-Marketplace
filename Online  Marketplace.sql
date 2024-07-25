create database OnlineMarketplace;
go;

create table Users(
UserID int IDENTITY(1,1),
Username varchar(30) not null,
Email varchar(30) not null,
PasswordHash binary(20) not null,
Status int,
AddressLine1 varchar(30),
AddressLine2 varchar(30),
City varchar(30),
State varchar(30),
PostalCode varchar(10),
CountryID int,
CreatedAt varchar(30),
constraint User_pk primary key (UserID),
constraint User_Country_fk Foreign key (CountryID)
references Countries (CountryID)
);

create table Countries(
CountryID int IDENTITY(1,1),
CountryName varchar(30) not null,
constraint Country_pk primary key (CountryID)
);

create table Categories (
CategoryID int IDENTITY(1,1),
CategoryName varchar(30) not null,
Description varchar(30),
constraint Category_pk primary key (CategoryID)
);

create table Items (
ItemID int IDENTITY(1,1),
SellerID int not null,
CategoryID int not null,
Title varchar(30),
Description varchar(30),
StartingPrice decimal(10,2) not null,
CurrentPrice decimal(10,2) not null,
StartDate date not null,
EndDate date not null,
ImageURL Image,
CreatedAt varchar(30),
constraint Item_pk primary key (ItemID),
constraint User_Item_fk Foreign key (SellerID)
references Users (UserID),
constraint Category_Item_fk Foreign key (CategoryID)
references Categories (CategoryID)
);

create table Bids(
BidID int IDENTITY(1,1),
ItemID int not null,
UserID int not null,
BidAmount decimal(10,2) not null, 
BidTime time,
constraint Bid_pk primary key (BidID),
constraint Item_Bid_fk Foreign key (ItemID)
references Items (ItemID),
constraint User_Bid_fk Foreign key (UserID)
references Users (UserID)
);

create table Orders(
OrderID int IDENTITY(1,1),
BuyerID int not null,
ItemID int not null,
OrderDate date not null,
TotalAmount decimal(10,2) not null,
constraint Order_pk primary key (OrderID),
constraint User_Order_fk Foreign key (BuyerID)
references Users (UserID),
constraint Item_Order_fk Foreign key (ItemID)
references Items (ItemID)
);

create table Notifications(
NotificationID int IDENTITY(1,1),
UserID int not null,
Message varchar(30),
IsRead varchar(30),
CreatedAt varchar(30),
constraint Notification_pk primary key (NotificationID),
constraint User_Notification_fk Foreign key (UserID)
references Users (UserID)
);
----------------------------------------------------------------------------------
create Procedure s_p_create_Users (
@Username varchar(30),
@Emailas varchar(30), 
@PasswordHash binary,
@Status as int, 
@AddressLine1 varchar(30),
@AddressLine2 varchar(30),
@City varchar(30), 
@State varchar(30),
@PostalCode varchar(30),
@CountryID  int)
as 
begin
insert into Users (
Username,
Email,
PasswordHash,
Status,
AddressLine1,
AddressLine2,
City,
State,
PostalCode,
CountryID)

values (
@Username,
@Emailas,
@PasswordHash,
@Status,
@AddressLine1,
@AddressLine2,
@City,
@State,
@PostalCode,
@CountryID)
end;
------------------------------------------------------------------------------------
create procedure s_p_Update_Users(
@UserID int,
@Status int
)as
begin
update Users
set 
Status = @Status
where
UserID = @UserID
end;

---------------------------------------------------------------------------
create procedure s_p_Create_Item
(@SellerID int,
@CategoryID int,
@Title varchar(30),
@Description varchar(30), 
@StartingPrice decimal,
@CurrentPrice decimal,
@StartDate date,
@EndDate date, 
@ImageURL image
)
as 
begin

insert into Items (
SellerID,
CategoryID,
Title,
Description,
StartingPrice,
CurrentPrice,
StartDate,
EndDate,
ImageURL
 )
 values
(
@SellerID,
@CategoryID,
@Title,
@Description,
@StartingPrice,
@CurrentPrice,
@StartDate,
@EndDate,
@ImageURL
 )
end;

--------------------------------------------------------------------
create procedure s_p_Bid
(
@ItemID int,
@UserID int,
@BidAmount decimal
)
as
begin

insert into Bids 
(
ItemID,
UserID,
BidAmount
)
values 
(
@ItemID,
@UserID,
@BidAmount
)
declare @CurrentPrice decimal
update Items
set 
CurrentPrice = @CurrentPrice
where 
ItemID = @ItemID
end;

-------------------------------------------------------------------------------

select i.SellerID,Username,PasswordHash,ItemID,StartingPrice,CurrentPrice,StartDate,EndDate
from Items i join Users u
on u.UserID = i.SellerID
--------------------------------------------------------------------------------
select UserID,Username,ItemID
from Items i  left join Users u
on u.UserID = i.SellerID
---------------------------------------------------------------------------------
select i.ItemID,i.SellerID,count(BidID) as "No of Bid"
from Items i join Bids b
on i.ItemID = b.ItemID
group by
i.ItemID,i.SellerID
------------------------------------------------------------------------------------
SELECT u.UserID,username, SUM(TotalAmount) as "total amount"
FROM Users u JOIN Orders o
ON u.UserID =o.BuyerID
GROUP BY 
u.UserID,username
-----------------------------------------------------------------------------------
SELECT ItemID, CategoryName
FROM Items i JOIN categories c 
ON c.CategoryID = i.CategoryID;


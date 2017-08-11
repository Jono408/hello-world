-- Script to create ItemComparer database and objects if they don't already exist
USE [master]
GO

-- DATABASE
-- Check and create ItemComparer database
IF NOT EXISTS ( SELECT 1 FROM sys.databases WHERE [name] = 'ItemComparer' )
BEGIN
	CREATE DATABASE ItemComparer;
END
GO

USE ItemComparer;
GO

-- TABLES
-- Check and create Item table
IF NOT EXISTS ( SELECT 1 FROM sys.tables WHERE [name] = 'Item' )
BEGIN
	CREATE TABLE dbo.Item
	(
		ItemId	INT				NOT NULL	IDENTITY CONSTRAINT [PK_Item] PRIMARY KEY
	,	[Name]	VARCHAR(255)	NOT NULL
	);
END

-- Check and create Shop table
IF NOT EXISTS ( SELECT 1 FROM sys.tables WHERE [name] = 'Shop' )
BEGIN
	CREATE TABLE dbo.Shop
	(
		ShopId	INT				NOT NULL	IDENTITY CONSTRAINT [PK_Shop] PRIMARY KEY
	,	[Name]	VARCHAR(255)	NOT NULL
	);
END

-- Check and create ItemWebPage table
IF NOT EXISTS ( SELECT 1 FROM sys.tables WHERE [name] = 'ItemWebPage' )
BEGIN
	CREATE TABLE dbo.ItemWebPage
	(
		ItemWebPageId			INT				NOT NULL	IDENTITY CONSTRAINT [PK_ItemWebPage] PRIMARY KEY
	,	ItemId					INT				NOT NULL	CONSTRAINT [FK_ItemWebPage_ItemId] FOREIGN KEY REFERENCES dbo.Item(ItemId)
	,	ShopId					INT				NOT NULL	CONSTRAINT [FK_ItemWebPage_ShopId] FOREIGN KEY REFERENCES dbo.Shop(ShopId)
	,	PageURL					VARCHAR(1024)	NOT NULL
	,	PriceTag				VARCHAR(30)		NULL
	,	PriceTagType			VARCHAR(30)		NULL
	,	PriceTagName			VARCHAR(128)	NULL
	,	PriceOverrideTag		VARCHAR(30)		NULL
	,	PriceOverrideTagType	VARCHAR(30)		NULL
	,	PriceOverrideTagName	VARCHAR(128)	NULL
	);
END

-- Check and create ItemPriceHistory table
IF NOT EXISTS ( SELECT 1 FROM sys.tables WHERE [name] = 'ItemPriceHistory' )
BEGIN
	CREATE TABLE dbo.ItemPriceHistory
	(
		ItemPricerHistoryId		INT				NOT NULL	IDENTITY CONSTRAINT [PK_ItemPriceHistory] PRIMARY KEY
	,	ItemId					INT				NOT NULL	CONSTRAINT [FK_ItemPriceHistory_ItemId] FOREIGN KEY REFERENCES dbo.Item(ItemId)
	,	ShopId					INT				NOT NULL	CONSTRAINT [FK_ItemPriceHistory_ShopId] FOREIGN KEY REFERENCES dbo.Shop(ShopId)
	,	PriceDate				DATE			NOT NULL
	,	Price					MONEY			NOT NULL	
	);
END

-- Check and create EmailRecipient table
IF NOT EXISTS ( SELECT 1 FROM sys.tables WHERE [name] = 'EmailRecipient' )
BEGIN
	CREATE TABLE dbo.EmailRecipient
	(
		EmailId			INT				NOT NULL	IDENTITY CONSTRAINT [PK_EmailRecipient] PRIMARY KEY
	,	EmailAddress	VARCHAR(255)	NOT NULL
	);
END

-- INDEXES
-- Check and create ItemId index on ItemWebPage table
IF NOT EXISTS ( SELECT 1 FROM sys.indexes WHERE [name] = 'IX_ItemWebPage_ItemId' )
BEGIN
	CREATE INDEX IX_ItemWebPage_ItemId ON dbo.ItemWebPage (ItemId)
END

-- Check and create ShopId index on Item table
IF NOT EXISTS ( SELECT 1 FROM sys.indexes WHERE [name] = 'IX_ItemWebPage_ShopId' )
BEGIN
	CREATE INDEX IX_ItemWebPage_ShopId ON dbo.ItemWebPage (ShopId)
END

-- Check and create ShopId index on ItemPriceHistory table
IF NOT EXISTS ( SELECT 1 FROM sys.indexes WHERE [name] = 'IX_ItemPriceHistory_ItemId' )
BEGIN
	CREATE INDEX IX_ItemPriceHistory_ItemId ON dbo.ItemPriceHistory (ItemId)
END

-- Remove any existing stored procedures, then recreate
IF EXISTS ( SELECT 1 FROM sys.objects WHERE name = 'usp_GetItemsToCompare' )
BEGIN
	DROP PROCEDURE dbo.usp_GetItemsToCompare;
END
GO

CREATE PROCEDURE dbo.usp_GetItemsToCompare
AS

BEGIN

	SELECT	s.ShopId
		,	s.Name 		AS ShopName
		,	i.ItemId
		,	i.Name 		AS ItemName
		,	iwp.PageURL
		,	COALESCE(iwp.PriceOverrideTag, iwp.PriceTag)			AS PriceTag
		,	COALESCE(iwp.PriceOverrideTagType, iwp.PriceTagType)	AS PriceTagType
		,	COALESCE(iwp.PriceOverrideTagName, iwp.PriceTagName)	AS PriceTagName		
	FROM	dbo.Shop 	AS s 
	JOIN	dbo.ItemWebPage	AS iwp ON iwp.ShopId = s.ShopId
	JOIN	dbo.Item 	AS i ON i.ItemId = iwp.ItemId;

END
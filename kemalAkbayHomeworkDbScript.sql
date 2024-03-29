USE [master]
GO
/****** Object:  Database [kemalAkbayHomeworkDb]    Script Date: 15.07.2022 19:06:14 ******/
CREATE DATABASE [kemalAkbayHomeworkDb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'kemalAkbayHomeworkDb', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\kemalAkbayHomeworkDb.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'kemalAkbayHomeworkDb_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\kemalAkbayHomeworkDb_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [kemalAkbayHomeworkDb].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET ARITHABORT OFF 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET  DISABLE_BROKER 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET RECOVERY FULL 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET  MULTI_USER 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET DB_CHAINING OFF 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'kemalAkbayHomeworkDb', N'ON'
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET QUERY_STORE = OFF
GO
USE [kemalAkbayHomeworkDb]
GO
/****** Object:  UserDefinedFunction [dbo].[GetTopParentCategoryId]    Script Date: 15.07.2022 19:06:14 ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Bir kategorinin en üst kategorisini bulmak için kullanılır.
CREATE FUNCTION [dbo].[GetTopParentCategoryId]
( 
  @categoryId int
)
RETURNS int
AS
BEGIN
  
  DECLARE @topParentCategoryId int
  DECLARE @parentCategoryId int=@categoryId
  while(@parentCategoryId>0)
  begin
   select @parentCategoryId= ParentCategoryId from Categories where Id=@parentCategoryId
   set @topParentCategoryId=ISNULL(@parentCategoryId,@topParentCategoryId)
  end
 
  RETURN ISNULL(@topParentCategoryId,@categoryId)
END



 
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 15.07.2022 19:06:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](350) NULL,
	[ParentCategoryId] [int] NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[getSubCategoryIds]    Script Date: 15.07.2022 19:06:14 ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Bir kategorinin bütün alt kategorilerini döndürür.
CREATE FUNCTION [dbo].[getSubCategoryIds](@CategoryId INT)

RETURNS TABLE

AS RETURN

WITH RCTE AS 
(
    SELECT * , Id AS TopLevelParent
    FROM Categories c

    UNION ALL

    SELECT c.* , r.TopLevelParent
    FROM Categories c
    INNER JOIN RCTE r ON c.ParentCategoryId = r.Id
)
SELECT 
  r.TopLevelParent AS ParentID
, r.Id AS ChildID 
FROM RCTE r
where r.TopLevelParent=@CategoryId
GO
/****** Object:  Table [dbo].[Brands]    Script Date: 15.07.2022 19:06:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Brands](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Brands] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Colors]    Script Date: 15.07.2022 19:06:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Colors](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Colors] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductDetails]    Script Date: 15.07.2022 19:06:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[UnitsInStock] [int] NOT NULL,
	[UnitPrice] [decimal](16, 2) NOT NULL,
	[IsContinue] [bit] NOT NULL,
	[SizeId] [int] NULL,
 CONSTRAINT [PK_ProductDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 15.07.2022 19:06:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[ColorId] [int] NULL,
	[BrandId] [int] NULL,
	[GenderId] [smallint] NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sizes]    Script Date: 15.07.2022 19:06:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sizes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Sizes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Genders]    Script Date: 15.07.2022 19:06:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Genders](
	[Id] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Genders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_ProductDetails]    Script Date: 15.07.2022 19:06:14 ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Ürün detaylarını döndürür.
Create View [dbo].[v_ProductDetails]
as
select p.Id as ProductId
,c.Id as CategoryId
,c.Name as CategoryName ,
p.Name as ProductName
,pd.UnitsInStock as UnitsInStock
,pd.UnitPrice as UnitPrice
,clr.Name as Color
,b.Name as Brand
,g.Name as Gender
,s.Description as Size 
from Products p
join ProductDetails pd on p.Id=pd.ProductId
left join Categories c on c.Id=p.CategoryId
left join Colors clr on clr.Id=p.ColorId
left join Brands b on b.Id=p.BrandId
left join Genders g on g.Id=p.GenderId
left join Sizes s on s.Id=pd.SizeId
GO
SET IDENTITY_INSERT [dbo].[Brands] ON 

INSERT [dbo].[Brands] ([Id], [Name]) VALUES (1, N'Mavi')
INSERT [dbo].[Brands] ([Id], [Name]) VALUES (2, N'Avva')
INSERT [dbo].[Brands] ([Id], [Name]) VALUES (3, N'Loft')
INSERT [dbo].[Brands] ([Id], [Name]) VALUES (4, N'Adidas')
INSERT [dbo].[Brands] ([Id], [Name]) VALUES (5, N'Nike')
INSERT [dbo].[Brands] ([Id], [Name]) VALUES (6, N'Pegasus')
SET IDENTITY_INSERT [dbo].[Brands] OFF
GO
SET IDENTITY_INSERT [dbo].[Categories] ON 

INSERT [dbo].[Categories] ([Id], [Name], [Description], [ParentCategoryId]) VALUES (1, N'Dress', N'Dress', NULL)
INSERT [dbo].[Categories] ([Id], [Name], [Description], [ParentCategoryId]) VALUES (2, N'Tshirt', N'Tshirt', 1)
INSERT [dbo].[Categories] ([Id], [Name], [Description], [ParentCategoryId]) VALUES (3, N'Pants', N'Pants', 1)
INSERT [dbo].[Categories] ([Id], [Name], [Description], [ParentCategoryId]) VALUES (4, N'Shoe', N'Shoe', NULL)
INSERT [dbo].[Categories] ([Id], [Name], [Description], [ParentCategoryId]) VALUES (5, N'Sneakers', N'Sneakers', 4)
INSERT [dbo].[Categories] ([Id], [Name], [Description], [ParentCategoryId]) VALUES (6, N'Slipper', N'Slipper', 4)
INSERT [dbo].[Categories] ([Id], [Name], [Description], [ParentCategoryId]) VALUES (7, N'Sandals', N'Sandals', 4)
INSERT [dbo].[Categories] ([Id], [Name], [Description], [ParentCategoryId]) VALUES (8, N'Book', N'Book', NULL)
INSERT [dbo].[Categories] ([Id], [Name], [Description], [ParentCategoryId]) VALUES (9, N'History', N'History', 8)
INSERT [dbo].[Categories] ([Id], [Name], [Description], [ParentCategoryId]) VALUES (10, N'Economy', N'Economy', 8)
INSERT [dbo].[Categories] ([Id], [Name], [Description], [ParentCategoryId]) VALUES (11, N'Programming', N'Programming', 8)
INSERT [dbo].[Categories] ([Id], [Name], [Description], [ParentCategoryId]) VALUES (12, N'Jean', N'Jean Pants', 3)
SET IDENTITY_INSERT [dbo].[Categories] OFF
GO
SET IDENTITY_INSERT [dbo].[Colors] ON 

INSERT [dbo].[Colors] ([Id], [Name]) VALUES (1, N'Black')
INSERT [dbo].[Colors] ([Id], [Name]) VALUES (2, N'Blue')
INSERT [dbo].[Colors] ([Id], [Name]) VALUES (3, N'Red')
INSERT [dbo].[Colors] ([Id], [Name]) VALUES (4, N'Navy Blue')
SET IDENTITY_INSERT [dbo].[Colors] OFF
GO
SET IDENTITY_INSERT [dbo].[Genders] ON 

INSERT [dbo].[Genders] ([Id], [Name]) VALUES (1, N'Male')
INSERT [dbo].[Genders] ([Id], [Name]) VALUES (2, N'Female')
INSERT [dbo].[Genders] ([Id], [Name]) VALUES (3, N'Boy')
INSERT [dbo].[Genders] ([Id], [Name]) VALUES (4, N'Girl')
INSERT [dbo].[Genders] ([Id], [Name]) VALUES (5, N'Unisex')
SET IDENTITY_INSERT [dbo].[Genders] OFF
GO
SET IDENTITY_INSERT [dbo].[ProductDetails] ON 

INSERT [dbo].[ProductDetails] ([Id], [ProductId], [UnitsInStock], [UnitPrice], [IsContinue], [SizeId]) VALUES (1, 1, 10, CAST(100.00 AS Decimal(16, 2)), 1, 2)
INSERT [dbo].[ProductDetails] ([Id], [ProductId], [UnitsInStock], [UnitPrice], [IsContinue], [SizeId]) VALUES (2, 1, 5, CAST(100.00 AS Decimal(16, 2)), 1, 3)
INSERT [dbo].[ProductDetails] ([Id], [ProductId], [UnitsInStock], [UnitPrice], [IsContinue], [SizeId]) VALUES (3, 1, 3, CAST(100.00 AS Decimal(16, 2)), 1, 4)
INSERT [dbo].[ProductDetails] ([Id], [ProductId], [UnitsInStock], [UnitPrice], [IsContinue], [SizeId]) VALUES (4, 2, 50, CAST(790.00 AS Decimal(16, 2)), 1, 13)
INSERT [dbo].[ProductDetails] ([Id], [ProductId], [UnitsInStock], [UnitPrice], [IsContinue], [SizeId]) VALUES (5, 2, 5, CAST(750.00 AS Decimal(16, 2)), 1, 14)
INSERT [dbo].[ProductDetails] ([Id], [ProductId], [UnitsInStock], [UnitPrice], [IsContinue], [SizeId]) VALUES (6, 3, 20, CAST(299.95 AS Decimal(16, 2)), 1, 18)
INSERT [dbo].[ProductDetails] ([Id], [ProductId], [UnitsInStock], [UnitPrice], [IsContinue], [SizeId]) VALUES (7, 3, 15, CAST(299.95 AS Decimal(16, 2)), 1, 19)
SET IDENTITY_INSERT [dbo].[ProductDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[Products] ON 

INSERT [dbo].[Products] ([Id], [CategoryId], [Name], [ColorId], [BrandId], [GenderId]) VALUES (1, 2, N'Mavi Basic Tshirt', 4, 1, 1)
INSERT [dbo].[Products] ([Id], [CategoryId], [Name], [ColorId], [BrandId], [GenderId]) VALUES (2, 5, N'Star Runner 3 Sneakers', 1, 5, 5)
INSERT [dbo].[Products] ([Id], [CategoryId], [Name], [ColorId], [BrandId], [GenderId]) VALUES (3, 12, N'Women pants', 1, 3, 2)
SET IDENTITY_INSERT [dbo].[Products] OFF
GO
SET IDENTITY_INSERT [dbo].[Sizes] ON 

INSERT [dbo].[Sizes] ([Id], [Description]) VALUES (1, N'XS')
INSERT [dbo].[Sizes] ([Id], [Description]) VALUES (2, N'S')
INSERT [dbo].[Sizes] ([Id], [Description]) VALUES (3, N'M')
INSERT [dbo].[Sizes] ([Id], [Description]) VALUES (4, N'L')
INSERT [dbo].[Sizes] ([Id], [Description]) VALUES (5, N'XL')
INSERT [dbo].[Sizes] ([Id], [Description]) VALUES (6, N'XXL')
INSERT [dbo].[Sizes] ([Id], [Description]) VALUES (7, N'37')
INSERT [dbo].[Sizes] ([Id], [Description]) VALUES (8, N'38')
INSERT [dbo].[Sizes] ([Id], [Description]) VALUES (9, N'39')
INSERT [dbo].[Sizes] ([Id], [Description]) VALUES (10, N'40')
INSERT [dbo].[Sizes] ([Id], [Description]) VALUES (11, N'41')
INSERT [dbo].[Sizes] ([Id], [Description]) VALUES (12, N'42')
INSERT [dbo].[Sizes] ([Id], [Description]) VALUES (13, N'43')
INSERT [dbo].[Sizes] ([Id], [Description]) VALUES (14, N'44')
INSERT [dbo].[Sizes] ([Id], [Description]) VALUES (15, N'45')
INSERT [dbo].[Sizes] ([Id], [Description]) VALUES (16, N'25/27')
INSERT [dbo].[Sizes] ([Id], [Description]) VALUES (17, N'26/27')
INSERT [dbo].[Sizes] ([Id], [Description]) VALUES (18, N'27/27')
INSERT [dbo].[Sizes] ([Id], [Description]) VALUES (19, N'27/29')
SET IDENTITY_INSERT [dbo].[Sizes] OFF
GO
ALTER TABLE [dbo].[ProductDetails] ADD  CONSTRAINT [DF_ProductDetails_IsContinue]  DEFAULT ((1)) FOR [IsContinue]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAllProductByCategoryId]    Script Date: 15.07.2022 19:06:14 ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--kategori id ile kendine ait ve  tüm alt kategorilerine ait olan ürünleri döndürür. 
Create Proc [dbo].[sp_GetAllProductByCategoryId]
(@categoryId int)
as
begin
select * from [dbo].[v_ProductDetails] where CategoryId in (select ChildId from [dbo].[getSubCategoryIds](@categoryId))
end


GO
USE [master]
GO
ALTER DATABASE [kemalAkbayHomeworkDb] SET  READ_WRITE 
GO

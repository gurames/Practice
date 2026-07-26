-- TourismDB.sql
USE master;
GO

IF DB_ID('TourismWebDB') IS NOT NULL DROP DATABASE TourismWebDB;
GO

CREATE DATABASE TourismWebDB;
GO

USE TourismWebDB;
GO

-- Таблица клиентов (справочник)
CREATE TABLE Clients (
    ClientID INT IDENTITY(1,1) PRIMARY KEY,
    LastName NVARCHAR(50) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    Patronymic NVARCHAR(50) NULL,
    PassportNumber NVARCHAR(20) UNIQUE NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100) NULL,
    BirthDate DATE NOT NULL,
    IsActive BIT DEFAULT 1
);

-- Таблица направлений (справочник)
CREATE TABLE Destinations (
    DestinationID INT IDENTITY(1,1) PRIMARY KEY,
    Country NVARCHAR(100) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    HotelName NVARCHAR(200) NOT NULL,
    HotelStars INT DEFAULT 3 CHECK (HotelStars BETWEEN 1 AND 5),
    Description NVARCHAR(MAX) NULL
);

-- Таблица услуг (справочник)
CREATE TABLE Services (
    ServiceID INT IDENTITY(1,1) PRIMARY KEY,
    ServiceName NVARCHAR(100) NOT NULL,
    ServiceType NVARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    IsAvailable BIT DEFAULT 1
);

-- Таблица заказов (переменная информация)
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    ClientID INT NOT NULL,
    DestinationID INT NOT NULL,
    ServiceID INT NOT NULL,
    
    OrderDate DATETIME DEFAULT GETDATE(),
    TourStartDate DATE NOT NULL,
    TourEndDate DATE NOT NULL,
    TravelersCount INT NOT NULL CHECK (TravelersCount >= 1),
    TotalPrice DECIMAL(12,2) NOT NULL CHECK (TotalPrice >= 0),
    DiscountPercent DECIMAL(5,2) DEFAULT 0,
    FinalPrice AS (TotalPrice * (1 - DiscountPercent/100)) PERSISTED,
    Status NVARCHAR(20) DEFAULT 'новый',
    PaymentStatus NVARCHAR(20) DEFAULT 'не оплачен',
    
    CONSTRAINT FK_Orders_Clients FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    CONSTRAINT FK_Orders_Destinations FOREIGN KEY (DestinationID) REFERENCES Destinations(DestinationID),
    CONSTRAINT FK_Orders_Services FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID)
);

-- Тестовые данные
INSERT INTO Clients (LastName, FirstName, PassportNumber, Phone, BirthDate) VALUES 
('Иванов', 'Иван', '1234 567890', '+7(999)111-22-33', '1985-05-15'),
('Петрова', 'Елена', '2345 678901', '+7(999)222-33-44', '1990-08-22');

INSERT INTO Destinations (Country, City, HotelName, HotelStars) VALUES
('Турция', 'Анталия', 'Sun Paradise Resort', 5),
('Египет', 'Шарм-эль-Шейх', 'Red Sea Palace', 4);

INSERT INTO Services (ServiceName, ServiceType, Price) VALUES
('Трансфер из аэропорта', 'трансфер', 50.00),
('Полупансион', 'питание', 120.00);
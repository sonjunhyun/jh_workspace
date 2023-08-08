CREATE DATABASE transfer_market CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE transfer_market;

GRANT ALL PRIVILEGES ON transfer_market.* TO leoni@localhost;

CREATE TABLE Player(
    `PlayerId` INT PRIMARY KEY,
    `PlayerName` VARCHAR(64),
    `Age` INT,
    `Nation` VARCHAR(32),
    `Position` VARCHAR(32),
    `MarketValue` INT
);

CREATE TABLE Transfer(
    `TransferId` INT PRIMARY KEY,
    `PlayerId` INT,
    `PlayerName` VARCHAR(64),
    `TransferDate` DATE,
    `Fee` INT,
    `Left` VARCHAR(32),
    `Joined` VARCHAR(32),
    `TransferType` VARCHAR(16),
    FOREIGN KEY(PlayerId)
    REFERENCES Player(PlayerId)
);
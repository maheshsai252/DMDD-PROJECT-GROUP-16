USE master;
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Password@123#';

CREATE CERTIFICATE MyServerCert WITH SUBJECT = 'My DEK Certificate';
-- SELECT * FROM sys.certificates WHERE name = 'MyServerCert';
-- SELECT * FROM sys.server_principals WHERE name = 'sa';
USE InventoryManagement;

GRANT VIEW DEFINITION ON CERTIFICATE::MyServerCert TO SA;

CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE MyServerCert;

ALTER DATABASE InventoryManagement
SET ENCRYPTION ON;

ALTER TABLE Customer
ADD customer_email_encrypted VARBINARY(100),
    customer_phone_number_encrypted VARBINARY(40);

UPDATE Customer
SET customer_phone_number_encrypted = ENCRYPTBYPASSPHRASE('EncryptionPassphrase', customer_phone_number);


-- Retrieve decrypted data from an encrypted column
SELECT 
    customer_email_encrypted,
    CONVERT(varchar, DECRYPTBYPASSPHRASE('EncryptionPassphrase', customer_email_encrypted)) AS decrypted_email
FROM 
    Customer;


-- Set up database encryption
-- Create a master key for encryption with a strong password
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Password@123#';

-- Check if the certificate for customer data encryption exists, if not, create it
IF NOT EXISTS (SELECT * FROM sys.certificates WHERE name = 'CustomerDataCert')
    CREATE CERTIFICATE CustomerDataCert WITH SUBJECT = 'Customer Data Encryption Certificate';

-- Create a symmetric key for customer data encryption using AES-256 algorithm and encrypt it with the certificate
CREATE SYMMETRIC KEY cuskey  
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE CustomerDataCert;  

-- Alter the Customer table to add encrypted columns for email and phone number
ALTER TABLE customer  
    ADD customer_email_enc varbinary(128),
    customer_phone_enc varbinary(128); 

-- Open the symmetric key for decryption
OPEN SYMMETRIC KEY cuskey  
   DECRYPTION BY CERTIFICATE CustomerDataCert;  

-- Update the Customer table to encrypt existing email and phone number data
UPDATE Customer  
SET 
    customer_email_enc = EncryptByKey(Key_GUID('cuskey'), customer_email),
    customer_phone_enc = EncryptByKey(Key_GUID('cuskey'), customer_phone_number);

-- Close the symmetric key after encryption
CLOSE SYMMETRIC KEY cuskey;

-- Open the symmetric key again for decryption
OPEN SYMMETRIC KEY cuskey  
   DECRYPTION BY CERTIFICATE CustomerDataCert;  

-- Select decrypted email and phone number from the Customer table
SELECT customer_email_enc, customer_phone_enc,  
    CONVERT(varchar, DecryptByKey(customer_phone_enc))   
    AS 'Decrypted Phone Number',
    CONVERT(varchar, DecryptByKey(customer_email_enc))   
    AS 'Decrypted email'  
    FROM Customer;  

-- Alter the Customer table to drop the original email and phone number columns
ALTER TABLE customer
DROP COLUMN customer_email;

ALTER TABLE customer
DROP COLUMN customer_phone_number;

-- Rename the encrypted columns to replace the original ones
EXEC sp_rename 'customer.customer_email_enc', 'customer_email', 'COLUMN';

EXEC sp_rename 'customer.customer_phone_enc', 'customer_phone_number', 'COLUMN';

-- Select decrypted phone numbers for all customers
SELECT customer_id, customer_phone_number, CONVERT(varchar, DecryptByKey(customer_phone_number))   
    AS 'Decrypted Phone Number' from Customer;

-- Insert a new customer record with encrypted email and phone number
INSERT INTO Customer (customer_name, customer_email, customer_phone_number)
VALUES (
    'Mahesh',
    EncryptByKey(Key_GUID('cuskey'), 'Mahesh@example.com'),
    EncryptByKey(Key_GUID('cuskey'), '123-456-9090')
);

-- Select decrypted email and phone number for the newly inserted customer
SELECT customer_id, CONVERT(varchar, DecryptByKey(customer_email)) , CONVERT(varchar, DecryptByKey(customer_phone_number))   
    AS 'Decrypted Phone Number' from Customer where customer_name = 'Mahesh';

# Models

## User:
  - `id = [unsigned long]`
  - `name = [string]`
  - `surname = [string]`
  - `mail = [string]`
  - `password = [string]`
  - `phone = [string]`
  - `birthday = [string]`
  - `gender = [M|F|U]`
  - `signupDate = [date-iso8601]`
  - `tokenFCM = [string]`
  - `os = [ios|android]`
  - `language = [string]`
  - `lastActivity = [date-iso8601]`
  - `unsubscribed = [bool]`
  - `stripeID = [string]`
  
## Register data request
  - `name = [string]`
  - `surname = [string]`
  - `mail = [string]`
  - `password = [string]`
  - `phone = [string]`
  - `birthday = [string]`
  - `gender = [M|F|U]`
  - `tokenFCM = [string]`
  - `os = [ios|android]`
  - `language = [string]`
  
## Register data response
  - `id = [unsigned long]`
  - `name = [string]`
  - `surname = [string]`
  - `phone = [string]`
  - `birthday = [string]`
  - `gender = [M|F|U]`
  - `stripeID = [string]`
 
 ## Login request
  - `mail = [string]`
  - `password = [string]`
  
## Login response
  - `id = [unsigned long]`
  - `name = [string]`
  - `surname = [string]`
  - `phone = [string]`
  - `birthday = [string]`
  - `gender = [M|F|U]`
  - `stripeID = [string]`
  
## Profile request
  - `name = [string]`
  - `surname = [string]`
  - `phone = [string]`
  - `birthday = [string]`
  - `gender = [M|F|U]`

## Locker
  - `id = [long]`
  - `number = [int8]`
  - `key = [int8]`
  - `available = [bool]`
  - `capacity = [S|M]`
  
## Location
  - `latitude = [double]`
  - `longitude = [double]`
  - `name = [string]`

## Hamp point
  - `location = [Location]`
  - `CP = [integer 5 digits]`
  - `address = [string]`
  - `city = [string]`
  - `lockers = [Array<Lockers>]`
  
## Service
  - `id = [unsigned long]`
  - `active = [bool]`
  - `name = [string]`
  - `description = [string]`
  - `imageURL = [url firebase]`
  - `price = [double]`
  - `size = [S|M]`
  
  
## Hired service
  - `service = [Service]`
  - `quantity = [integer]`
  
## Basket 
  - `hiredServices = [Array<Services>]`
  
## Order
  - `id = [unsigned long]`
  - `userID = [string]`
  - `basket = [Basket]`
  - `price = [string]`
  - `location = [Location]`
  - `pickUpTime = [Morning|Afternoon]`
  - `deliveryLocker = [Locker]`
  - `pickUpLocker = [Locker]`
  - `location = [Location]`

## Transaction
  - `id = [long]`
  - `order = [Order]`
  - `creditCardIdentifier = [string]`
  - `date = [date - iso8601]`
  
## History
  - `transactions = [Array<Transaction>]`
  

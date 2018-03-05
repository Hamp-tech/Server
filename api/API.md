# Hampy

**API endpoint**

```
Development: http://localhost:8181/api/v1
```
```
Production: http://usehamp.io/api/v1
```

**Content-Type**
```
application/json
```

### Description

### Auth
**Sign in**
```
POST: /auth/signin
```
> Request
``` json
{
	"email" : "elon@usehamp.io",
	"password" : "1234567890"
}
```
> Response
``` json
{
    "message": "",
    "data": {
        "cards": [],
        "surname": "Musk",
        "email": "elon@usehamp.io",
        "identifier": "92da06f492c3435b883d845df00dacd4",
        "name": "Elon"
    },
    "code": 200
}
```


**Sign up**
```
POST: /auth/signup
```

> Request
``` json
{
	"name" : "Elon",
	"surname" : "Musk",
	"email" : "elon@usehamp.io",
	"password" : "1234567890",
	"phone" : "666777888",
	"gender" : "M",
	"tokenFCM" : "834hhfjkhsdkhsfk8348738975hf",
	"os" : "ios",
	"language" : "esES"
}
```

> Response
``` json
{
    "message": "",
    "data": {
        "phone": "666777888",
        "gender": "M",
        "stripeID": "cus_CK7cQdXY17w9Mc",
        "cards": [],
        "surname": "Musk",
        "email": "elon@usehamp.io",
        "identifier": "92da06f492c3435b883d845df00dacd4",
        "name": "Elon"
    },
    "code": 200
}
```


**Restore pass**
```
POST: /auth/{userid}/restore
```
``` json
    TODO    
```

### User
**Update**
```
PUT: /users/{userid}
```
> Example request
``` json
{
	"name" : "Mark"
}
```

> Response
``` json
{
    "message": "User updated successfully",
    "code": 200
}
```

**Create credit card**
```
POST: /users/{userid}/cards/
```
> Request
```json
{
	"number": "4242424242424242",
	"exp_month": 12,
	"exp_year": 23,
	"cvc": "444"
}
```
> Response
``` json
{
    "message": "Card created successfully",
    "data": {
        "id": "card_1BvTevCiVhDLJHAGKCrxIASm",
        "number": "4242",
        "exp_year": 23,
        "exp_month": 12
    },
    "code": 200
}
```

**Remove credit card**
```
DELETE: /users/{userid}/cards/{cardid}
```
> Response
``` json
{
    "message": "Card removed sucessfully",
    "code": 200
}
```

### Transaction

**Create**
```
POST: /users/{userid}/transactions
```
> Request
``` json
{
    "creditCard" : {
    	"id": "card_1C0CYpCiVhDLJHAGt2bsx9mW"	
    },
    "booking": {
        "basket": [
            {
                "service" : "1",
                "amount" : 2
            }
        ],
        "price": 26,
        "point": {
        	"identifier": "1"	
        },
        "pickUpTime": "1"
    }
}
```
> Response
``` json
{
    "message": "Services booked",
    "data": {
        "creditCard": {
            "number": "4242",
            "exp_month": 12,
            "exp_year": 23
        },
        "userID": "126fb593b8374dfcb2225bd0d9779a12",
        "identifier": "b9ebe71c6bda4924a6f660c1c3d964e6",
        "pickUpDate": "2018-03-05T22:14:29.180",
        "booking": {
            "pickUpLockers": [
                {
                    "code": "1111",
                    "number": 1,
                    "identifier": "1",
                    "available": true,
                    "capacity": "S"
                }
            ],
            "pickUpTime": "1",
            "basket": [
                {
                    "service": "1",
                    "amount": 2
                }
            ],
            "price": 26,
            "point": {
                "city": "El Vendrell",
                "CP": "43700",
                "identifier": "1",
                "location": {
                    "name": "1",
                    "longitude": 0,
                    "latitude": 0
                },
                "address": "C? foo bar 1"
            }
        }
    },
    "code": 200
}	
```

**All transactions from user**
```
GET: /users/{userid}/transactions/
```
> Response
``` json
{
    "message": "",
    "data": [
        {
            "userID": "92da06f492c3435b883d845df00dacd",
            "creditCardIdentifier": "card_1BvTiFCiVhDLJHAGw2bqSUei",
            "lastActivity": "2018-02-14T17:07:58.278",
            "booking": {
                "pickUpLockers": [
                    {
                        "code": "1111",
                        "number": 1,
                        "identifier": "1",
                        "available": true,
                        "capacity": "S"
                    }
                ],
                "pickUpTime": "1",
                "basket": [
                    {
                        "service": "1",
                        "amount": 1
                    }
                ],
                "price": 13,
                "point": "1"
            },
            "created": "2018-02-14T17:07:58.278",
            "identifier": "27691f3a0f8546d18b665f96111441fa",
            "pickUpDate": "2018-02-14T17:07:52.920"
        }
    ],
    "code": 200
}
```

**Deliver**
```
POST: /users/{userid}/transactions/{transactionid}/deliver
```
> Request
``` json
{
	"point": "1",
	"deliveryLockers" : [
			{
				"number" : 1
			}
		]
}
```
> Response
```json
{
    "message": "",
    "data": {
        "userID": "92da06f492c3435b883d845df00dacd",
        "creditCardIdentifier": "card_1BvTiFCiVhDLJHAGw2bqSUei",
        "lastActivity": "2018-02-14T17:07:58.278",
        "booking": {
            "deliveryLockers": [
                {
                    "code": "1111",
                    "number": 1,
                    "identifier": "1",
                    "available": false,
                    "capacity": "S"
                }
            ],
            "pickUpLockers": [
                {
                    "code": "1111",
                    "number": 1,
                    "identifier": "1",
                    "available": true,
                    "capacity": "S"
                }
            ],
            "pickUpTime": "1",
            "basket": [
                {
                    "service": "1",
                    "amount": 1
                }
            ],
            "price": 13,
            "point": "1"
        },
        "deliveryDate": "2018-02-14T17:12:12.408",
        "identifier": "27691f3a0f8546d18b665f96111441fa",
        "created": "2018-02-14T17:07:58.278",
        "pickUpDate": "2018-02-14T17:07:52.920"
    },
    "code": 200
}
```

**Update phase**
```
PUT: /users/{userid}/transactions/{transactionid}
```
> Request
``` json
{
	"phase": 2
}
```

### Scripts

**Create default services**
```
POST: /scripts/services/create
```

**Create default points**
```
POST: /scripts/hamppoints/create
```

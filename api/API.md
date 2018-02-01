# Hampy

**API endpoint**
```
http://localhost:8181
```

### Description

### Auth
**Sign in**
```
POST: /api/v1/auth/signin
```

**Sign up**
```
POST: /api/v1/auth/signup
```

**Restore pass**
```
POST: /api/v1/auth/{userid}/restore
```

### User
**Update**
```
PUT: /api/v1/users/{userid}
```

### Transaction

**Create**
```
POST: /api/v1/users/{userid}/transactions
```

**All transactions from user**
```
GET: /api/v1/users/{userid}/transactions/
```

**Deliver**
```
POST: /api/v1/users/{userid}/transactions/{transactionid}/deliver
```

**Update phase**
```
PUT: /api/v1/users/{userid}/transactions/{transactionid}
```

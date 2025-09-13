# Recherche technique

## Points à explorer

- Bonnes pratiques Flutter pour la sécurité par mot de passe
- Gestion des erreurs réseau et format de données
- UI/UX fintech moderne (exemples d’images à demander)
- Structuration des entités (CompteUtilisateur, CompteBancaire, Retrait)
- Approche pour la gestion des retraits et validation

## Décisions à prendre

- Méthode de stockage du mot de passe
- Format et parsing du fichier de comptes
- Endpoints API à définir



## Réponses

- Le mot de passe doit être une suite de 6 caractères numériques;
- Le flow d'exécution est le suivant, lorsqu'un utilisateur initie un retrait, l'application se connecte en utilisant le numéro de téléphone et le mot de passe du comptebancaire sélectionné. Une fois le token obtenu, l'application exécute une requête qui retire le montant requis du compte bancaire vers le compte wallet de l'utilisateur;
- Puis une requête est exécutée pour effectuer le retrait du compte wallet vers le numéro de téléphone spécifié par l'utilisateur.




## Liste des endpoints et des paramètres

### Connexion

- https://digitalv2.afrilandfirstbank.com/user-management/api-public/auth/login
- Type de requête : POST
- Headers:
    - Content-Type : application/x-www-form-urlencoded; charset=utf-8
    - User-Agent : Dalvik/2.1.0 (Linux; U; Android 13; Infinix X6528 Build/TP1A.220624.014)
    - sara-api-key : WYhfwpmOOGLdUR0sgjDd1aCNm1HMUikf
- Body : 
    client_id: PUBLIC_CLIENT
    grant_type: password
    username: c_237655389916
    password: 123456

- Réponse:
    {
        "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6InNzb19vaWRjX2tleV9wYWlyXzAxSzBZVjBTS1dXQkU3NDBKQVJRODY4OU1YIn0.eyJhdWQiOiJjbGllbnRfMDFLMFlWMFNOUFJZSjVBVjRBUzBWRzdUMUoiLCJ3b3Jrb3NfZW1haWwiOiJlbWFyYzIzN0BnbWFpbC5jb20iLCJjb252ZXhfbWVtYmVyX2lkIjoiOTg5OTUiLCJpc3MiOiJodHRwczovL2FwaWF1dGguY29udmV4LmRldi91c2VyX21hbmFnZW1lbnQvY2xpZW50XzAxSzBZVjBTTlBSWUo1QVY0QVMwVkc3VDFKIiwic3ViIjoidXNlcl8wMUszN0pKTTYwR0QzNkNaMThRM1lGWEpUViIsInNpZCI6InNlc3Npb25fMDFLNFlZUVdNOE5LNlkxWUE0QzM5RlFNQ0EiLCJqdGkiOiIwMUs0WVlRWFpLMFdaSFY5TTMzUEZFM1paWCIsImV4cCI6MTc1Nzc2Njg5OCwiaWF0IjoxNzU3NjgwNDk4fQ.pAGTBPm98MN0OQRVZM9i0r62eHjPeGPnHU-hrpkWc-Y0WCRK3iw-zOkzq0Ljh_BnHG34LE7VZjXx4cIaMWJttUZl8V17liMVKrdyt0rM9qUM7J40MCTj56fKkceyzzSXWmOIXIjpo4evNNe-uj6LgjqTUzbPwYEzsJ1zzhJEwwdRqq2DhgbQxXuECAWGDq1P69d71NazQ3iJ6KoaL29nnjmk7pA6grfExZ2eE9wVrswJx9IIJ7O_5k1ttnV9iQmI_L2hjXIb40H8kfO0W7d2REaBIV8AmAEgfogvcBe2CWvdWchN5RpZII9xy_TvtIErF_SyVhcmJNxs0w9lb9iTlg"
        "token_type": "bearer",
        "expires_in": 3600
    }

### Bank to Wallet Withdrawal   

- https://digitalv2.afrilandfirstbank.com/wallet-management/api/wallets/topUp/afriland
- Type de requête : POST
- Headers:
    - Content-Type : application/json
    - User-Agent : Dalvik/2.1.0 (Linux; U; Android 13; Infinix X6528 Build/TP1A.220624.014)
    - sara-api-key : WYhfwpmOOGLdUR0sgjDd1aCNm1HMUikf
    - Authorization : Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6 (Token d'authentification obtenue lors de la connexion)
- Body :
    {
        "bankAccount": "10005-00004-00674501101-72", (Numéro de compte bancaire)
        "mfaToken": "123456", (Mot de passe du compte bancaire)
        "validateWithPin": true,
        "confirm": true,
        "description": "Top up through bank",
        "walletTopupReq": {
            "countryCode": "CM",
            "currencyCode": "XAF",
            "amount": "5000" (Montant entré par l'utilisateur)
        },
        "complementInfoDTO": {
            "paymentMethodCode" : "WALLET_CASH_IN_METHOD",
            "channel": "SARA_MOBILE",
            "aggregatorCode": "",
            "partnerCode": "",
            "toMemberCode": "",
            "fromMemberCode": "",
            "toMemberShortName": "",
            "fromMemberShortName": "",
            "externalWalletSource": "237698165685",
            "externalWalletDestination": "237698165685",
            "externalMobileSource": "237698165685",
            "externalMobileDestination": "237698165685",
            "aggregatorTransactionType": "",
            "digitalServiceType": "CASHIN_SM",
            "messengerName": "",
            "messengerPhone": "",
            "paymentMode": "BANK_ACCOUNT"
        },
        "commission": {
            "currencyCode": "XAF",
            "transactionFee": 0.0,
            "feeIds": [
                148
            ],
            "fixedAmount": 0.0,
            "percentageAmount": 0.0,
            "debitSenderAmount": 0.0,
            "ttaAmount": 0.0,
            "status": false,
            "message": "FOND suffisants"
        }
    }

- Réponse Status Code : Need to be 200


### Wallet to Phone Withdrawal

- https://digitalv2.afrilandfirstbank.com/gimac/customer/v2/doTransferToOtherWallet
- Type de requête : POST
- Headers:
    - Content-Type : application/json
    - User-Agent : Dalvik/2.1.0 (Linux; U; Android 13; Infinix X6528 Build/TP1A.220624.014)
    - sara-api-key : WYhfwpmOOGLdUR0sgjDd1aCNm1HMUikf
    - Authorization : Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6 (Token d'authentification obtenue lors de la connexion)
- Body :
    {
        "beneficiaryUserType": "CUSTOMER",
        "beneficiaryWalletName": "FOTSO",
        "recieverPhoneNumber": "650485614", (Numéro de téléphone du bénéficiaire)
        "currencyCode": "XAF",
        "amount": "500000",
        "mfaToken": "123456", (Mot de passe du compte bancaire)
        "reason": "",
        "toMember": "12002", (12001 si c'est un numéro Orange Cameroon, 12002 si c'est un numéro MTN Cameroon)
        "deviceType": "Mobile",
        "deviceUid ": "",
        "saveAsBeneficiary": false,
        "commission": {
            "currencyCode": "XAF",
            "transactionFee": 0.0,
            "feeIds": [
                198
            ],
            "fixedAmount": 0.0,
            "percentageAmount": 0.0,
            "debitSenderAmount": 0.0,
            "ttaAmount": 0.0,
            "status": true,
            "message": "FOND SUFFISANT"
        },
        "validateWithPin": true,
        "confirm": true,
        "complementInfoDTO": {
            "paymentMethodCode": "GIMAC_WALLET_TO_OTHER_WALLET_TRANSFER_METHOD",
            "channel": "SARA_MOBILE",
            "aggregatorCode": "",
            "partnerCode": "",
            "toMemberCode": "",
            "fromMemberCode": "",
            "toMemberShortName": "",
            "fromMemberShortName": "",
            "externalWalletSource": "",
            "externalWalletDestination": "",
            "externalMobileSource": "",
            "externalMobileDestination": "",
            "aggregatorTransactionType": "",
            "digitalServiceType": "WALLET_TO_OTHER_WALLET_TRANSF",
            "messengerName": "",
            "messengerPhone": "",
            "paymentMode": "WALLET"
        }
    }

- Réponse Status Code : Need to be 200


---
id: spike-docs-api
title: OSpike API Routes
---

> **OSpike Base URL:** <i>https://51.144.178.121:1337</i>

## Aquiring Access Token

### Request structure
| HTTP Request Type |         URL         |
|:-----------------:|:-------------------:|
|        POST       |    /oauth2/token    |


|  Header Name  |                                                                                                                                                                        Description                                                                                                                                                                       |                                                     Example                                                    |
|:-------------:|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------------------------------:|
| Authorization |                                       This header contains your authentication by your client credentials.<br> Using **HTTP Basic Authentication** your header will be structured like that:<br> `Authorization: "Basic " + base64(Client_ID + ":" +Client_Secret)`<br> (**Note that space after the word Basic**)                                       | For Client_ID = 1234, Client_Secret = 1234<br> it should look like this:<br> `Authorization: Basic MTIzNDoxMjM0` |
|  Content-Type | This header contains the type of the content you'll should send. <br> We support 2 types:<br> 1. **application/json** - This is the default and best practice type, which indicates your content will be JSON.<br> 2. **application/x-www-form-urlencoded** - This indicates your content will be "x-www-form-urlencoded" (kind of query string format). |                                         `Content-Type: application/json`                                         |
### Parameters
| Parameter Name | Required / Optional |  Type  |                                                           Description                                                           |               Example              |
|:--------------:|:-------------------:|:------:|:-------------------------------------------------------------------------------------------------------------------------------:|:----------------------------------:|
|    audience    |     **Required**    | string |            Audience id of the client that the access token intended for (For who you should send the access token to)           |             `"kartoffel"`            |
|   grant_type   |     **Required**    | string | Grant type of the OAuth2 Flow used in the current situation.<br> **In our case, it should be only "client_credentials" value.** |        `"client_credentials"`        |
|    client_id   |       Optional      | string |               (**NOTE: Use only when you are not using Authorization Header described above**)<br> Your client id               |    `"PPoqk_e231$Aoak12~Eom!pLert"`   |
|  client_secret |       Optional      | string |             (**NOTE: Use only when you are not using Authorization Header described above**)<br> Your client secret             | `"~321ias_eqk1mOop_1pPemRNno2opQLe"` |

### Response structure
| HTTP Status Code | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | Example                                                                                                                                                              |
|:----------------:|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|        200       | Successful response.<br> The structure of the response will be like this:<br> ``` { ```<br> ```   "access_token": "Here should be your access token", ```<br> ``` "expires_in": "Here should be the expiration time for that access token, in seconds format",     ```<br> ```   "token_type": "Here should be the type of the token, basically it will be 'Bearer', means the token intended to be used by passing it (give access to the bearer of this token)." ```<br> ``` } ``` | ``` { ```<br> ``` "access_token": "ekwqoepwqmewpe.ewoqewqpoemqp.ewqneowqemqods", ```<br> ``` "expires_in": 180, ```<br> ``` "token_type": "Bearer" ```<br> ``` } ``` |
|        400       | Bad request given.<br> Probably you'll get information regarding the error occurred in the response body.<br> If you don't receive any, probably check your request parameters and request structure.                                                                                                                                                                                                                                                                                | ```{```<br>```"message": "The audience parameter is missing."```<br>```}```                                                                                           |
|        401       | Unauthorized response.<br> If you get this response, it means you mistype the client credentials of your application, or did not even specified them.<br> Check your **Authorization** header or the body parameters **client_id, client_secret** and make sure they are correct.                                                                                                                                                                                                    | `Unauthorized`                                                                                                                                                         |
|        500       | Internal Server Error.<br> If you get this response, it means that there was unusual error in our server.<br> Please contact us for solving the matter.                                                                                                                                                                                                                                                                                                                              | ```{```<br>```"message": "Internal Server Error"```<br>```}```                                                                                                                           |
|        501       | Unsupported grant type given.<br> Probably you'll mistype the **grant_type** parameter value or did not even specified one.<br> The value should be **client_credentials**.                                                                                                                                                                                                                                                                                                          | ```{```<br>```"message": "Unsupported grant type: client_credentailsss"```<br>```}```                                                                                                    |

### Example of usage
<!--DOCUSAURUS_CODE_TABS-->
<!--NodeJS-->
```js
// Using 'axios' as package for performing POST request (You can use any other library if you want...)
import axios from 'axios';

// Your application credentials (Client ID and Client Secret)
const clientId = 'MY_CLIENT_ID';
const clientSecret = 'MY_CLIENT_SECRET';

// Function for getting access token
async function getAccessToken() {

    // Perform HTTP POST Request to OSpike for Acquiring Access Token
    const response = await axios.post(
        'https://51.144.178.121:1337/oauth2/token',
        { audience: 'AUDIENCE_ID', grant_type: 'client_credentials' },
        { headers: { Authorization: 'Basic ' + Buffer.from(`${clientId}:${clientSecret}`, 'base64') }}
    );

    // In 'axios' the body of the response is in 'data' property, the response should contains JSON like this:
    /**
     * {
     *  access_token: ACCESS_TOKEN_HERE,
     *  expires_in: TIME_IN_SECONDS_FOR_EXPIRATION_OF_THE_TOKEN,
     *  token_type: Bearer
     * }
     * 
     * So in 'access_token' key, should be your access token
     **/
    return response.data.access_token;
}

```
<!--Python-->
```py
# Here we using 'requests' package for HTTP requests (You can use any other library if you want...)
# Also we using 'base64' package for encoding the client id and client secret in 'Authorization' Header
import requests
import base64

# Your application credentials (Client ID and Client Secret)
client_id = b"MY_CLIENT_ID"
client_secret = b"MY_CLIENT_SECRET"

# Making HTTP POST Request for acquiring access token
response = requests.post(
    "https://51.144.178.121:1337/oauth2/token",
    json={"grant_type": "client_credentials", "audience": "AUDIENCE_ID"},
    headers={"Authorization": "Basic " + base64.b64encode(client_id + ':' + client_secret)}
)

# The response should contains JSON like this:
#
# {
#  access_token: ACCESS_TOKEN_HERE,
#  expires_in: TIME_IN_SECONDS_FOR_EXPIRATION_OF_THE_TOKEN,
#  token_type: Bearer
# }
# 
# So in 'access_token' key, should be your access token


# Parsing the response body to json and getting the 'access_token' property which holds the access token
access_token = response.json()['access_token']
```

<!--HTTPS-->
```js
POST https://51.144.178.121:1337/oauth2/token HTTP/1.1
Content-Type: application/json
Authorization: Basic Q0xJRU5UX0lEOkNMSUVOVF9TRUNSRVQ=
{
    "audience": "AUDIENCE_ID",
    "grant_type": "client_credentials"
} 
```
<!--END_DOCUSAURUS_CODE_TABS-->


## Verifying and Getting Information About Access Token
**NOTE:** For your knowledge, the best practice is to actually parse the access token by yourself.
That can be performed because the access token type is **"JWT"**, meaning the information regarding the token, is self contained.
You can check out the [*Example of usage*](/docs/spike-docs-api#example-of-usage-1) below for more information.

### Request structure
| HTTP Request Type |             URL            |
|:-----------------:|:--------------------------:|
|        POST       |      /oauth2/tokeninfo     |


|  Header Name  |                                                                                                                                                                        Description                                                                                                                                                                       |                                                     Example                                                    |
|:-------------:|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------------------------------:|
| Authorization |                                       This header contains your authentication by your client credentials.<br> Using **HTTP Basic Authentication** your header will be structured like that:<br> `Authorization: "Basic " + base64(Client_ID + ":" +Client_Secret)`<br> (**Note that space after the word Basic**)                                       | For Client_ID = 1234, Client_Secret = 1234<br> it should look like this:<br> `Authorization: Basic MTIzNDoxMjM0` |
|  Content-Type | This header contains the type of the content you'll should send. <br> We support 2 types:<br> 1. **application/json** - This is the default and best practice type, which indicates your content will be JSON.<br> 2. **application/x-www-form-urlencoded** - This indicates your content will be "x-www-form-urlencoded" (kind of query string format). |                                         `Content-Type: application/json`                                         |
### Parameters
| Parameter Name | Required / Optional |  Type  |                                         Description                                        |                           Example                           |
|:--------------:|:-------------------:|:------:|:------------------------------------------------------------------------------------------:|:-----------------------------------------------------------:|
|      token     |     **Required**    | string | The access token you want introspect (The access token you want to get information about). | `"ewqioneqnomeqemwqo.ewqokewoqmdonrwq.ewoqkeowqdkoqwmeoqm"` |

### Response structure
| HTTP Status Code | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | Example                                                                                                                                                              |
|:----------------:|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|        200       | Successful response.<br> When the access token is currently valid and not expired, the structure of the response will be like this:<br> ``` { ```<br> ```   "active": "Indicates if the access token is active or not", ```<br> ```   "clientId": "Client id of the client that request that token",     ```<br> ```   "aud": "Audience id of the client that the access token intended for (For who you should send the access token to)", ```<br> ```    "sub": "Subject of the access token, basically means for which entity the access token intended for (The 'user' of the access token)",  ``` <br> ```    "scope": "Array of scopes of the access token, which basically means what privileges you have in that access token, for using the audience client",  ``` <br> ```    "iat": "Time in seconds when the access token initialized",  ``` <br> ```    "exp": "Time in seconds when the access token should be expired",  ``` <br> ```    "iss": "Url of the access token issuer (Who which created this access token and sign on it), It basically our Authorization Server URL (OSpike URL)"  ```<br> ``` } ```<br> When the access token is not valid or expired, the response will be: <br> ```{ "active": false }```<br> **NOTE:** If you mistype or forgot to add the **token** parameter in the request, the response will always be like when you enter access token that is not valid. <br>(Means the response should be: ```{ "active": false }``` ) | ``` { ```<br> ``` "access_token": "ekwqoepwqmewpe.ewoqewqpoemqp.ewqneowqemqods", ```<br> ``` "expires_in": 180, ```<br> ``` "token_type": "Bearer" ```<br> ``` } ``` |
|        401       | Unauthorized response.<br> If you get this response, it means you mistype the client credentials of your application, or did not even specified them.<br> Check your **Authorization** header or the body parameters **client_id, client_secret** and make sure they are correct.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `Unauthorized`                                                                                                                                                       |
|        500       | Internal Server Error.<br> If you get this response, it means that there was unusual error in our server.<br> Please contact us for solving the matter.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | ```{```<br>```"message": "Internal Server Error"```<br>```}```                                                                                                       |

### Example of Usage
<!--DOCUSAURUS_CODE_TABS-->
<!--NodeJS-->
```js
// Using 'axios' as package for performing POST request (You can use any other library if you want...)
// Using 'jsonwebtoken' as package for parsing jwt access token
import axios from 'axios';
import { default as jwt } from 'jsonwebtoken';
import fs from 'fs';

// Your application credentials (Client ID and Client Secret)
const clientId = 'MY_CLIENT_ID';
const clientSecret = 'MY_CLIENT_SECRET';

// Access token and OSpike public key
const myAccessToken = 'ACCESS_TOKEN';
const ospikePublicKey = fs.readFileSync('PATH_TO_OSPIKE_PUBLIC_KEY');

// OPTION #1:

// NOTE: This IS the Best Practice scenario. 
//       Here you actually parse the token by yourself and does not need for external API 
//       for validating the token and get information about it.

// Function for getting access token information locally using 
// 'jsonwebtoken' library, and verifying the access token credability using OSpike public key.
async function getAccessTokenInfo(accessToken) {

    // Returning the contents of the access token if the token is successfully verified by OSpike public key.
    // Otherwise, it should throw an error, that you should take care of 
    // (you can use 'try-catch' block and handle it directly, or let it be throwed and catched by your error handler)
    // The content of the access token should look like this:
    /**
     * {
     *  "clientId": Client id of the client that request that token.,
     *  "aud": Audience id of the client that the access token intended for (For who you should send the access token to).,
     *  "sub": Subject of the access token, basically means for which entity the access token intended for (The 'user' of the access token),
     *  "scope": Array of scopes of the access token, which basically means what privileges you have
     *           in that access token, for using the audience client.,
     *  "iat": Time in seconds when the access token initialized.,
     *  "exp": Time in seconds when the access token should be expired.,
     *  "iss": Url of the access token issuer (Who which created this access token and sign on it),
     *         It basically our Authorization Server URL,(OSpike URL).
     * }
     **/
    return jwt.verify(accessToken, ospikePublicKey);
}

// Usage Option #1
const accessTokenPayloadV1 = getAccessTokenInfo(myAccessToken) // Returns the access token information (payload) 

// OPTION #2:

// NOTE: This is quite good for those who does not want to use libraries such as 'jsonwebtoken'
//       and prefer to use HTTP request rather than parsing the token themselves.

// Function for getting access token information from OSpike
async function getAccessTokenInfoByOSpike() {

    // Perform HTTP POST Request to OSpike for Acquiring Access Token
    const response = await axios.post(
        'https://51.144.178.121:1337/oauth2/tokeninfo',
        { token: accessToken },
        { headers: { Authorization: 'Basic ' + Buffer.from(`${clientId}:${clientSecret}`, 'base64') }}        
    );

    // In 'axios' the body of the response is in 'data' property, the response should contains JSON like this:
    /**
     * {
     *  "active": Indicates if the access token is active or not.,
     *  "clientId": Client id of the client that request that token.,
     *  "aud": Audience id of the client that the access token intended for (For who you should send the access token to).,
     *  "sub": Subject of the access token, basically means for which entity the access token intended for (The 'user' of the access token),
     *  "scope": Array of scopes of the access token, which basically means what privileges you have
     *           in that access token, for using the audience client.,
     *  "iat": Time in seconds when the access token initialized.,
     *  "exp": Time in seconds when the access token should be expired.,
     *  "iss": Url of the access token issuer (Who which created this access token and sign on it),
     *         It basically our Authorization Server URL,(OSpike URL).
     * }
     **/
    // It contains all the necessary contents inside the access token
    return response.data;
}

// Usage Option #2
const accessTokenPayloadV2 = getAccessTokenInfoByOSpike() // Returns the access token information by OSpike

```
<!--Python-->
```py
# Here we using 'requests' package for HTTP requests (You can use any other library if you want...)
# Also we using 'base64' package for encoding the client id and client secret in 'Authorization' Header.
# For parsing by ourself the access token, we use the 'jwt' package (which you can install via 'pip install pyjwt')
import requests
import base64
import jwt

# Your application credentials (Client ID and Client Secret)
client_id = b"MY_CLIENT_ID"
client_secret = b"MY_CLIENT_SECRET"

# Access token
my_access_token = b"okeowqnoewq.eowqkeoqmdsane.remotnqioadmqment"

# Reading the OSpike Public Key
ospike_public_key = b""

with open(b'OSPIKE_PUBLIC_KEY_FILE_PATH', 'rb') as public_key_file:
    ospike_public_key = public_key_file.read()

# OPTION #1:

# NOTE: This IS the Best Practice scenario. 
#       Here you actually parse the token by yourself and does not need for external API 
#       for validating the token and get information about it.

# Function for getting access token information locally using 
# 'jwt' package, and verifying the access token credability using OSpike public key.
def get_access_token_information(access_token):

    # The access token contents should look like this:
    #
    # {
    #   "clientId": Client id of the client that request that token.,
    #   "aud": Audience id of the client that the access token intended for (For who you should send the access token to).,
    #   "sub": Subject of the access token, basically means for which entity the access token intended for (The 'user' of the access token),
    #   "scope": Array of scopes of the access token, which basically means what privileges you have
    #            in that access token, for using the audience client.,
    #   "iat": Time in seconds when the access token initialized.,
    #   "exp": Time in seconds when the access token should be expired.,
    #   "iss": Url of the access token issuer (Who which created this access token and sign on it),
    #          It basically our Authorization Server URL,(OSpike URL).
    # }
    # 
    # It returns the contents information verified by the OSpike Public Key.
    # If the access token is not signed by OSpike, therfore the verification will failed and raise an error 
    # that you should take care of.
    
    return jwt.decode(access_token, ospike_public_key, algorithms='RS256')

# Usage Option #1
access_token_payload_v1 = get_access_token_information(my_access_token) # returns access token information (payload)

# OPTION #2:

# NOTE: This is quite good for those who does not want to use libraries such as 'jsonwebtoken'
#       and prefer to use HTTP request rather than parsing the token themselves.

# Function for getting access token information from OSpike
def get_access_token_information_by_ospike():

    # Perform HTTP POST Request for token introspection
    response = requests.post(
        "https://51.144.178.121:1337/oauth2/tokeninfo",
        json={"token": access_token},
        headers={"Authorization": "Basic " + base64.b64encode(client_id + ':' + client_secret)}        
    )

    # The response should contains JSON like this:
    #
    # {
    #   "active": Indicates if the access token is active or not.,
    #   "clientId": Client id of the client that request that token.,
    #   "aud": Audience id of the client that the access token intended for (For who you should send the access token to).,
    #   "sub": Subject of the access token, basically means for which entity the access token intended for (The 'user' of the access token),
    #   "scope": Array of scopes of the access token, which basically means what privileges you have
    #            in that access token, for using the audience client.,
    #   "iat": Time in seconds when the access token initialized.,
    #   "exp": Time in seconds when the access token should be expired.,
    #   "iss": Url of the access token issuer (Who which created this access token and sign on it),
    #          It basically our Authorization Server URL,(OSpike URL).
    # }

    return response.json()

# Usage Option #2
access_token_payload_v2 = get_access_token_information_by_ospike() # returns access information (payload) by ospike
```

<!--HTTPS-->
```js
POST /oauth2/tokeninfo HTTP/1.1
Authorization: Basic Q0xJRU5UX0lEOkNMSUVOVF9TRUNSRVQ=
{
    "token": "ACCESS_TOKEN"
}
```
<!--END_DOCUSAURUS_CODE_TABS-->

## Getting OSpike Public Key
**NOTE:** **Best practice usage** for your applications, is to download **once** the public key when you restart your instances,
or even daily routine, for the paranoids between us.

The actual use for the public key, is to **verifying** access token provided by us. (Which described in [*Verifying and Getting Information About Access Token*](/docs/spike-docs-api#verifying-and-getting-information-about-access-token))
### Request structure
| HTTP Request Type |               URL            |
|:-----------------:|:----------------------------:|
|        GET        |  /.well-known/publickey.pem  |
### Parameters
None.
### Response structure
| HTTP Status Code |                                                                                Description                                                                                |
|:----------------:|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
|        200       | Successful response.<br> In the response, you'll get a `publickey.pem` file, which is the public key of OSpike.<br> Mostly you'll use it for verifying token credibility. |
|         *        |                    All other possible response that is not contain the file and is not 200, is unexpected.<br> Please contact us for solving the issue.                   |
### Example of Usage
<!--DOCUSAURUS_CODE_TABS-->
<!--NodeJS-->
```js
// Using 'axios' as package for performing GET request (You can use any other library if you want...)
import axios from 'axios';
import fs from 'fs';

// Path for saving the ospike public key locally
const pathForSavingOSpikePublicKey = 'LOCAL_PATH_FOR_OSPIKE_PUBLIC_KEY';

// Function for saving OSpike Public Key locally
async function saveOSpikePublicKey() {

    const response = await axios.get('https://51.144.178.121:1337/.well-known/publickey.pem');

    // Checking if the response is ok
    if (response.status === 200) {

        // In 'axios' the body of the response is in 'data' property, the response should contain the raw file,
        // so we just need to save it.

        // Saving the public key locally
        fs.mkdirSync(pathForSavingOSpikePublicKey, response.data);
    }    
}

```
<!--Python-->
```py
# Here we using 'requests' package for HTTP requests (You can use any other library if you want...)
import requests

# Local path for saving the OSpike Public Key
path_ospike_public_key = "PATH_TO_OSPIKE_PUBLIC_KEY"

# Making HTTP GET Request for getting the OSpike Public Key
response = requests.get("https://51.144.178.121:1337/.well-known/publickey.pem")

# The raw OSpike Public Key will be in response.content. 
# Then we just save it to the file
with open(path_ospike_public_key, 'wb') as public_key_file:
    public_key_file.write(response.content)
```

<!--HTTPS-->
```js
GET https://51.144.178.121:1337/.well-known/publickey.pem HTTP/1.1 
```
<!--END_DOCUSAURUS_CODE_TABS-->

## Getting OSpike Certificate
### Request structure
| HTTP Request Type |              URL             |
|:-----------------:|:----------------------------:|
|        GET        | /.well-known/certificate.pem |
### Parameters
None.
### Response structure
| HTTP Status Code |                                                                                                                                Description                                                                                                                                |
|:----------------:|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
|        200       | Successful response.<br> In the response, you'll get a `certificate.pem` file, which is the certificate of OSpike.<br> You can use that for verifying the public key, or maybe extracting the public key from it (If you prefer that rather than the API for public key). |
|         *        |                                                                    All other possible response that is not contain the file and is not 200, is unexpected.<br> Please contact us for solving the issue.                                                                   |
### Example of Usage
<!--DOCUSAURUS_CODE_TABS-->
<!--NodeJS-->
```js
// Using 'axios' as package for performing GET request (You can use any other library if you want...)
import axios from 'axios';
import fs from 'fs';

// Path for saving the OSpike Certificate locally
const pathForSavingOSpikeCertificate = 'LOCAL_PATH_FOR_OSPIKE_CERTIFICATE';

// Function for saving OSpike Certificate locally
async function saveOSpikePublicKey() {

    const response = await axios.get('https://51.144.178.121:1337/.well-known/certificate.pem');

    // Checking if the response is ok
    if (response.status === 200) {

        // In 'axios' the body of the response is in 'data' property, the response should contain the raw file,
        // so we just need to save it.

        // Saving the certificate locally
        fs.mkdirSync(pathForSavingOSpikeCertificate, response.data);
    }    
}

````
<!--Python-->
```py
# Here we using 'requests' package for HTTP requests (You can use any other library if you want...)
# Also we using 'base64' package for encoding the client id and client secret in 'Authorization' Header
import requests

# Local path for saving the OSpike Certificate
path_ospike_certificate = "PATH_TO_OSPIKE_CERTIFICATE"

# Making HTTP GET Request for getting the OSpike Certificate
response = requests.get("https://51.144.178.121:1337/.well-known/certificate.pem")

# The raw OSpike Certificate will be in response.content
# Then we just save it to the file
with open(path_ospike_certificate, 'wb') as certificate_file:
    certificate_file.write(response.content)
```

<!--HTTPS-->
```js
GET https://51.144.178.121:1337/.well-known/certificate.pem HTTP/1.1 
```
<!--END_DOCUSAURUS_CODE_TABS-->

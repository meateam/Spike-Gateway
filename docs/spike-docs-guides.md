---
id: spike-docs-guides
title: Guides and Best Practices
---

## OSpike Introduction

**OSpike** is an **Authorization** Server using **OAuth2** protocol.

Therefore, in order to fully understand how things are working out in **OSpike** and using it without any hesitations, we **recommend** to read the about **OAuth2** protocol, and most specificly about **Client Credentials Flow** in **OAuth2**. 

Those who know already **OAuth2** protocol, or does not want to read about **OAuth2**, can proceed to *[Using OSpike](/docs/spike-docs-guides#using-ospike)* section.

## OAuth2 Quick Overlap
Probably you have been using **OAuth2** without you even know about it at all!

If you using **Google**, **Facebook**, **Twitter**, or any other social network or application, you probably once asked to
**login** or **authorize** or even **sign up** with one of your social network account to certain application.

That's where the magic worked! When you click on **sign up with Google** for example, what that actually performed in the background is that you've been redirected to Google for **approving** the requested usage of the certain application with your data in your Google account, for example, reading your calander appointments.

After your approval, the certain application will receive an **access token** (not particularly correct but for our basic introduction that is fine assumption) which will represent the **limited access** the certain application has for your data.

That means, whenever the application want to get information regarding the **limited access** that you approved for it to use, the application send the **access token** to Google (For our example) and it gets back the information needed.

So for the proper actual definition of **OAuth2** is that:

> **OAuth2** is an **Authorization** protocol which enables a **third-party application** to obtain **limited access** to an external **HTTP service** either on behalf of a **resource owner** or by allowing the **third-party application** to obtain access on its own behalf.

Basically, it means that **OAuth2** is used for gathering specific access for using external **HTTP service** or basically an **third-party application** that provides **HTTP service**.

So how does all of it happen? let's dive in.

### OAuth2 Terms
Before diving into **OAuth2**, we need to clarify some **Terms** which we will use **A LOT** in OAuth2:

> **Resource Owner** - An entity capable of granting access to a protected resource.  When the resource owner is a person, it is referred to as an end-user.

**NOTE:** The **resource owner** also can be an **application server** which have protected resources that belongs to it. (For instance, an application server which has internal files stored somewhere else, the internal files are the **protected resource** belongs to the application server)

> **Resource Server** - The server hosting the protected resources, capable of accepting and responding to protected resource requests using access tokens.

> **Client** - An application making protected resource requests on behalf of the resource owner and with its authorization.

**NOTE:** For example, client can be **Cloud application server** which making protected resource requests for its **flies** (the files belongs to the cloud application server) or even for **particular user's** files (!) from **Storage application server** which holds all the files used by the **Cloud application server**.

> **Authorization Server** - The server issuing access tokens to the client after successfully authenticating the resource owner and obtaining authorization.

**NOTE:** **OSpike** is the **Authorization Server** in our case.

> **Access Token** - An access token is a string representing an authorization access issued to the client.
>
> Access token MUST be included in requests for protected resources.
>
> The token may denote an identifier used to retrieve the authorization information or may self-contain the authorization information in a verifiable manner (i.e., a token string consisting of some data and a signature)

**NOTE:** In our case, all the access tokens are **JWT**, means they contain information regarding the authorization information.

> **JWT** - JWT is open standard that defines a compact and self-contained way for securely transmitting information between parties as a JSON object.
>
> The information in JWT can be verified and trusted because it is digitally signed.
>
> In its compact form, JWT’s consist of three parts separated by dots (.) – **Header**.**Payload**.**Signature**

Now, after clarifying those terms, we can dive into actual **OAuth2** mechanism! (Don't worry, its actually very simple)

### OAuth2 Client Credentials Flow Explained

In this particular quick overlap, we will talk only about **OAuth2 Client Credentials Flow**.

**NOTE:** There's actually **4** flows, including **Client Credentials** but the other 3 flows aren't relevant for us right now.

When we saying **Flow**, we means a **scenario** of usage in **OAuth2** for specific cause or reason (Its also called **Flow** in the official RFC of OAuth2).

> **Client Credentials** - Client Credentials is **OAuth2 Flow** which used in situation when the **Resource Owner** is also the **Client**, which requesting access to protected resource. 
>
> Basically, this Flow can be treated as "**Server to Server**" flow, cause the **Client** (AKA the application) requests access to protected resource of their own (or trying to acquire access to protected resource on **Resource Server**)

OK, so we understand what is the scenario for **Client Credentials** (When a **Server (or application)** wants to access other **Server (or application)** protected resource). But how it actually happen?

#### Client Credentials Flow Diagram
![OAuth2 Client Credentials Flow](/docs/assets/oauth2_client_credentials_flow_diag.png)

So what actually happen here?

### OAuth2 Client Credentials Example Usage
#### Client Authentication and Token Request
Firstly, the **Client Server** (the server of the client application) making a **HTTP POST** Request, containing **Client Authentication** and **Token Request**.

> #### OAuth2 Client Authentication
> **Client Authentication** in **OAuth2** is basically a form of authentication the **Client** performs so the **Authorization Server** knows that the other side of the request is actually the **Client**.
> 
> In **OAuth2** there's planty of **Client Authentication** types and forms, but we deal with only **2** which is matter for us, and also supported in **OSpike**.
>
>>**NOTE:** The **Client** use his **Client ID** and **Client Secret** for authentication the **Authorization Server** in our **Client Authentication** types (if you don't know what is **Client ID** and **Client Secret**, basically its kind of **username** and **password** for your client particularly. See <i>[Gathering Client ID and Secret](/docs/spike-docs#gathering-client-id-and-secret)</i> for getting your client id and secret).

So the **Client Server** can use one of the following types of **Client Authentication** types:
1. **Basic HTTP Authentication Format** - This is the recommended format we currently support. It is basically worked like this:<br>
In your request, you'll need to add **Authorization** header, which it's value is:<br> `'Basic ' + base64(YOUR_CLIENT_ID + ':' + YOUR_CLIENT_SECRET)` (**NOTE the Space after the 'Basic'** ).<br>
So for example, if your **Client ID** is `abcdefg` and your **Client Secret** is `abcdefg`, your **Authorization** header will look like this:<br>
`Authorization: Basic YWJjZGVmZzphYmNkZWZn`

2. **Body Authentication** - Basically, you'll need to specify your **Client ID** and **Client Secret** in the **body** of the request, like this:<br>
```json
{
    "client_id": "YOUR_CLIENT_ID",
    "client_secret": "YOUR_CLIENT_SECRET"
}
```
#### Token Request
So we left with **Token Request**, which basically is contained in the body of the request with the following parameters:

`grant_type - Which grant type (Flow) you using. The value here is 'client_credentials'`<br>
`audience - For which audience (Resource Server - or basically application) you want to request access for protected resource from.`

In the end, the request should look like this:
```javascript
POST /oauth2/token HTTP/1.1
Content-Type: application/json
Authorization: Basic Q0xJRU5UX0lEOkNMSUVOVF9TRUNSRVQ=
{
    "audience": "AUDIENCE_ID",
    "grant_type": "client_credentials"
} 
```

#### Authorization Response - Access Token
After successfully request made by the **Client Server**, The **Authorization Server** should response like that:
```javascript
HTTP/1.1 200 OK
Content-Type: application/json;charset=UTF-8
Cache-Control: no-store
Pragma: no-cache

{
    "access_token":"2YotnFZFEjr1zCsicMWpAA.OIQn21_213~qoemqn.OKEMnqbas*312n&e",
    "token_type":"Bearer",
    "expires_in":86400    
}
```
* `access_token` - the JWT access token, for the client request.
* `token_type` - The type of the token. 'Bearer' means it intended to be passed for getting access.
* `expires_in` - Time in seconds for how long the access token will be valid. `86400` = one day.

So basically that is all! See that it is simple?

Wait. How do you use the **access token**?

### How To Use The Access Token

So you acquired **access token** like showed above. How do you use it?

Basically, the usage for **access token** is very simple.

You just need to add an **Authorization** header, contains your access token, in your requests for protected resources.

For example, if your **access token** is `aewqkeok.wqekqo.qwoekwq`, the header look like this:<br>
`Authorization: aewqkeok.wqekqo.qwoekwq`

### View Access Token Contents

We said above, that the **access token** of **OSpike** is **JWT**, means the token contents and information is **self-contained** and **digitaly signed**.

How do you see your access token contents?

Its simple. As said above, the **JWT** consist of three parts separated by dots (.) - **Header**.**Payload**.**Signature**.

Just take the part of the **Payload**, and **Decode** it in **Base64**.

You'll get an object which looks like this:
```javascript
{
    "clientId": Client id of the client that request that token.,
    "aud": Audience id of the client that the access token intended for (For who you should send the access token to).,
    "sub": Subject of the access token, basically means for which entity the access token intended for (The 'user' of the access token),
    "scope": Array of scopes of the access token, which basically means what privileges you have
             in that access token, for using the audience client.,
    "iat": Time in seconds when the access token initialized.,
    "exp": Time in seconds when the access token should be expired.,
    "iss": Url of the access token issuer (Who which created this access token and sign on it),
           It basically our Authorization Server URL,(OSpike URL).
}
```

Another way to viewing the access token contents, which is considered more **application friendly**, is to **verify** the access token and getting its contents using **third party libraries**, or using our **Token Introspection** endpoint for it.

Check out <i>[Verifying and Getting Information About Access Token](/docs/spike-docs-api#verifying-and-getting-information-about-access-token)</i> for more information.

## Using OSpike

### Server to Server Authorization

**NOTE:** This guide assumes you signed up and created client in the **Spike Client** as showed in <i>[Spike Client Website Tutorial](/docs/spike-docs#spike-client-website-tutorial).</i>

So, you basically want to use other **3rd Party Server (or 3rd party application)** API or data for **your Server (or application)**.

In shorthand, you'll need to **acquire an access token** for your client, and pass it in the request for the **3rd Party Server (or 3rd party application)**.

### Acquiring Access Token
Just create an API Request as described in <i>[Acquiring Access Token](/docs/spike-docs-api#aquiring-access-token)</i>.

> <u>**Very Important NOTE:**</u> The access tokens are <u>**valid for certain time**</u>. When an access token is over it expiration time, it won't be valid and you should **acquire new access token** the same way you did before.<br>You can check out the <i>[View Access Token Contents](/docs/spike-docs-guides#view-access-token-contents)</i> section for getting more information about expiration time of token, based on its content.
>
> The **Best Practice** is to save the access token in session storage as **Redis Store** or something similar, just in case if your application crashed and you somehow lost your access token.

> **NOTE:** If you somehow **lost your access tokens and you cannot get new one**, you can **renew your credentials** (deleting
> all access tokens, and getting new client id and client secret)
>
> You can see how to do it in <i>[Gathering Client ID and Secert](/docs/spike-docs#gathering-client-id-and-secret)</i> in the **Renewing Credentials** button.

> **NOTE:** For your convenient, we set a limit of **10 access tokens** for client (Which basically means you can have 10 access tokens maximum currently active at the same time).
>
> It means that if you somehow lost your token or your Redis store just crashed and the backup not loaded, you can request immediately 
> new access token without <i>[renewing your credentials](/docs/spike-docs#gathering-client-id-and-secret)</i>.
>
> <u>**Please don't count on this! Make your application robust by saving the access token in Redis store or by anything similar to it.**</u>
>
> You can check out the <i>[Complete Example Of Usage](/docs/spike-docs-guides#complete-example-of-usage)</i> for seeing example of mantaining access token in Redis store.



### Using Access Token
In your requests for the **3rd Party Server (or 3rd party application)**, just add the **access token** in the **Authorization** header as described in <i>[How To Use The Access Token](/docs/spike-docs-guides#how-to-use-the-access-token)</i>.

### Using Kartoffel
If you are here just because you want to use **Kartoffel** API, you just need to **acquire an access token** for your client as described in <i>[Acquiring Access Token](/docs/spike-docs-guides#acquiring-access-token)</i>, and pass it in the API request as described in <i>[How To Use The Access Token](/docs/spike-docs-guides#how-to-use-the-access-token)</i>.


### Complete Example Of Usage
We have an example of usage of **Node Server** which acquire access tokens and save them in **Redis** store for after usage.

> **URL for the project**: <i>https://github.com/ShragaUser/spike-integration-server</i>

You can learn from it and even use it in your deployment as individual server for acquiring and managing access tokens.

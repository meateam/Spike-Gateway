---
id: spike-docs
title: Spike Documentation
sidebar_label: Sidebar
---

## Getting Started

>First of all, Thank you for using our project! for any requests or ideas for making this documentation better, please contact us for making this docs the best for your usage!

For using **Spike** (and more practically **OSpike**), you'll need to firstly register as described in the next section.

## Spike Client Website Tutorial

To be able to work with Spike, You will have to create an account for the team, And you will be managing the application\
of the team that will interface with Spike.

#### Spike's Client Website

[https://51.144.178.121](https://51.144.178.121)


### Creating Team Account

First, You will have to create an account for the team by pressing the **Create New Account** button.\
then, Fill the wanted **Team Name** And **Password**.

**Team Password Requirements**
- The password length must be **8-50**.
- Only **English** letters allowed.
- There must be at least one **special character**.
- There must be at least one **number**.

#### Images Demonstration
\
![Login Screen](/docs/assets/registerteam1.PNG)\
\
![Register Team](/docs/assets/registerteam2.PNG)


### Creating Client

Now you will need to add a new client.\
In order to do that, press the `+` button at the right bottom of the screen\
And a registration form will open, where you will need to enter your application details.

#### Here Is An Image, With Explanation Below:
\
![alt text](/docs/assets/registerclient1.png)

1. **First Field (Black) - Application Name:** Enter your application name (In English).\
For Example - **`ExampleApp`**
2. **Second Field (Gray):**

    Set the toggle to **ON** (If One Or More Of The Following Сonditions Is Met):
    - If your application has multiple hosts, **Behind a single Load Balancer**. (Such as LTM, Ingress, or any other host that is serving as a Reverse Proxy).
    - If your application is working under **One host without Load Balancer**.

    Set the toggle to **OFF** (If One Or More Of The Following Сonditions Is Met):
    - If your application has **number of hosts without Load Balancer**.
    - If your application has **different number of Load Balancers**.

    If you set the toggle to **OFF**:\
        **In the URI Field (Blue)** - Enter the **address** of your (**Load Balancer URI** OR **Host URI**).\
        **In the Port Field (Red)** - Enter the **port** of the (**Load Balancer URI** OR **Host URI**).
        
        Examples:
    
        https://exampleapp.co.il
        https://testingapp.com:1234
    
    If you set the toggle to **ON**:\
    You Will see the following fields:

    ![alt text](/docs/assets/registerclient2.png)

    **In The Black Field** - Select Import From CSV.\
    **In The Orange Field** - Select Your CSV File with all the Hosts/Load Balancers (Like In The Example Below):

    ![alt text](/docs/assets/CSVExplain.png)
    
    In The **A** Column - There Will be all the hosts without the `https://` prefix.\
    In The **B** Column - There Will be the ports.

3. **Last Field (Purple - Doesn't Matter If The Toggle Is On Or Off):**

    Enter The Route, Where the application will get the answer for the different requests, and the different scenarios,\
    This Route is called Redirect Uri, Because there are different scenarios where a redirect is being called to that route.
    
            Examples:

            /redirect
            /api/callback
    
    *Dont forget to press **Enter** on the keyboard, after filling this field.

### Gathering Client ID and Secret

After You are done, press Register, And You will see the following window:

![alt text](/docs/assets/clientmodal1.png)

Lastly, you will need to copy the **Client ID** and the **Client Secret**, and use it in the host that you have added.

Few Last Highlights:
- **Edit Button** - Will set the client to the edit mode, and will let you change few parameters.
- **Remove Button** - Will remove the client.
- **Three Dots Button** - Will let you Add / Delete Host Uris.
- **Renew Credentials Button** - Will renew the Client ID, and Client Secret, and delete all currently activated access tokens.\
    Further information about this button will be in the **Gathering Access Token Guide**.

### Interact with Spike

In your mainly work, you'll interact with **OSpike**, which is our **OAuth2 Authorization Server**.

To start working with **OSpike**, follow the <i>[Guides](/docs/spike-docs-guides)</i> tab.
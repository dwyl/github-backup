# :octocat: :back: :up: GitHub Backup!

An App that helps you **backup** your **GitHub Issues**
`so that` you can still **work** when (you/they are) ***offline***.


<div align="center">

[![Build Status](https://img.shields.io/travis/dwyl/github-backup/master.svg?style=flat-square)](https://travis-ci.org/dwyl/github-backup)
[![Inline docs](http://inch-ci.org/github/dwyl/github-backup.svg?style=flat-square)](http://inch-ci.org/github/dwyl/github-backup)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/github-backup/master.svg?style=flat-square)](http://codecov.io/github/dwyl/github-backup?branch=master)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/dwyl/github-backup.svg?style=flat-square)](https://beta.hexfaktor.org/github/dwyl/github-backup)
<!--
[![HitCount](http://hits.dwyl.io/dwyl/github-backup.svg)](https://github.com/dwyl/github-backup)
-->
</div>


## Why?

`As a person` (_`team of people`_) that uses **GitHub** as their
["***single-source-of-truth***"](https://en.wikipedia.org/wiki/Single_source_of_truth) <br />
I `need` a backup of GitHub issues <br />
`so that` I can see **issue history** and/or **work** "**offline**". <br />
(_either when I have no network or GH is "temporarily offline"_)

## What?

GitHub (Issue) Backup is an App that lets you (_unsurprisingly_):

1. **Store a backup **of the content of the **GitHub issue(s)**
for a given project/repo.
2. Track the changes/edits made to issue description and comments.
3. View all your issues when you or GitHub are
["offline"](https://github.com/dwyl/github-reference/issues/15)

## How?

The app is built using the **Phoenix Web Framework** <br />
(_using the Elixir programming language_) <br />
and Tachyons UI ("Functional CSS") system. <br />
While you can _run_ the App without knowing Elixir or Phoenix <br />
(_see instructions below_),
if you want to _understand_ how it works, <br />
we _recommend_ taking the time to **learn** each item on the list.
<br />
If you are `new` to Phoenix, Elixir,
or to Tachyons (_the UI_)
we have a "_beginner tutorials_"
which will bring you up-to-speed:

+ Elixir:
[github.com/dwyl/**learn-elixir**](https://github.com/dwyl/learn-elixir)
+ Phoenix:
[github.com/dwyl/**learn-phoenix-framework**](https://github.com/dwyl/learn-phoenix-framework)
+ Tachyons:
[github.com/dwyl/**learn-tachyons**](https://github.com/dwyl/learn-tachyons)

_Additionally_ we use Amazon Web Services (***AWS***)
Simple Storage Service (***S3***) <br />
for storing the issue comment _history_ with "_high availability_". <br />
To run `github-backup` on your `localhost`
you will need to have an AWS account and an S3 "bucket". <br />
(_instructions given below_).

<!--
> Point People to the "Landing Page" (once it's ready):
https://github.com/dwyl/github-backup/issues/55
-->


## Set Up _Checklist_ on `localhost`

This will take approximately **10 minutes** to complete.
(_provided you already have a GitHub and AWS account_)

### Install Dependencies

To run the App on your `localhost`,
you will need to have **4 dependencies** _installed_:

+ Elixir:
https://github.com/dwyl/learn-elixir#installation
+ PostgreSQL:
https://github.com/dwyl/learn-postgresql#installation
+ Phoenix:
https://hexdocs.pm/phoenix/installation.html
+ **ngrok**: https://github.com/dwyl/learn-ngrok#1-download--install <br />
(_so you can share the app on your `localhost` with GitHub via `public` URL_)

Once all the necessary dependencies are installed,
we can move on.
(_if you get stuck,
  [please let us know](https://github.com/dwyl/github-backup/issues)_!)

### Clone the App

Run the following the command to `clone` the app from GitHub:
```sh
git clone https://github.com/dwyl/github-backup.git && cd github-backup
```

### Required Environment Variables

To run the project on your `localhost`,
you will need to have the following Environment Variables defined.

> _**Note**: if you are `new` to "Environment Variables", <br />
**please read**_:
[github.com/dwyl/**learn-environment-variables**](https://github.com/dwyl/learn-environment-variables)

+ `PRIVATE_KEY` - The key for your GitHub App.
_See below for how to set this up_.
+ `GITHUB_APP_ID` - The unique `id` of your GitHub App. _See below_.
+ `SECRET_KEY_BASE` - a 64bit string used by Phoenix for security
(_to sign cookies and CSRF tokens_). See below for how to _generate_ yours.


#### Copy The `.env_sample` File

The _easy_ way manage your Environment Variables _locally_
is to have a `.env` file in the _root_ of the project.

_Copy_ the _sample_ one and update the variables:

```sh
cp .env_sample .env
```

Now update the _values_ to the _real_ ones for your App. <br />
You will need to _register_ a GitHub app,
so that is what we will do _below_!

> _Don't worry, your sensitive variables are **safe**
as the `.env` file is "ignored" in the_
[`.gitignore` file](https://github.com/dwyl/github-backup/blob/778d1e311a37564721989e842412880994eb2b5d/.gitignore#L28)



### Create a GitHub Application

The role of the Github application is to
send **notifications** when **events** occur in your repositories. <br />
For example you can get be notified
when **new issues** or **pull requests** are ***opened***.

#### 1. Access the New Application Settings Page

While logged into your GitHub Account, visit:
https://github.com/settings/apps/new <br />
Or _navigate_ the following menus:
```
Settings -> Developer settings -> Github Apps -> New Github App
```

![github-backup-create-new-app-numbered](https://user-images.githubusercontent.com/194400/37258239-b5101ba8-256c-11e8-90e1-e2ca2a0ac20c.png)

<!-- numbering steps is in instructions **always** better than bullet points
as it's easier to reference a **specific** step -->

1. **Github App name**: The name of the app; must be unique,
so can't be "gh-backup"  as that's taken!
2. **Descriptions**: A short description of the app; "My backup app"
3. **Homepage URL**: The website of the app. e.g: "https://gitbu.io"
  (_yours will be different_)
4. **User authorization callback URL**: Redirect url after user authentication e.g."http://localhost:4000/auth/github/callback".
This is not needed for backup so this field can be left empty.
5. **Setup URL** (optional): Redirect the user to this url after installation,
not needed for `github-backup`.
6. **Webhook URL**: the URL where HTTP `POST` requests from Github are sent.
The endpoint in the `github-backup` App is `/event/new`,
however Github won't be able to send requests
to ```http://localhost:4000/event/new```
as this url is only accessible on your `localhost`.
To allow GitHub to access your `localhost` server you can use `ngrok`.
**Remember to update these value after you have a running server on your machine!**
7. **Webhook secret** (optional) - leave this blank for now.
see: https://github.com/dwyl/github-backup/issues/76
(_please let us know your thoughts!_)

Then in your terminal enter `ngrok http 4000`
to generate an SSH "tunnel" between your localhost:4000 and ngrok.io.
Copy the ngrok url that appears in your terminal
to the Github app configuration; e.g: "http://bf541ce5.ngrok.io/event/new"

> _NOTE: you will need to update the webhook URL each time you
disconnect/connect to ngrok because a different URL is generated every time._

You can read more about webhooks and `ngrok` at:
https://developer.github.com/webhooks/configuring

#### 2. Set the Necessary Permissions

Still on the same page, just scrolled down below the initial setup.

  - Define the access rights for the application on the permission section. **Change "issues" to "Read only"**

  ![image](https://user-images.githubusercontent.com/16775804/36432698-b50c54f6-1652-11e8-8330-513c06150d05.png)


  - Select which events ```dwylbot``` will be notified on. **Check "issues" and "issue comment"**

    ![image](https://user-images.githubusercontent.com/16775804/36432733-d4901592-1652-11e8-841f-06e7b4bf9b4c.png)

  - Webhook secret: This token can be used to make sure that the requests received by `github-backup` are from Github; `github-backup` doesn't use this token at the moment so you can keep this field empty (see https://developer.github.com/webhooks/securing/)

  - You can decide to allow other users to install the Github Application or to limit the app on your account only:
    ![Github app install scope](https://user-images.githubusercontent.com/6057298/34677046-cf874e96-f486-11e7-9f60-912f3ec2809b.png)

    You can now click on "Create Github App"!

  - Create a private key: This key is used to identify specific `github-backup` installations

    ![Github App private key](https://user-images.githubusercontent.com/6057298/34678365-d9d73dd0-f48a-11e7-8d1b-cfbfa11bbcc9.png)

    The downloaded file contains the private key.
    Copy this key in your environment variables, see the next section.


  You can also read the Github guide on how to create a new Github App at https://developer.github.com/apps/building-github-apps/creating-a-github-app/

  #### Run a `github-backup` server

  The `github-backup` server will receive events from Github
  and then save the details or edits to an external database.


### S3 Bucket





#### Generate the `SECRET_KEY_BASE`

Run the following command
to generate a new `SECRET_KEY_BASE`:

```sh
mix phx.gen.secret
```
_copy-paste_ the _output_ (64bit `String`)
into your `.env` file after the "equals sign" on the line that reads:
```yml
export SECRET_KEY_BASE=run:mix_phx.gen.secret...
```



#### "Source" the `.env` File

Now that you have defined all the necessary
environment variables in your `.env` file, <br /
it's time to make them _available_ to the App. <br />

Execute the command following command in your terminal:
```sh
source .env
```

> _**Note**: This method only adds the environment variables **locally**
and **temporarily** <br />
so you need to start your server in the **same terminal**
where you ran the `source` command_.


### Install Elixir (_Application-specific_) Dependencies

Now that you have the environment variables defined,
you can install the _elixir_ (_application-specific_) dependencies:

```sh
mix deps.get && npm install
```

#### Run the Tests! (_To check it works!_)

Confirm everything is working by running the tests:

```sh
mix test
```


### Create the Database

In your terminal, run the following command:
```sh
mix ecto.create && mix ecto.migrate
```

> _**Note**: your PostgreSQL server will need to be running for this to work_.


### Run the Phoenix (Application) Server

```
mix phx.server
```

- Now that your server is running you can update the
`webhook url` in your app config:

- run ```ngrok http 4000``` in a `new` terminal window.

    ![ngrok](https://user-images.githubusercontent.com/6057298/34685179-73b6d71c-f49f-11e7-8dab-abfc64c9e938.png)
  - copy and save the url into your Github App config with ```/event/new``` for endpoint

- View the Project in your Web Browser

Open http://localhost:4000 in your web browser.

To test your github-backup server try installing your app onto one of your repos. You should see the payload of the request in the tab you have open in your terminal for the phoenix server:

![image](https://user-images.githubusercontent.com/16775804/36433464-77912686-1654-11e8-8a54-0779992d9e18.png)


### Deployment

The project is hosted on Heroku at: https://github-backup.herokuapp.com

If you want to know _how_ see: <br />
https://github.com/dwyl/learn-heroku/blob/master/elixir-phoenix-app-deployment.md

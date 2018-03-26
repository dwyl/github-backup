# GitHub Backup!

An App that helps you **backup** your **GitHub Issues**
`so that` you can still **work** when (you/they are) ***offline***.


<div align="center">

[![Build Status](https://img.shields.io/travis/dwyl/github-backup/master.svg?style=flat-square)](https://travis-ci.org/dwyl/github-backup)
[![Inline docs](http://inch-ci.org/github/dwyl/github-backup.svg?style=flat-square)](http://inch-ci.org/github/dwyl/github-backup)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/github-backup/master.svg?style=flat-square)](http://codecov.io/github/dwyl/github-backup?branch=master)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/dwyl/github-backup.svg?style=flat-square)](https://beta.hexfaktor.org/github/dwyl/github-backup)
[![HitCount](http://hits.dwyl.io/dwyl/github-backup.svg)](https://github.com/dwyl/github-backup)
</div>


## Why?

`As a person` (_`team of people`_) that uses **GitHub** as their
["***single-source-of-truth***"](https://en.wikipedia.org/wiki/Single_source_of_truth) <br />
I `need` a backup of GitHub issues <br />
`so that` I can see **issue history** and/or **work** "**offline**". <br />
(_either when I have no network or GH is "temporarily offline"_)

## What?

GitHub (Issue) Backup is an App that lets you (_unsurprisingly_):

1. **Store a backup** of the content of the **GitHub issue(s)**
for a given project/repo.
2. Track the changes/edits made to issue description and comments.
see: [dear-github/issues/129](https://github.com/dear-github/dear-github/issues/129)
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
Tachyons (_the UI_) or ngrok, <br />
we have a "_beginner tutorials_"
which will bring you up-to-speed:

+ Elixir:
[github.com/dwyl/**learn-elixir**](https://github.com/dwyl/learn-elixir)
+ Phoenix:
[github.com/dwyl/**learn-phoenix-framework**](https://github.com/dwyl/learn-phoenix-framework)
+ Tachyons:
[github.com/dwyl/**learn-tachyons**](https://github.com/dwyl/learn-tachyons)
+ ngrok: [github.com/dwyl/**learn-ngrok**](https://github.com/dwyl/learn-ngrok)

_Additionally_ we use Amazon Web Services (***AWS***)
Simple Storage Service (***S3***) <br />
for storing the issue comment _history_
with "_high availability_" and reliability. <br />
To run `github-backup` on your `localhost`
you will need to have an AWS account and an S3 "bucket". <br />
(_instructions given below_).

<!--
> Point People to the "Landing Page" (once it's ready):
https://github.com/dwyl/github-backup/issues/55
-->


## Set Up _Checklist_ on `localhost`

This will take approximately **15 minutes** to complete. <br />
(_provided you already have a GitHub and AWS account_)

### Install Dependencies

To run the App on your `localhost`,
you will need to have **4 dependencies** _installed_:

+ **Elixir**:
https://github.com/dwyl/learn-elixir#installation
+ **PostgreSQL**:
https://github.com/dwyl/learn-postgresql#installation
+ **Phoenix**:
https://hexdocs.pm/phoenix/installation.html
+ **ngrok**: https://github.com/dwyl/learn-ngrok#1-download--install <br />
(_so you can share the app on your `localhost` with GitHub via `public` URL_)

Once all the necessary dependencies are installed,
we can move on.
(_if you get stuck,
  [please let us know](https://github.com/dwyl/github-backup/issues)_!)

### Clone the App from GitHub

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

+ `APP_HOST` - the hostname for your app e.g: `localhost` or `gitbu.io`.
+ `PRIVATE_KEY` - The RSA private key for your GitHub App.
_See below for how to set this up_.
+ `GITHUB_APP_ID` - The unique `id` of your GitHub App. _See below_.
+ `GITHUB_APP_NAME` - the name of your GitHub App. _See below_ (_Step 1_).
+ `SECRET_KEY_BASE` - a 64bit string used by Phoenix for security
(_to sign cookies and CSRF tokens_). See below for how to _generate_ yours.
+ `AWS_ACCESS_KEY_ID` - your AWS access key (_get this from your AWS settings_)
+ `AWS_SECRET_ACCESS_KEY` - your AWS secrete access key
+ `S3_BUCKET_NAME` - name of the AWS S3 "bucket" where issue comments
will be stored.


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

> _**Note**: we have **simplified**
the steps in the "official" Github guide
to create a new Github App_: https://developer.github.com/apps/building-github-apps/creating-a-github-app

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
to `http://localhost:4000/event/new`
as this url is only accessible on your `localhost`.
To allow GitHub to access your `localhost` server you can use `ngrok`.
**Remember to update these value after you have a running server on your machine!**
7. **Webhook secret** (optional) - leave this blank for now.
see: [github-backup/issues/76](https://github.com/dwyl/github-backup/issues/76)
(_please let us know your thoughts on how/when we should prioritise this!_)

Then in your terminal enter `ngrok http 4000`
to generate an SSH "tunnel" between your localhost:4000 and ngrok.io.
Copy the ngrok url that appears in your terminal
to the Github app configuration; e.g: "http://bf541ce5.ngrok.io/event/new"

> _NOTE: you will need to update the webhook URL each time you
disconnect/connect to ngrok because a different URL is generated every time._

You can read more about webhooks and `ngrok` at:
https://developer.github.com/webhooks/configuring

#### 2. Set the Necessary Permissions

Still on the same page, scroll down below the initial setup,
to the ***Permissions*** section:

![github-backup-permissions](https://user-images.githubusercontent.com/194400/37843463-e1498be2-2ebc-11e8-905e-4c12e359e080.png)

1. Define the access rights for the application on the permission section.
**Change "issues" to "Read & write"**
(_this is required to update "meta table" which links to the "issue history"_)


#### 3. Subscribe to Events

Scroll down to the "***Subscribe to events***" section
and check the boxes for ***Issue comment*** and ***Issues***:
![github-backup-subscribe-to-events](https://user-images.githubusercontent.com/194400/37843759-c0116002-2ebd-11e8-95a5-242c0238e115.png)


#### 4. Where can this GitHub App be installed?

Scroll down to the "**_Where_ can this GitHub App be installed?**" section.

![github-backup-where-can-be-installed](https://user-images.githubusercontent.com/194400/37844500-dee11980-2ebf-11e8-904b-94a34559c2e2.png)

In _our_ case we want to be able to use GitHub Backup for a number of projects
in different organisations, so we selected ***Any account***.
but if you only want to backup your _personal_ projects,
then select ***Only on this account***.

#### 5. Click on the `Create GitHub App` Button!

_Finally_, with everything configured, click on "Create Github App"!

![create-github-app](https://user-images.githubusercontent.com/194400/37844737-a0466b84-2ec0-11e8-8ef3-dff6e2f6162a.png)

You should see a message confirming that your app was created:
![github-backup-create-private-key](https://user-images.githubusercontent.com/194400/37846890-fa8f9bbe-2ec6-11e8-9324-155f5f444f56.png)

(_obviously your app will will have a different name in the url/path..._)

#### 6. Generate Private Key

Click on the _link_ to "***generate a private key***".

![github-backup-private-key](https://user-images.githubusercontent.com/194400/37848805-53bb653c-2ecd-11e8-9a80-8d328ad9aadf.png)

When you click the `Generate private key` button it should _download_
a file containing your private key.

![github-backup-pk-download](https://user-images.githubusercontent.com/194400/37848886-979979f6-2ecd-11e8-98a3-3b69dcf8dae6.png)

Open the file in your text editor, e.g:
![private-key](https://user-images.githubusercontent.com/194400/37849176-94cb965e-2ece-11e8-8771-02538aa662d9.png)

> <small>_**Don't worry**, this is **not** our "**real**" private key ...
it's just for demonstration purposes. <br />
but this is what your RSA private key will
**look** like, a block of random characters ..._</small>

The downloaded file contains the private key.
Save this file in the root
of the `github-backup` repo on your `localhost`.

For _example_ in _our_ case the GitHub app is called "**gitbu**", <br />
so our Private Key file starts with the app name
and the _date_ the key was generated. <br />
e.g: `gitbu.2018-03-23.private-key.pem`


> <small>_**Don't worry**, all `.pem` (private key) files
are ignored in the `.gitignore` file so your file will stay private._</small>

Once you have copied the file into your project root, run the following command:
```sh
echo "export PRIVATE_KEY='`cat ./gitbu.2018-03-23.private-key.pem`'" >> .env
```
Replace the `gitbu.2018-03-23.private-key.pem` part in the command
with the name of _your_ private key file
e.g: `my-github-backup-app.2018-04-01.private-key.pem`

That will create an entry in the `.env` file for your `PRIVATE_KEY`
environment variable.


#### 7. Copy the App Name and App `ID` from GitHub App Settings Page

In the "**Basic information**" section of your app's settings page,
copy the GitHub App name and paste it into your `.env` file after the `=` sign
for the `GITHUB_APP_NAME` variable.

![github-backup-app-name](https://user-images.githubusercontent.com/194400/37878406-dbaaa2ca-3060-11e8-8c50-14860144ea79.png)

Scroll downd to the "About" section you will find the `ID` of your app e.g: 103
this is the number that needs to be set for `GITHUB_APP_ID` in your `.env` file.

![app-about-id](https://user-images.githubusercontent.com/194400/37863366-004a4f02-2f55-11e8-97eb-7d9f8b74ba66.png)





#### Generate the `SECRET_KEY_BASE`

Run the following command to generate a new phoenix secret key:

```sh
mix phx.gen.secret
```
_copy-paste_ the _output_ (64bit `String`)
into your `.env` file after the "equals sign" on the line for `SECRET_KEY_BASE`:
```yml
export SECRET_KEY_BASE=YourSecreteKeyBaseGeneratedUsing-mix_phx.gen.secret
```

####  S3 Bucket

In order to save the Issue Comments (_which are a variable length "rich text"_),
we save these as `.json` in an S3 bucket. If you do not _already_ have
an S3 bucket where you can store issues/comments, create one now.

Once you have an S3 bucket, copy the name and paste it into your `.env` file
against the `S3_BUCKET_NAME` environment variable.

You will _also_ need to define the

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
mix deps.get && cd assets npm install && cd ..
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

> _**Note**: your **PostgreSQL** server
will need to be **running** for this to work_.


### Run a `github-backup` (Phoenix Application) Server

The `github-backup` server will receive events from Github
and then save the details or edits to an external database.

```
mix phx.server
```


### Run `ngrok` on your `localhost`

In a New Window/Tab in your Terminal run the `ngrok` server:
```sh
ngrok http 4000
```

You should see something like this:
![ngrok-terminal-running-proxy](https://user-images.githubusercontent.com/194400/37878883-a3ae8646-3067-11e8-8e1f-02683a2fd0bb.png)

On the line that says "**forwarding**" you will see the (`public`) URL
of your app, in this case https://38e239f0.ngrok.io
(_your URL's subdomain will be a different "random" set of characters_)

Copy the URL for the next step. (_remember to copy the `https` version_)

### Update your Webhook URL on your GitHub App

Now that your server is running you can update the
`webhook url` in your app config.
On the "GitHub App settings page"
Find the "Webhook URL" section:
(_the URL is currently `http://localhost:4000` ..._)

![github-backup-webhook-url-before](https://user-images.githubusercontent.com/194400/37879083-7e929d22-306a-11e8-8a86-48afa14158e0.png)


_Replace+ the `http://localhost:4000` with your _unique_ `ngrok` url e.g:

![github-backup-webhook-url-after](https://user-images.githubusercontent.com/194400/37879098-bf13a33c-306a-11e8-8a29-4d662678931a.png)


Scroll down and click on the "Save changes" button:

![save-changes](https://user-images.githubusercontent.com/194400/37879104-d327af6c-306a-11e8-82d7-48baada8410d.png)

  - copy and save the url into your Github App config with ```/event/new``` for endpoint

### View the App in your Web Browser

Open http://localhost:4000 in your web browser. You should see something like:

![gitbu-homepage-localhost](https://user-images.githubusercontent.com/194400/37879114-1f9ca438-306b-11e8-85a9-dec480ef7577.png)

### Try The App!


To test your github-backup server try installing your app
onto one of your repos.

#### 1. Visit Your App's GitHub Page

Visit your App's URL on GitHub e.g: https://github.com/apps/gitbu


Install the app on one of your Repositories e.g:

You should see the payload of the request in the tab you
have open in your terminal for the phoenix server:

![image](https://user-images.githubusercontent.com/16775804/36433464-77912686-1654-11e8-8a54-0779992d9e18.png)


### Deployment

The project is hosted on Heroku at: https://github-backup.herokuapp.com

If you want to know _how_ see: <br />
https://github.com/dwyl/learn-heroku/blob/master/elixir-phoenix-app-deployment.md

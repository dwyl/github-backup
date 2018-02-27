# github-backup
:back: :arrow_up: A script to backup your GitHub Account/Organisation so you can still work when (they/you are) offline.

## Why?

As a person who uses GitHub as their "_single-source-of-truth_"
I need a backup of GitHub issues
so that I can work "offline".
(_either when I have no network or GH is "down"_)

## What?

Backup GitHub issues.

+ a script that lets you login to GitHub using OAuth
+ Use GitHub REST API to retrieve all issues
+ Store issues as "flat files" in subdirectories corresponding to the GitHub URL
e.g: if the issue is `dwyl/github-reference/issues/15`
store it as `dwyl/github-reference/issues/15.json`
+ It does not need to "scale" it just needs to work. read: http://paulgraham.com/ds.html

Note: initially we do not need a Web-UI to let people backup their issues,
but later we could build UI to make it more useable.

## How?

+ Elixir (see https://github.com/dwyl/learn-elixir to learn Elixir)
+ Phoenix (see https://github.com/dwyl/learn-phoenix-framework to learn Phoenix)
+ Tachyons (see https://github.com/dwyl/learn-tachyons to learn Tachyons)

## Set up

The project is hosted on heroku at: https://github-backup.herokuapp.com/

To run it locally, you will need to:

- Create a new Github application.
- Run a phoenix server on your machine.

You'll need to have installed [Elixir](https://elixir-lang.org/install.html), [Phoenix](https://hexdocs.pm/phoenix/installation.html), and [ngrok](https://ngrok.com/download) if you haven't already.

> _**Note**: **only** `try` to run this on your computer once
you've understood Elixir & Phoenix._

#### Create a GitHub application

The role of the Github application is to send notifications
when events occur on your repositories.
For example you can get a notification when new issues or pull requests are open.

- Access the [new application settings page](https://github.com/settings/apps/new) on your Github account:
  Settings -> Developer settings -> Github Apps -> New Github App

  ![new Github app](https://user-images.githubusercontent.com/6057298/34667319-75439af0-f460-11e7-8ae5-a9f52944b364.png)


- Github App name: The name of the app; must be unique, so can't be "gh-backup" as that's taken!
- Descriptions: A short description of the app; "My backup app"
- Homepage URL: The website of the app: "https://dwyl.com/"
- User authorization callback URL: Redirect url after user authentication e.g."http://localhost:4000/auth/github/callback". This is not needed for backup so this field can be left empty.
- Setup URL: Redirect the user to this url after installation, not needed for `github-backup`
- Webhook URL: URL where post requests from Github are sent to. The endpoint is ```/event/new```, however Github won't be able to send requests to ```http://localhost:4000/event/new``` as this url is only accessible by your own machine. To expose publicly your `localhost` server you can use `ngrok`. **Remember to update this value after you have a running server on your machine!**

    Install [ngrok](https://ngrok.com). If you have homebrew, you can do this by running `brew cask install ngrok`

    Then in your terminal enter `ngrok http 4000` to generate an SSH between your localhost:4000 and ngrok.io. Copy the ngrok url that appears in your terminal to the Github app configuration; "http://bf541ce5.ngrok.io/event/new"

    > _NOTE: you will need to update the webhook URL everytime you disconnect/connect to ngrok because a different URL is generated everytime._

    You can read more about webhooks and ngrok at https://developer.github.com/webhooks/configuring/
- Define the access rights for the application on the permmission section. **Change "issues" to "Read only"**

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

The `github-backup` server will receive events from Github and then save the details or edits to an external database.

- Clone the repository _to your personal computer_:
  ```
  git clone git@github.com:dwyl/github-backup.git && cd github-backup
  ```
- Define the local environment variables:

  > If you are new to "Environment Variables", please read:
  [github.com/dwyl/**learn-environment-variables**](https://github.com/dwyl/learn-environment-variables)

  To run the application on your localhost (_personal computer_)
  create an `.env` file where you can define your environment variables.

  `github-backup/.env`:
  ```
  # SECRET_KEY_BASE is required for Auth Cookie:
  export SECRET_KEY_BASE=MustBeA64ByteStringProbablyBestToGenerateUsingCryptoOrJustUseThisWithSomeRandomDigitsOnTheEnd1234567890
  # PRIVATE_KEY should be generated in your github app settings
  export PRIVATE_KEY=YOUR_PRIVATE_KEY
  # Your GITHUB_APP_ID is found in the settings of your github app under General > About
  export GITHUB_APP_ID=YOUR_GITHUB_APP_ID
  ```

  You can generate a new secret key base with ```mix phoenix.gen.secret```.

  Then execute the command ```source .env``` which will create your environment variables

  > _**Note**: This method only adds the environment variables **locally**
  and **temporarily** <br />
  so you need to start your server in the **same terminal**
  where you ran the `source` command_.

- Install dependencies:

  ```
  mix deps.get && npm install
  ```

- Confirm everything is working by running the tests:

  ```
  mix test
  ```

- Create the Database (_if it does not already exist_)

  ```
  mix ecto.create && mix ecto.migrate
  ```

- Run the Server

  ```
  mix phx.server
  ```

- Now that your server is running you can update the `webhook url` in your app config:
  - run ```ngrok http 4000``` in a new terminal

    ![ngrok](https://user-images.githubusercontent.com/6057298/34685179-73b6d71c-f49f-11e7-8dab-abfc64c9e938.png)
  - copy and save the url into your Github App config with ```/event/new``` for endpoint

- View the Project in your Web Browser

Open http://localhost:4000 in your web browser.

To test your github-backup server try installing your app onto one of your repos. You should see the payload of the request in the tab you have open in your terminal for the phoenix server:

![image](https://user-images.githubusercontent.com/16775804/36433464-77912686-1654-11e8-8a54-0779992d9e18.png)

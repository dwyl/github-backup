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

I have a _strong_ preference for using Elixir for this because we are transitioning _all_ our projects to Elixir, but given that this script does not require parallelism/concurrency it's "OK" to write it in which ever language you are most comfortable using.

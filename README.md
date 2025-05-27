# SPG2

> **Note**: WIP. Will update the README soon.

Open source project for digitizing the Suraj Prakash Granth. This app is more of an admin tool.

The most important thing you will find in here, is:
1. The database and schema
2. The things we return in the JSON

## Context

There was already the SPG repo. But, the truth is, it's much easier for us to work in Ruby on Rails.

We are restructuring the database to include:
* Dr. Bhai Vir Singh footnotes
* Custom footnotes
* Translations for Pauris (instead of individual lines)
* Richtext for footnotes

## Getting Started

### Prerequisites 

* Ruby 3.2.1
* Bundler 2.4.7
* sqlite3

1. Clone the Repo
2. Switch to Ruby version `3.2.1` e.g. `rvm use 3.2.1`
3. `bundle install`
4. `rake db:prepare`

Yes, I know this isn't a API or a minified Rails project; we may consider adding the front-end admin section on here, instead of the old SPG repo.

## Services + Docs

Our application includes several powerful services that help manage and import content. These services are the backbone of our content management system, making it easy to:

You can find the documentation in the [`services`](app/services/README.md) folder.


- Import translations, summaries, and artwork from CSV files
- Manage footnotes through Contentful CMS
- Handle both stanza-level (Pauri) and line-level (Tuk) content

### For Translators and Content Editors

If you're working on translations or content:
1. Check out our [Chapter Importer Guide](app/services/README.md#chapterimporterservice) to learn how to import your translations
2. Learn about [managing footnotes](app/services/README.md#how-to-contribute-footnotes-contentful-stuff) through our Contentful integration

## Goals

The number 1 goal should always be to be a slave of Sri Nanak Guru Gobind Singh Ji and make a beautiful application to honour the *Maha* Kavi Kaviraj Bhai Santokh Singh Ji and his masterpiece, Gurpratap Suraj. 

Not pushing a crappy app. The code might be questionable, tho, lol.

### Short Term
* [x] Finish manual entry, parsing for the Suraj Prakash Granth `.pdf` files
* [x] Recreate new DB that can support the *main* features (footnotes, unicode)
* [x] Add content to DB, like things from Raas 12, etc.
### Long Term

(This is not in order. N'or is it a refined list).

* [x] Can we use this database to replace the one on https://spg.dev/books
* [] Can we easily import chapters that have been translated, etc?
* [] Work with [ShabadOS](https://github.com/shabados) so we can researchers and scholars search engine access
* []x Work with [Jonathon Collie](https://www.jonathancollie.com/) to make the new SPG front-end app.
* [x] Create a footnote, richtext editor.

---

## Deployment Guide

This application is deployed with Fly.io, a platform that allows you to run your applications globally. 

### Prerequisites

1. **Fly.io account**: As a maintainer, you need to have an account on [Fly.io](https://fly.io). You can sign up on their website.

2. **Fly.io CLI**: You need to have the Fly.io Command Line Interface (CLI) installed on your local machine. You can install it by following the instructions [here](https://fly.io/docs/getting-started/installing-flyctl/).

3. **Authentication**: After installing the CLI, authenticate it with your account. The easiest way is by using your GitHub account. Run the following command in your terminal and follow the instructions:
   ```
   flyctl auth github
   ```

### Deploying the Application

1. **Clone the repository**: Make sure you have the latest version of the application code on your local machine.

2. **Navigate to the project repository**: Change your current directory to the project repository in your terminal.

3. **Deploy**: Run the following command to deploy the application:
   ```
   flyctl deploy
   ```

### Important Note

The production database for this application is configured to use `development.sqlite`. Therefore, the behavior of the application in the production environment will be identical to its behavior in the development environment.

---

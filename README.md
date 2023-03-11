# SPG2

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

## Goals

The number 1 goal should always be to be a slave of Sri Nanak Guru Gobind Singh Ji and make a beautiful application to honour the *Maha* Kavi Kaviraj Bhai Santokh Singh Ji and his masterpiece, Gurpratap Suraj. 

Not pushing a crappy app. The code might be questionable, tho, lol.

### Short Term
* [x] Finish manual entry, parsing for the Suraj Prakash Granth `.pdf` files
* [] Recreate new DB that can support the *main* features (footnotes, unicode)
* [] Add content to DB, like things from Raas 12, etc.
### Long Term

(This is not in order. N'or is it a refined list).

* [] Can we use this database to replace the one on https://spg.dev/books
* [] Can we easily import chapters that have been translated, etc?
* [] Work with [ShabadOS](https://github.com/shabados) so we can researchers and scholars search engine access
* [] Work with [Jonathon Collie](https://www.jonathancollie.com/) to make the new SPG front-end app.
* [] Create a footnote, richtext editor.

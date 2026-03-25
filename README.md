# SPG2

Open source project for digitizing the Suraj Prakash Granth. This Rails app is
the server that powers apps like `https://spg.dev` and `https://beta.spg.dev/`.
This app is also used when importing chapters (translations) from a CSV.

The most important thing you will find in here, is:

1. The database and schema
2. The resources we return in the JSON (`/books/:id.json`, `/chapters/:id.json`)

---

## Getting Started

### Option A — Docker (recommended)

**Prerequisites:** Docker and Docker Compose.

```bash
# 1. Clone the repo
git clone git@github.com:vidhiya-saagar/spg2.git && cd spg2

# 2. Copy environment variables
cp .env.example .env   # fill in RAILS_MASTER_KEY if you have it

# 3. Start the app (web + Tailwind CSS watcher)
docker compose up

# App is available at http://localhost:1843
```

Useful compose commands:

```bash
docker compose run web bundle exec rails db:seed      # seed the database
docker compose run web bundle exec rails console      # Rails console
docker compose run web bundle exec rspec              # run tests
docker compose down -v                                # stop and remove volumes
```

### Option B — Local (Ruby + Bundler)

**Prerequisites:** Ruby 3.4.5, Bundler, sqlite3.

```bash
rvm use 3.4.5        # or: rbenv local 3.4.5
bundle install
cp .env.example .env
bin/rails db:prepare
bin/dev              # starts Puma + Tailwind watcher via Procfile.dev
```

App is available at `http://localhost:1843`.

---

## Services + Docs

Our application includes several powerful services that help manage and import
content. These services are the backbone of our content management system,
making it easy to:

You can find the documentation in the [`services`](app/services/README.md)
folder.

- Import translations, summaries, and artwork from CSV files
- Manage footnotes through Contentful CMS
- Handle both stanza-level (Pauri) and line-level (Tuk) content

### For Translators and Content Editors

If you're working on translations or content:

1. Check out our
   [Chapter Importer Guide](app/services/README.md#chapterimporterservice) to
   learn how to import your translations
2. Learn about
   [managing footnotes](app/services/README.md#how-to-contribute-footnotes-contentful-stuff)
   through our Contentful integration

---

## CI / CD

Every pull request and push to `main` runs:

| Workflow | What it does |
|---|---|
| **CI** (`.github/workflows/ruby-ci.yml`) | RuboCop lint + RSpec test suite |
| **Docker** (`.github/workflows/docker.yml`) | Builds the production image; pushes to GHCR on merge to `main` or on version tags |

The production image is published to
`ghcr.io/vidhiya-saagar/spg2` and tagged with the branch name, semantic
version, and short SHA.

---

## Docker Image Architecture

The `Dockerfile` has three named targets:

| Target | Purpose | Used by |
|---|---|---|
| `development` | All gems, live-reload-friendly | `docker compose up` |
| `builder` | Production gems + bootsnap precompile | intermediate |
| `production` | Lean runtime, no build tools | Fly.io / GHCR |

Build a specific target manually:

```bash
# Development image
docker build --target development -t spg2:dev .

# Production image
docker build --target production -t spg2:prod .
```

---

## Deployment Guide

This application is deployed with Fly.io, a platform that allows you to run your
applications globally.

### Prerequisites

1. **Fly.io account**: As a maintainer, you need to have an account on
   [Fly.io](https://fly.io). You can sign up on their website.

2. **Fly.io CLI**: You need to have the Fly.io Command Line Interface (CLI)
   installed on your local machine. You can install it by following the
   instructions [here](https://fly.io/docs/getting-started/installing-flyctl/).

3. **Authentication**: After installing the CLI, authenticate it with your
   account. The easiest way is by using your GitHub account. Run the following
   command in your terminal and follow the instructions:
   ```
   flyctl auth github
   ```

### Deploying the Application

1. **Clone the repository**: Make sure you have the latest version of the
   application code on your local machine.

2. **Navigate to the project repository**: Change your current directory to the
   project repository in your terminal.

3. **Deploy**: Run the following command to deploy the application:
   ```
   flyctl deploy
   ```

### Important Note

The production database for this application is configured to use
`development.sqlite`. Therefore, the behavior of the application in the
production environment will be identical to its behavior in the development
environment.

---

## Goals

The number 1 goal should always be to be a slave of Sri Nanak Guru Gobind Singh
Ji and make a beautiful application to honour the _Maha_ Kavi Kaviraj Bhai
Santokh Singh Ji and his masterpiece, Gurpratap Suraj.

Not pushing a crappy app. The code might be questionable, tho, lol.

### Short Term

- [x] Finish manual entry, parsing for the Suraj Prakash Granth `.pdf` files
- [x] Recreate new DB that can support the _main_ features (footnotes, unicode)
- [x] Add content to DB, like things from Raas 12, etc.

### Long Term

(This is not in order. N'or is it a refined list).

- [x] Can we use this database to replace the one on https://spg.dev/books
- [x] Can we easily import chapters that have been translated, etc?
- [] Work with [ShabadOS](https://github.com/shabados) so we can researchers and
  scholars search engine access
- [x] Work with [Jonathon Collie](https://www.jonathancollie.com/) to make the
      new SPG front-end app.
- [x] Create a footnote, richtext editor.

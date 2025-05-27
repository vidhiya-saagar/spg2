# Services Overview

This folder contains service classes for importing and synchronizing data related to books, chapters, pauris, tuks, and footnotes. Below is a high-level description and usage example for each service.

---

## `ChapterImporterService`

> 

**Purpose:**
Imports and updates chapter data from a CSV source for a given book and chapter. Handles updating chapter titles, pauris, tuks, and their translations interactively, with user prompts for conflicts.

**How It Works:**
1. Add your CSV file to `lib/imports/#{book.sequence}/#{chapter_number}.csv`
2. Pass in a `chapter_number: Integer` e.g. `3`
3. Call `@book.import_chapter(3)`.

**Example:**
```ruby
@book = Book.find_by(:sequence => 1) # Nanak Prakash ਪੂਰਬਾਰਧ
@book.import_chapter(3)
```
This will search for a CSV file at `lib/imports/1/3.csv` (or raise an error).

**CSV File Requirements:**
The CSV file should have the following columns:
- `Chapter_Number`: Integer
- `Chapter_Name`: String
- `Chhand_Type`: String
- `Tuk`: String
- `Pauri_Number`: Integer
- `Tuk_Number`: Integer
- `Pauri_Translation_EN`: String | NULL
- `Tuk_Translation_EN`: String | NULL
- `Footnotes`: String | NULL
- `Extended_Ref`: String | NULL
- `Assigned_Singh` or `Translator`: String | NULL
- `Extended_Meaning`: String | NULL
---

## `ContentfulPauriImporter`

**Purpose:**
Imports custom pauri footnotes from Contentful CMS into the Rails application. Ensures idempotency by only importing new entries. Associates Contentful footnotes with the correct pauri in the database.

**Contentful Integration:**
- Content Type ID: `pauriFootnote`
- Rails Model: `PauriFootnote.contentful_entry_id`

**Contentful Fields:**
- `contentful_entry_id`
- `entryName`
- `vidhiyaSaagarContent`
- `isATranslationOfBhaiVirSingh`
- `vidhiyaSaagarMedia`
- `kamalpreetSinghContent`
- `kamalpreetSinghMedia`
- `manglacharanContent`
- `manglacharanMedia`

**Usage Example:**
```ruby
importer = ContentfulPauriImporter.new
importer.import_latest_entries
```

**Naming Convention:**
Entries in Contentful should follow the format: `Book 1 Chapter 42 Pauri 1`

---

## `ContentfulTukImporter`

**Purpose:**
Similar to `ContentfulPauriImporter` but handles importing `TukFootnote` entries instead of `PauriFootnote` entries from Contentful.

**Contentful Integration:**
- Content Type ID: `tukFootnote`
- Rails Model: `TukFootnote.contentful_entry_id`

**Naming Convention:**
Entries in Contentful should follow the format: `Book 16 Chapter 34 Tuk 34.1`
This corresponds to the first line (`tuk.sequence => 1`) in the 34th stanza (`pauri.number => 34`), of Book 16, chapter 34.

**Usage Example:**
```ruby
importer = ContentfulTukImporter.new
importer.import_latest_entries
```

**Note:** Due to Contentful's limit of returning only 100 entries per API call, the service implements pagination to fetch all entries.

---

## `GranthImporter`

This one isn't used anymore. It was used ONE TIME to seed the DB.

---

Here's an updated version of your README documentation, incorporating the screenshot and all your additional instructions clearly.

---

## `ContentfulPauriImporter`

### **Purpose**

Imports custom pauri footnotes from Contentful CMS into the Rails application. Ensures idempotency by only importing new entries. Associates Contentful footnotes with the correct `Pauri` in the database.

---

### **Contentful Integration**

* **Content Type IDs**:

  * `pauriFootnote`
  * `tukFootnote`
* **Rails Models**:

  * `PauriFootnote.contentful_entry_id`
  * `TukFootnote.contentful_entry_id`

---

### **Contentful Fields**

Each entry includes multiple optional fields for different contributors. The fields imported include:

* `contentful_entry_id`
* `entryName`
* `vidhiyaSaagarContent`
* `vidhiyaSaagarMedia`
* `isATranslationOfBhaiVirSingh`
* `kamalpreetSinghContent`
* `kamalpreetSinghMedia`
* `manglacharanContent`
* `manglacharanMedia`

---

### **Usage Example**

```ruby
importer = ContentfulPauriImporter.new
importer.import_latest_entries
```

---

### **Naming Convention**

Entries in Contentful should follow the format:

* For Pauri: `Book 1 Chapter 42 Pauri 1`
* For Tuk: `Book 1 Chapter 42 Tuk 3.1`

---

## **How to Contribute Footnotes (Contentful Stuff)**

#### **1. Get Access**

To add or edit footnotes, you must be a member of the **Vidhiya Saagar** organization in Contentful.

Currently, only **@dsomel21** has access. You can request an invite from him if you'd like to contribute. We are on the free tier of Contenful. 

#### **2. Navigating the Content**

Once inside Contentful, go to the **"All Content"** view. You’ll see entries organized by naming convention, content type (`PauriFootnote`, `TukFootnote`), and status.

Here's what it looks like:

![All Content Screenshot](https://github.com/user-attachments/assets/07774579-59b0-42f0-bf86-e4898665cb20)

#### **3. Entry Types**

We have two custom entry types:

* **PauriFootnote** – Used for entire stanzas
* **TukFootnote** – Used for specific lines or sub-sections within a Pauri

Make sure to select the correct type when creating a new entry.

---

### ✅ Status

Each footnote must be **Published** to be picked up by the importer. Then, when we run the `ContentfulPauriImporter` or `ContentfulTukImporter`, it will add them in our app. 

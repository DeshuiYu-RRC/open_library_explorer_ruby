# Open Library Explorer

A Ruby on Rails web application that displays book information from the Open Library API with search, filtering, and navigation features.

## Features

- Browse books with cover images and details
- Search books by title or description
- View authors and their books
- Browse books by subject/genre
- View book reviews and ratings
- Pagination for large collections
- Responsive Bootstrap design

## How to Use?

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/DeshuiYu-RRC/open_library_explorer_ruby.git
   cd open_library_explorer_ruby
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Set up the database**
   ```bash
   rails db:create
   rails db:migrate
   ```

4. **Seed the database** (This will take 5-10 minutes)
   ```bash
   rails db:seed
   ```

5. **Start the server**
   ```bash
   rails server
   ```

6. **Visit the application**
   ```
   http://localhost:3000
   ```

## Database overview

The application uses 6 main tables:

- **Books** - Book information (title, description, year, cover, etc.)
- **Authors** - Author information (name, bio, dates, photo)
- **Subjects** - Book genres/categories
- **Reviews** - User reviews and ratings (1-5 stars)
- **BookAuthors** - Join table (Books and Authors, many-to-many)
- **BookSubjects** - Join table (Books and Subjects, many-to-many)

## Data Sources

**Source 1: Open Library Search API**

- **Purpose**: Search for books by subject/genre to build our initial dataset
- **Endpoint**: `https://openlibrary.org/search.json?subject={subject}&limit=100`
- **Real Example**: Science Fiction books
- **Data Retrieved**: Work keys, titles, author keys, publication years, ISBN, cover IDs

**Source 2: Open Library Works API**

- **Purpose**: Get detailed information about each book
- **Endpoint**: `https://openlibrary.org/works/{work_id}.json`
- **Real Example**: `https://openlibrary.org/works/OL45804W.json` (Fantastic Mr Fox)
- **Data Retrieved**: Full descriptions, subjects, covers array, detailed metadata

**Source 3: Open Library Authors API**

- **Purpose**: Get comprehensive author information
- **Endpoint**: `https://openlibrary.org/authors/{author_id}.json`
- **Real Example**: `https://openlibrary.org/authors/OL34184A.json` (Roald Dahl)
- **Data Retrieved**: Author bio, birth/death dates, photos, alternate names

**Source 4: Faker Gem**

- **Purpose**: Generate realistic user reviews and ratings
- **Data Generated**: Reviewer names, review text, ratings (1-5 stars), review dates


## Troubleshooting

### Seed script fails with SSL error
The seed script includes SSL verification bypass for development. If you still have issues:
```bash
export SSL_CERT_FILE=/path/to/cert.pem
```

### Pagination not working
Make sure Kaminari views are generated:
```bash
rails generate kaminari:views bootstrap4
```

### No books showing
Re-run the seed script:
```bash
rails db:reset
rails db:seed
```
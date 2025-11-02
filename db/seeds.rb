require 'net/http'
require 'json'
require 'openssl'

puts "\n" + "="*70
puts "OPEN LIBRARY DATA IMPORT SCRIPT"
puts "="*70

# ============================================================================
# STEP 1: CLEAN DATABASE
# ============================================================================
puts "\nCleaning database..."
Review.destroy_all
BookSubject.destroy_all
BookAuthor.destroy_all
Subject.destroy_all
Book.destroy_all
Author.destroy_all
puts "Database cleaned"

# ============================================================================
# HELPER METHODS WITH SSL FIX
# ============================================================================

def fetch_json(url, description = "data")
  puts "Fetching #{description}..."

  uri = URI(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.open_timeout = 10
  http.read_timeout = 10

  # DISABLE SSL VERIFICATION (Development only!)
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(uri)
  request['User-Agent'] = 'RailsOpenLibraryProject/1.0 (Educational)'

  response = http.request(request)

  if response.code == "200"
    data = JSON.parse(response.body)
    puts "Success"
    return data
  else
    puts "Failed: HTTP #{response.code}"
    return nil
  end
rescue => e
  puts "Error: #{e.message}"
  return nil
end

# ============================================================================
# STEP 2: FETCH BOOKS FROM SEARCH API
# ============================================================================

puts "\nFetching books from Open Library Search API..."
puts "-" * 70

subjects_to_fetch = ['fantasy', 'science_fiction', 'mystery']
all_works = []

subjects_to_fetch.each do |subject|
  puts "\nSearching '#{subject}'..."
  url = "https://openlibrary.org/search.json?subject=#{subject}&limit=20"
  data = fetch_json(url, "#{subject} books")

  if data && data['docs']
    all_works += data['docs']
    puts "Found #{data['docs'].size} books"
  end

  sleep(1) # Be respectful to API
end

puts "\nTotal works found: #{all_works.size}"
all_works = all_works.uniq { |work| work['key'] }
puts "Unique works: #{all_works.size}"

if all_works.empty?
  puts "\nNo books found! Check your internet connection."
  exit
end

# Process first 30 books
all_works = all_works.first(30)
puts "Will process: #{all_works.size} works"

# ============================================================================
# STEP 3: PROCESS EACH WORK
# ============================================================================

puts "\nProcessing works..."
puts "-" * 70

books_created = 0
authors_created = 0
subjects_created = 0

all_works.each_with_index do |work_data, index|
  begin
    puts "\n[#{index + 1}/#{all_works.size}] #{work_data['title']}"

    work_key = work_data['key']

    # Validate work key
    unless work_key && work_key.start_with?('/works/')
      puts "Invalid key, skipping"
      next
    end

    # Fetch detailed work information
    work_url = "https://openlibrary.org#{work_key}.json"
    full_work = fetch_json(work_url, "details")

    # Use search data if full work fails
    work_info = full_work || work_data

    # Prepare description
    description = if work_info['description'].is_a?(Hash)
                    work_info['description']['value']
                  elsif work_info['description'].is_a?(String)
                    work_info['description']
                  elsif work_data['first_sentence']
                    work_data['first_sentence'].join(' ')
                  else
                    "A book from Open Library."
                  end

    # Truncate if too long
    description = description[0..999] if description && description.length > 1000

    # Create book
    book = Book.create!(
      openlibrary_key: work_key,
      title: work_data['title'].to_s[0..499],
      description: description,
      first_publish_year: work_data['first_publish_year'],
      cover_id: work_data['cover_i'],
      isbn: work_data['isbn']&.first,
      page_count: work_data['number_of_pages_median']
    )

    books_created += 1
    puts "Book created"

    # Process authors
    author_names = work_data['author_name'] || []
    author_keys = work_data['author_key'] || []

    author_names.each_with_index do |author_name, idx|
      # Get author key if available
      author_key = author_keys[idx] || "generated_#{author_name.parameterize.underscore}"

      author = Author.find_or_create_by!(openlibrary_key: author_key) do |a|
        a.name = author_name[0..254]
        a.bio = "Author of #{book.title}"
      end

      BookAuthor.find_or_create_by!(book: book, author: author)
      authors_created += 1 if author.previous_changes.key?(:id)
      puts "  Author: #{author_name}"
    end

    # Process subjects
    subjects = work_data['subject'] || work_info['subjects'] || []
    subjects.first(5).each do |subject_name|
      next if subject_name.blank?

      subject = Subject.find_or_create_by!(name: subject_name[0..99])
      BookSubject.find_or_create_by!(book: book, subject: subject)
      subjects_created += 1 if subject.previous_changes.key?(:id)
    end

    puts "Added subjects"

  rescue ActiveRecord::RecordInvalid => e
    puts "Validation failed: #{e.message}"
  rescue => e
    puts "Error: #{e.message}"
  end

  sleep(0.5) # Be nice to the API
end

# ============================================================================
# STEP 4: GENERATE REVIEWS WITH FAKER
# ============================================================================

puts "\n\nGenerating reviews with Faker..."
puts "-" * 70

begin
  require 'faker'

  Book.find_each do |book|
    review_count = rand(3..7)

    review_count.times do
      Review.create!(
        book: book,
        reviewer_name: Faker::Name.name,
        rating: rand(1..5),
        comment: Faker::Lorem.paragraph(sentence_count: rand(2..4)),
        review_date: Faker::Date.between(from: 2.years.ago, to: Date.today)
      )
    end

    puts "#{review_count} reviews for '#{book.title[0..40]}...'"
  end
rescue LoadError
  puts "Faker not installed. Run: bundle install"
  puts "   Creating simple reviews instead..."

  # Fallback: Create simple reviews without Faker
  Book.find_each do |book|
    3.times do |i|
      Review.create!(
        book: book,
        reviewer_name: "Reader #{rand(1000..9999)}",
        rating: rand(1..5),
        comment: "This is a review comment that meets the minimum length requirement for validation.",
        review_date: Date.today - rand(1..365).days
      )
    end
    puts "3 reviews for '#{book.title[0..40]}...'"
  end
end

# ============================================================================
# FINAL STATISTICS
# ============================================================================

puts "\n\n" + "="*70
puts "FINAL DATABASE STATISTICS"
puts "="*70
puts "Books: #{Book.count}"
puts "Authors: #{Author.count}"
puts "Subjects: #{Subject.count}"
puts "Reviews: #{Review.count}"
puts "Book-Author relationships: #{BookAuthor.count}"
puts "Book-Subject relationships: #{BookSubject.count}"
puts "="*70

# ============================================================================
# SAMPLE DATA
# ============================================================================

if Book.any?
  puts "\nSample Data Check:"
  puts "-" * 70

  sample_book = Book.includes(:authors, :subjects, :reviews).first
  puts "  '#{sample_book.title}'"
  puts "   Authors: #{sample_book.authors.pluck(:name).join(', ')}"
  puts "   Subjects: #{sample_book.subjects.limit(5).pluck(:name).join(', ')}"
  puts "   Reviews: #{sample_book.reviews.count}"
  puts "   Avg Rating: #{sample_book.average_rating} / 5.0"
end

puts "\nSeeding complete!\n\n"
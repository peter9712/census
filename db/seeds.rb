=begin
require 'json'
require 'pathname'

def build_people_hash(entries)
  people = {}
  entries.each do |entry|
    topic_name = entry["topic_author"]["full_name"]
    unless people[topic_name]
      person = Person.create(full_name: topic_name, greek_full_name: entry["topic_author"]["greek_name"])
      people[topic_name] = person
    end

    responsibility = entry['responsibility']
    unless people[responsibility]
      person = Person.create(full_name: responsibility)
      people[responsibility] = person
    end
  end
  people
end

def build_languages
  languages = [
      {
          name: 'Greek',
          code: 'gre',
          ordinal: 1
      },
      {
          name: 'French',
          code: 'fre',
          ordinal: 2
      }
  ]
  languages.each do |lang|
    Language.create(name: lang[:name], code: lang[:code], ordinal: lang[:ordinal])
  end
end

def build_roles
  roles = ['author', 'translator', 'editor']
  roles.each {|role| Role.create(name: role)}
end

def build_statuses
  statuses = {
      :needs_review => Status.create(name: 'needs_review'),
      :finished => Status.create(name: 'finished')
  }
  statuses
end

def build_texts(entries, people, statuses)
  entries.each do |entry|
    title = entry['title']
    topic_author = people[entry['topic_author']['full_name']]

    note = entry.key?('notes') ? entry['notes'].join("\n\n") : ''

    text = Text.create!(
        title: title,
        census_id: entry['id'],
        topic_author: topic_author,
        date: entry['date'],
        publisher: entry['publisher'],
        journal_title: entry['journal_title'],
        parent_issue: entry['journal_issue'],
        location: entry['place_of_publication'],
        original: entry['full_text'],
        page_span: entry['page_span'],
        page_count: entry['page_count'],
        genre: entry['genre'],
        note: note,
        source: entry['original_source'],
        status: statuses[:needs_review]
    )

    responsibility = entry['responsibility']
    TextCitation.create(text: text, name: responsibility)

    contributors = entry['contributors']
    contributors.each do |contributor|
      TextCitation.create(text: text, name: contributor['name'], role: contributor['role'])
    end

    if entry.key? 'isbns'
      entry['isbns'].each {|isbn| StandardNumber.create(text: text, value: isbn)}
    end

    entry['components'].each do |part|
      Component.create(
          text: text,
          title: part['title'],
          pages: part['pages'],
          ordinal: part['position']
      )
    end
  end
end

def build_users
  user = User.create! :email => 'benjamin.florin@bc.edu', :password => 'tictactoe', :password_confirmation => 'tictactoe'
end

seed_file = File.join(File.dirname(__FILE__), "../datapp/seed.rb")
if File.exist? File.expand_path seed_file
  require seed_file
  build_users
else
  seed_file.to_str
  json_file = File.join(File.dirname(__FILE__), "../data/a-c.json")
  contents = File.read(json_file)
  entries = JSON.parse(contents)
  build_languages
  build_roles
  statuses = build_statuses
  people = build_people_hash(entries)
  build_texts(entries, people, statuses)
  build_users
end
=end


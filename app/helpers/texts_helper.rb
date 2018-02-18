module TextsHelper
  def texts_by_author(texts)
    authors = []
    author_group = {
        :author => texts[0].topic_author.full_name,
        :texts => []
    }

    texts.each do |text|
      unless text.topic_author.full_name == author_group[:author]
        authors.push(author_group)
        author_group = {
            :author => text.topic_author.full_name,
            :texts => []
        }
      end
      author_group[:texts].push(text)
    end
    authors.push(author_group)
  end

  def topic_authors
    topic_authors = []
    Person.where(topic_flag: true).each do |person|
      topic_authors.push([person.full_name, person.id])
    end
    topic_authors
  end

  def journals
    journals = []
    Journal.limit(1000).each do |journal|
      journals.push([journal.title, journal.id])
    end
    journals
  end

  # HACK should be able to pull nested Language relationships automatically
  # TODO remove where model method from view helper - place in controller or model
  def get_lang_from_id(lang_id)
    if lang_id.is_a? Integer
      Language.where(:id => lang_id).first
    else
      nil
    end
  end
end

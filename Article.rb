require 'Document.rb'

class Article < Document
  def initialize (magazine, id, year, title, sections)
    super(id, year, title, sections)
    @magazine=magazine
  end

  attr_reader :magazine

  def to_s
    toString=super()+"Abstract: #{abstract(sections[0])}\nSection number: #{(sections.length-1).to_s}\nSections:\n"
    for section in (sections.drop(1))
      toString+=(section.split("\n")[0])+"\n"
    end
    return toString
  end

end
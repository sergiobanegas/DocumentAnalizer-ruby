require 'Document.rb'

class Article < Document
  def initialize (magazine, id, year, title, sections)
    super(id, year, title, sections)
    @magazine=magazine
  end

  def publishedInMagazineAndContainsAcronym(magazine, acronym)
    if (containsAcronym?(acronym) &&  (@magazine.upcase.include? magazine))
      return @title
    end
  end

  def to_s
    toString=super+"Abstract: #{abstract(@sections[0])}\nSection number: #{@sections.length-1}\nSections:\n"
    @sections.drop(1).each do |section|
      toString+=(section.split("\n")[0])+"\n"
    end
    return toString
  end

end
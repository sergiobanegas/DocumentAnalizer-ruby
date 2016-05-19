require 'Document.rb'

class WikiDocument < Document
  def initialize (id, year, title, sections)
    super
  end

  def to_s
    toString= super+"Introduction: #{abstract(@sections[0].split("\n")[1])}\nSection number: #{(@sections.length-1)}\nSections\n"
    @sections.drop(1).each do |section|
      toString+=(section.split("\n")[0])+"\n"
    end
    return toString
  end

end
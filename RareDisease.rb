require 'Document.rb'

class RareDisease < Document
  def initialize (id, year, title, sections)
    super
  end

  def to_s
    toString= super()+"Introduction: #{abstract(sections[0].split("\n")[1])}\nSection number: #{(sections.length-1).to_s}\nSections\n"
    for i in (sections.drop(1))
      toString+=(i.split("\n")[0])+"\n"
    end
    return toString
  end

end
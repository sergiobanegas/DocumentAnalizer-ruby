require 'Document.rb'

class Cluster
  include Comparable  # optional, but might as well
  def initialize (title, documents)
    @title, @documents = title, documents
  end

  attr_accessor :title, :documents

  def <=>(cluster)
    cluster.documents.length <=> @documents.length
  end

  def hasDocument?(document)
    return (@documents.include? document)
  end

  def removeDocument(document)
    @documents.delete(document)
  end

  def numberOfDocuments()
    return @documents.length
  end

  def to_s
    expandedFormTitle=@documents[0].getExpandedForm(@title)
    if expandedFormTitle==""
      expandedFormTitle=@title
    end
    toString="Category: #{expandedFormTitle}\n"
    for document in @documents
      toString+=document.getIdAndTitle+"\n"
    end
    toString+="------------------------------------------------\n"
    return toString
  end

end
class Document
  require 'WordFunctions'
  require 'LCS'

  def initialize (id, year, title, sections)
    @id, @year, @title, @sections= id, year, title, sections
    @wordFunctions=WordFunctions.new
    @acronyms=acronymList
    @lcs = LCS.new
  end

  attr_reader :id, :year, :title, :sections

  def getAcronymsHash
    Hash[@acronyms.collect { |acronym| [acronym, getExpandedForm(acronym)] }]
  end

  def getIdAndTitle
    "Id: #{@id}, title: #{@title}"
  end

  def getTitleAndId
    "#{@title} - #{@id}"
  end

  def isArticle?
    @wordFunctions.is_integer?(@id)
  end

  def publishedInYear?(year)
    @year==year
  end

  def hasId?(id)
    @id.include? id
  end

  def containsAcronym?(acronym)
    (Array(@acronyms)).include? acronym
  end

  def getExpandedFromHash(hash)
    expandedForms=[]
    @acronyms.each do |acronym|
      expandedForms.push(acronym+" = "+hash[acronym]);
    end
    return expandedForms
  end

  def getAcronymAndTimesRepeated
    acronymsAndTimes=[]
    exists=true
    for acronym in @acronyms
      acronymsAndTimes.push("#{acronym}: #{timesRepeated(acronym).to_s} times")
    end
    return acronymsAndTimes
  end

  def hasNoAcronyms?
    @acronyms.length==0
  end

  def to_s
    "--------------------------------------\nTitle: #{@title} (#{@year})\n"
  end

  def getExpandedForm(acronym)
    possibleExpandedForm=""
    expandedFormList=[]
    sectionNumber=0
    for section in @sections
      sectionWords=section.split(" ")
      sectionNumber+=1
      sectionWordsHash = Hash[sectionWords.map.with_index.to_a]
      index=nil
      acronymParenthesis="("+acronym+")"
      if (sectionWordsHash.keys.grep /(#{acronymParenthesis}.*)/)
        acronymsContained=(sectionWordsHash.keys.grep /(#{acronymParenthesis}.*)/)
        for acronymContained in acronymsContained
          if (acronymContained.include? "("+acronym)&&(acronymContained.include? "("+acronym)
            index=sectionWordsHash[acronymContained]
            break
          end
        end
      end
      if (index)
        acronym=acronym.gsub('-', '')
        possibleExpandedForm=(sectionWords[0,index].reverse![0, acronym.length+1]).reverse!
        wordNumber=0
        acronymPosition=0
        for acronymPosition in 0..acronym.length
          added=false
          while (!added)&&(wordNumber<possibleExpandedForm.length)
            if (possibleExpandedForm[wordNumber].include? "”")
              possibleExpandedForm[wordNumber]=possibleExpandedForm[wordNumber].gsub("”", "")
            end
            if (possibleExpandedForm[wordNumber].include? "“")
              possibleExpandedForm[wordNumber]=possibleExpandedForm[wordNumber].gsub("“", "")
            end
            if (possibleExpandedForm[wordNumber].include? "[")
              possibleExpandedForm[wordNumber]=possibleExpandedForm[wordNumber].gsub("[", "")
            end

            if (((possibleExpandedForm[wordNumber].include? ".")||(possibleExpandedForm[wordNumber].include? ",")) &&(expandedFormList.length==0))
              wordNumber+=1
            elsif (expandedFormList.length==0)&&(wordNumber==possibleExpandedForm.length-1)&&(possibleExpandedForm[wordNumber].chr.upcase==acronym.chr.upcase)&&(!@wordFunctions.isInvalidWord?(possibleExpandedForm[wordNumber]))
              valid=true
              for letter in 0..acronym.length-1
                if (!(possibleExpandedForm[wordNumber].upcase.include? acronym[letter].chr))
                  valid=false
                end
              end
              if valid
                expandedFormList.push(possibleExpandedForm[wordNumber])
                added=true
              end
              wordNumber+=1
            elsif (@lcs.similars(@wordFunctions.firstLetters((expandedFormList+possibleExpandedForm[wordNumber, possibleExpandedForm.length]), acronym), acronym, 50))
              if (acronymPosition==0)
                if ((possibleExpandedForm[wordNumber].chr.upcase==acronym[acronymPosition].chr.upcase))&&(!@wordFunctions.isInvalidWord?(possibleExpandedForm[wordNumber]))
                  expandedFormList.push(possibleExpandedForm[wordNumber])
                  added=true
                  if (possibleExpandedForm[wordNumber].include? "-")
                    composedWord=Array.new
                    composedWord.push(possibleExpandedForm[wordNumber])
                    wordNumber=+(@wordFunctions.firstLetters(composedWord, acronym)).length
                  else
                    wordNumber+=1
                  end
                else
                  wordNumber+=1
                end
              else
                if (acronymPosition==acronym.length-1)&&(@wordFunctions.isInvalidWord?(possibleExpandedForm[wordNumber]))
                  wordNumber+=1
                else
                  expandedFormList.push(possibleExpandedForm[wordNumber])
                  added=true
                  if (possibleExpandedForm[wordNumber].include? "-")
                    composedWord=Array.new
                    composedWord.push(possibleExpandedForm[wordNumber])
                    wordNumber+=(@wordFunctions.firstLetters(composedWord, acronym)).length
                  else
                    wordNumber+=1
                  end
                end
              end
            else
              wordNumber+=1
            end
          end
        end
      end
    end
    if expandedFormList.length==0
      return ""
    else
      return expandedFormList.join(' ')
    end
  end

  private

  def timesRepeated(acronym)
    times=0
    for section in @sections
      words=section.split(" ")
      for word in words
        if word.gsub(/[().;,]/, '')==acronym
          times+=1
        end
      end
    end
    return times
  end

  def abstract(text)
    words=text.split(" ")
    if words.length>33
      words=words[0..33]
      text=words.join(" ")+"..."
    end
    return text
  end

  def acronymList
    acronyms = Array.new
    for section in @sections
      words = section.split(" ")
      for word in words
        if word[word.length-1]==","||word[word.length-1]=="."||word[word.length-1]=="]"||word[word.length-1]==":"||word[word.length-1]==";"
          word=word[0..word.length-2]
        end
        if (word[0].chr=="(")&&(@wordFunctions.isAcronym?(word))&&(word[word.length-1].chr==")")
          acronyms.push(word.gsub(/[().;,]/, '') )
        end
      end
    end
    return acronyms.uniq
  end
end
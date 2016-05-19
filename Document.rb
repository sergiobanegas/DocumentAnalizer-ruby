class Document
  require 'Functions'
  require 'LCS'

  def initialize (id, year, title, sections)
    @id, @year, @title, @sections= id, year, title, sections
    @functions=Functions.new
    @lcs = LCS.new
    @acronyms=acronymList
  end

  def addAcronymsHash(acronyms)
    acronyms.merge(@acronyms)
  end

  def addAcronyms(acronyms)
    acronyms.concat @acronyms.keys
  end

  def getIdAndTitle
    "#{@id} - #{@title}"
  end

  def getTitleAndId
    "#{@title} - #{@id}"
  end

  def isArticle?
    @functions.is_integer?(@id)
  end

  def publishedInYear?(year)
    @year==year
  end

  def hasId?(id)
    @id==id
  end

  def containsAcronym?(acronym)
    (@acronyms.keys).include? acronym
  end

  def getExpandedFromHash(hash)
    @acronyms.keys.collect{|acronym| acronym+" = "+hash[acronym]}
  end

  def getAcronymsAndTimesRepeated
    @acronyms.keys.collect{|acronym| "#{acronym}: #{timesRepeated(acronym)} veces"}
  end

  def hasNoAcronyms?
    @acronyms.length==0
  end

  def getExpandedForm(acronym)
    @acronyms[acronym]
  end

  def to_s
    "--------------------------------------\nTitle: #{@title} (#{@year})\n"
  end

  private

  def findExpandedForm(acronym)
    possibleExpandedForm=""
    expandedFormList=[]
    sectionNumber=0
    @sections.each do |section|
      sectionWords=section.split(" ")
      sectionNumber+=1
      sectionWordsHash = Hash[sectionWords.map.with_index.to_a]
      index=nil
      acronymParenthesis="("+acronym+")"
      if (sectionWordsHash.keys.grep /(#{acronymParenthesis}.*)/)
        acronymsContained=(sectionWordsHash.keys.grep /(#{acronymParenthesis}.*)/)
        acronymsContained.each do |acronymContained|
          if (acronymContained.include? "("+acronym)&&(acronymContained.include? acronym+")")
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
            elsif (expandedFormList.length==0)&&(wordNumber==possibleExpandedForm.length-1)&&(possibleExpandedForm[wordNumber].chr.upcase==acronym.chr.upcase)&&(!@functions.isInvalidWord?(possibleExpandedForm[wordNumber]))
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
            elsif (@lcs.similars(@functions.firstLetters((expandedFormList+possibleExpandedForm[wordNumber, possibleExpandedForm.length]), acronym), acronym, 50))
              if (acronymPosition==0)
                if ((possibleExpandedForm[wordNumber].chr.upcase==acronym[acronymPosition].chr.upcase))&&(!@functions.isInvalidWord?(possibleExpandedForm[wordNumber]))
                  expandedFormList.push(possibleExpandedForm[wordNumber])
                  added=true
                  if (possibleExpandedForm[wordNumber].include? "-")
                    composedWord=Array.new
                    composedWord.push(possibleExpandedForm[wordNumber])
                    wordNumber=+(@functions.firstLetters(composedWord, acronym)).length
                  else
                    wordNumber+=1
                  end
                else
                  wordNumber+=1
                end
              else
                if (acronymPosition==acronym.length-1)&&(@functions.isInvalidWord?(possibleExpandedForm[wordNumber]))
                  wordNumber+=1
                else
                  expandedFormList.push(possibleExpandedForm[wordNumber])
                  added=true
                  if (possibleExpandedForm[wordNumber].include? "-")
                    composedWord=Array.new
                    composedWord.push(possibleExpandedForm[wordNumber])
                    wordNumber+=(@functions.firstLetters(composedWord, acronym)).length
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

  def timesRepeated(acronym)
    times=0
    @sections.each do |section|
      words=section.split(" ")
      words.map{|word| times+=1 if word.gsub(/[().;,]/, '')==acronym}.compact
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
    @sections.each do |section|
      words = section.split(" ")
      words.each do |word|
        if word[word.length-1]==","||word[word.length-1]=="."||word[word.length-1]=="]"||word[word.length-1]==":"||word[word.length-1]==";"
          word=word[0..word.length-2]
        end
        if (word[0].chr=="(")&&(@functions.isAcronym?(word))&&(word[word.length-1].chr==")")
          acronyms.push(word.gsub(/[().;,]/, '') )
        end
      end
    end
    return Hash[acronyms.uniq.collect { |acronym| [acronym, findExpandedForm(acronym)] }]
  end

end
require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"

  erb :home
end

get "/chapters/:number" do
  number = params[:number].to_i
  redirect "/" unless (1..@contents.size).cover?(number)

  @chapter = File.read("data/chp#{number}.txt")
  @title = "Chapter #{number}: #{@contents[number - 1]}"

  erb :chapter
end


def each_chapter
  @contents.each_with_index do |chp_title, index|
    chp_num = index + 1
    content = File.read("data/chp#{chp_num}.txt")
    yield chp_title, chp_num, content
  end
end

def matching_chapters(query)
  results = []
  return results if !query || query.empty?

  each_chapter do |chp_title, chp_num, chp_content|
    matches = {}
    
    paragraphs = chp_content.split("\n\n")
    paragraphs.each_with_index do |paragraph, index|
      matches[index] = paragraph if paragraph.include?(query)
    end

    results << { title: chp_title, chapter_num: chp_num, matches: matches } unless matches.empty?
  end

  results
end

get "/search" do
  @search_term = params[:query]
  @results = matching_chapters(@search_term)
  
  erb :search
end

not_found do
  redirect "/"
end

helpers do
  def in_paragraphs(chapter)
    paragraphs = chapter.split("\n\n")
    paragraphs.map.with_index do |paragraph, index| 
      "<p id=paragraph#{index}>#{paragraph}</p>"
    end.join
  end

  def bold_result(paragraph, query)
    paragraph.gsub(query, "<strong>#{query}</strong>")
  end
end

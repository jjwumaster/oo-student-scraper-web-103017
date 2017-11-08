require 'open-uri'
require 'pry'
require 'nokogiri'


class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    output = []
    profiles = doc.css("div.student-card")
    profiles.each do |profile|
      output << {
      name: profile.css("a div.card-text-container h4.student-name").text,
      location: profile.css("a div.card-text-container p.student-location").text,
      profile_url: profile.css("a").attribute("href").value
      }
    end
    output
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    # social # iterate through ### doc.css("div.social-icon-container a")
    output = {}
    socials = doc.css("div.social-icon-container a")

    profile_links = socials.collect do |social|
      link = social.attribute("href").value
    end

    profile_links.each do |link|
      if link.include?("twitter")
        output[:twitter] = link
      elsif link.include?("github")
        output[:github] = link
      elsif link.include?("linkedin")
        output[:linkedin] = link
      elsif link
        output[:blog] = link
      end
    end

    output[:profile_quote] = doc.css("div.profile-quote").text
    output[:bio] = doc.css("div.description-holder p").text
    # twitter social.attribute("href").value
    # linkedin social.attribute("href").value
    # github social.attribute("href").value
    # blog_url

    # profile_quote doc.css("div.profile-quote").text
    # bio doc.css("div.description-holder p").text

    # binding.pry

    output

  end

end

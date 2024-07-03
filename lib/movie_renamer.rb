# frozen_string_literal: true

require 'thor'
require 'colorize'
require 'fileutils'
require 'httparty'
require 'dotenv'

Dotenv.load

module MovieRenamer
  class CLI < Thor
    desc 'rename DIRECTORY', 'Rename MP4 files in the specified directory using TMDB data'
    method_option :dry_run, type: :boolean, default: false, desc: 'Perform a dry run without renaming files'
    def rename(directory)
      puts "Renaming MP4 files in #{directory}".green

      Dir.glob(File.join(directory, '*.mp4')) do |file|
        original_name = File.basename(file, '.mp4')
        cleaned_name = clean_filename(original_name)
        puts "Processing: #{original_name}".yellow
        puts "Cleaned name: #{cleaned_name}".cyan

        begin
          # Search TMDB using the cleaned file name
          results = search_tmdb(cleaned_name)

          if results.empty?
            puts "No results found for: #{cleaned_name}".red
            next
          end

          # Get the best match from TMDB results (assuming the first result is the best match)
          best_match = results.first

          # Create a new file name based on TMDB data
          new_name = "#{best_match['title']} (#{best_match['release_date'][0..3]}).mp4"
          new_name = sanitize_filename(new_name)

          if options[:dry_run]
            puts "Would rename: #{original_name} -> #{new_name}".blue
          else
            # Rename the file
            new_path = File.join(File.dirname(file), new_name)
            FileUtils.mv(file, new_path)
            puts "Renamed: #{original_name} -> #{new_name}".green
          end
        rescue StandardError => e
          puts "Error processing #{original_name}: #{e.message}".red
        end
      end

      puts 'Renaming complete!'.green
    end

    private

    def clean_filename(filename)
      # Remove extra characters at the end of the filename
      cleaned = filename.gsub(/\s+-\s+-.*$|\s+-\s+--.*$|\s+-\s+.*Spielfilm.*$/, '')
      cleaned.strip
    end

    def search_tmdb(query)
      api_key = ENV['TMDB_API_KEY']
      url = 'https://api.themoviedb.org/3/search/movie'
      response = HTTParty.get(url, query: {
                                api_key:,
                                query:,
                                language: 'de-DE' # Add German language parameter
                              })

      if response.success?
        response.parsed_response['results']
      else
        puts "Error searching TMDB: #{response.code} #{response.message}".red
        []
      end
    end

    def sanitize_filename(filename)
      # Remove or replace characters that are invalid in filenames
      filename.gsub(/[^\w\s\-().]/, '')
    end
  end
end

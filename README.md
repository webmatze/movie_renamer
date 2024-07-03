# MovieRenamer

MovieRenamer is a Ruby CLI tool that helps you rename your movie files using data from The Movie Database (TMDB). It searches for MP4 files in a specified directory, cleans up the filenames, and renames them based on the movie information retrieved from TMDB.

## Features

- Searches for MP4 files in a specified directory
- Cleans up filenames by removing extra characters
- Searches TMDB for movie information using the cleaned filename
- Renames files using the format: "Movie Title (Year).mp4"
- Supports German language search and results
- Provides a dry-run option to preview changes without actually renaming files

## Installation

1. Clone this repository:

   ```
   git clone https://github.com/yourusername/movie_renamer.git
   cd movie_renamer
   ```

2. Install the required gems:

   ```
   bundle install
   ```

3. Set up your TMDB API key:
   - Sign up for a TMDB account at <https://www.themoviedb.org/>
   - Get your API key from your account settings
   - Create a `.env` file in the project root directory and add your API key:

     ```
     TMDB_API_KEY=your_api_key_here
     ```

## Usage

To rename movies in a directory:

```
./bin/movie_renamer rename /path/to/your/movies
```

To perform a dry run (preview changes without renaming):

```
./bin/movie_renamer rename /path/to/your/movies --dry-run
```

## Example

Original filename: `Ace Ventura - Ein tierischer Detektiv - -.mp4`
Renamed to: `Ace Ventura - Ein tierischer Detektiv (1994).mp4`

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/webmatze/movie_renamer>.

## License

This project is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


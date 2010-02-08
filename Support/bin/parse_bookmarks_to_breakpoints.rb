#!/usr/bin/env ruby -w

path = File.expand_path(ARGV[0])
bookmarks = `xattr -rp com.macromates.bookmarked_lines #{path} 2>/dev/null`

def parse_bookmarks_to_breakpoints(bookmarks)
  # make xattr output into breakpoit syntax => /foo/file.as:27
  # Remove whitespace and newlines
  bookmarks.gsub!("\n","").gsub!(" ","")
  # Files are separated by ) so make an array of files by splitting on the )
  files = bookmarks.split(")");
  # Make an array to hold the breakpoints we make
  breakpoints = []
  # loop over the files to make them into breakpoints
  files.each do |item|
    # File paths are separated by ( so split them into an array
    items = item.split("(")
    # All we are left with now is the file path and the line numbers in an array [/foo/file.as:, 27, 10]
    items.each_with_index do |item,i|
        # item 0 in the array is the basepath
        basepath=items[0]
        # the line numbers are separated by , so make a new array of the line numbers
        line_numbers = item.split(",")
        line_numbers.each do |line_number|
          #don't concat the basepath just the numbers
          if line_number != basepath
             # Build our breakpoint syntax
             breakpoint = "#{basepath}#{line_number}"
             # Add our new breakpoint to our breakpoints array
             breakpoints.push(breakpoint)
          end
        end
    end
  end
  p breakpoints
  return breakpoints.to_s
end

parse_bookmarks_to_breakpoints(bookmarks)

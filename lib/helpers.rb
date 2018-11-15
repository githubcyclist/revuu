module Helpers

  # NOTE: move some methods to settings_helper.rb and some to help_helper.rg

  # Clear screen and print header. Used throughout the app. RF
  def clear_screen
    system("clear")
    header
  end

  # Used in clear_screen above. RF
  def header
    puts sprintf("%-69s%s", " * R * E * V * U * U *",  "v. 3.0").
      colorize(:color => :black, :background => :white)
    puts ''
  end

  def get_user_command(leader)
    extra_space = ( ("=+a".include? (leader)) ? "" : "  ")
    print "#{extra_space}#{leader}> "
    gets.chomp
  end

  # This is copied into new Java answers. Used throughout class Task.  RF
  def java_starter
    return <<~JAVASTARTER
      public class answer_#{@id} {
          public static void main(String[] args) {
              /* do not edit 'answer_<id>' */
          }
      }
      JAVASTARTER
  end

end

module LanguageHelper

  def solicit_languages_from_user
    # Show user language.
    puts "Default language is #{$lang}."
    # Load language data and make hashes for $ext and $cmnt (here only).
    language_data = get_available_langs
    # Check which languages are available on the system.
    available_langs = language_data.reject do |l|
      ! `which #{l[:cmd]}`
    end
    # If, amazingly, there's only one language, say so and exit.
    if available_langs.length == 1
      puts "There's only one language available and you're using it."
      return nil, nil
    end
    # Show available languages to user.
    print "Available languages:\n  "
    available_langs.each_with_index {|l,i| print "(#{i+1}) #{l[:name]} "}
    puts "\n"
    # Solicit new language.
    puts "Enter the number of a language to switch to or <Enter> for current."
    new_lang = get_user_command('c')
    (return nil, nil) if new_lang == ''
    new_lang = new_lang.to_i - 1 # -1 to compensate for +1 above.
    # Abandon if number not listed.
    if ! available_langs[new_lang]
      puts available_langs == 2 ?
        "Choose (1) or (2)." :
        "Input a number from (1) to (#{available_langs.length})."
      return 0, available_langs
    end
    # new_lang = the lang's index in the array of available langs.
    return new_lang, available_langs
  end

  $text_editors = {
    'Sublime Text'        => 'subl',
    'Atom'                => 'atom',
    'Nano'                => 'nano',
    'Pico'                => 'pico',
    'Visual Studio Code'  => 'code',
    'vi'                  => 'vi',
    'vim'                 => 'vim',
    'Eclipse'             => 'eclipse',
    'IntelliJ'            => 'idea',
    'Android Studio'      => 'studio',
    'Xcode'               => 'xcode',
    'Netbeans'            => 'netbeans',
    'PhpStorm'            => 'phpstorm',
    'PyCharm'             => 'pycharm',
    'Emacs'               => 'emacs',
    'gedit'               => 'gedit'
  }

  def archive_old_answer(task)
    old_archive = File.exist?($old_location) ? File.read($old_location) : ''
    # Load current answer file contents.
    contents = File.read($location)
    # If C, Java, etc., then completely overwrite old answer file
    if $one_main_per_file
      new_archive = contents
      # If Java, the main class needs to be renamed to be runnable.
      if task.lang == 'Java'
        new_archive.gsub!('public class answer', 'public class answer_old')
      end
    # Else the usual case: append newer answer to top of old_archive.
    else
      # Separate different archived answers with a line of comments.
      # Use $cmnt2 for /* ... */ style comments.
      comment_separator = ($cmnt2 ? (($cmnt*37) + $cmnt2) : ($cmnt*37) )
      # Concatenate current contents with archive file contents.
      new_archive =
        contents + ("\n\n\n" + comment_separator + "\n\n\n") + old_archive
    end
    # Write concatenated contents to the location of the archive.
    File.write($old_location, new_archive)
    # Finally, overwrite the current answer file with '' or Java template.
    create_answer_file(task)
  end

  def create_answer_file(task)
    if ! File.exist?($location)
      system("touch #{$location}")
    end
    if task.lang == 'Java'
      # So far, only Java files need to be written-to before getting started.
      File.write($location, java_starter(task))
    else
      File.write($location, '')
    end
  end

  def java_starter(task)
    return <<JAVASTARTER
public class answer_#{task.id} {
    public static void main(String[] args) {

    }
}
JAVASTARTER
  end

  # Given a language name (as in Task#lang or as stored in settings.json)
  # return a language data hash.
  def lookup_lang_data_from_name_cmd(lang_cmd)
    langs = get_available_langs
    langs.find {|l| l[:name] == lang_cmd }
  end

  # Language data hashes.
  def get_available_langs
    [
      {name: 'Ruby', ext: 'rb', cmd: 'ruby', cmnt: '#', alts: []},
      {name: 'JavaScript', ext: 'js', cmd: 'node', cmnt: '//', alts: 
        ['JS', 'Node', 'Node.js']},
      {name: 'Java', ext: 'java', cmd: 'javac', cmd2: 'java <name-no-ext>',
        cmnt: '//', one_main_per_file: true, alts: []},
      {name: 'C', ext: 'c', cmd: 'gcc', cmd2: './a.out', cmnt: '/*',
        cmnt2: '*/', one_main_per_file: true, alts: ['C language',
        'C programming language']},
      {name: 'Bash', ext: 'sh', cmd: '/bin/bash', cmnt: '#', alts: ['command line', 'shell',
        'shell scripting', 'Bash scripting', 'Linux', 'Unix']},
      {name: 'Other', ext: 'txt', cmd: 'more', cmnt: '#', alts: []}
    ]
  end

  # Given a language data hash, assign language globals.
  # REFACTOR NOTE: probably, this three-method system can be simplified;
  # should probably be a new class.
  def assign_language_globals(l)
    # User changes these with configure_language.
    $lang  = l[:name] # Programming language. Get from/set to settings.json.
                      # lookup_lang_data_from_name_cmd gets hash values from
                      # get_available_langs.
    $ext   = l[:ext]                # Filename extension.
    $cmd   = l[:cmd]                # Command to execute (or compile).
    $cmnt  = l[:cmnt]               # Comment char in language.
    $cmd2  = l[:cmd2]  ? l[:cmd2]  : false  # Run after compiling in, e.g., C.
    $cmnt2 = l[:cmnt2] ? l[:cmnt2] : false  # Comment-ender in, e.g., C.
    $one_main_per_file = l[:one_main_per_file] ? l[:one_main_per_file] : false
    $lang_alts = l[:alts]
  end


end
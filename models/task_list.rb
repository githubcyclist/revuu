###############################################################################
class TaskList
  attr_accessor :list, :default_tag, :tag_filtered_list, :pagination_num,
    :old_tag, :tag_hash
  def initialize
    @list = []
    @tasklist_filter = 'all'
    @pagination_num = 1
    load_all_tasks
  end

  def load_all_tasks
    # Let it work without the datafile existing.
    if (File.exist?("./data/tasks.json") &&
      File.stat("./data/tasks.json").size > 0)
      file = File.read "./data/tasks.json"
      data = JSON.parse(file)
      task_array = data['tasks']
      construct_tasks_array(task_array)
    end
  end

  def construct_tasks_array(task_array)
    task_array.each do |task|
      task_with_symbols = {}
      task.each {|k,v| task_with_symbols[k.to_sym] = v }
      @list << Task.new(task_with_symbols)
      @list = @list.sort!{|x,y| DateTime.parse(x.next_review_date) <=>
        DateTime.parse(y.next_review_date)}
    end
  end

  def save_tasklist
    # Convert $tasks.list to JSON.
    json = to_json
    # Overwrite datafile.
    File.open("./data/tasks.json", "w") do |f|
      f.write(json)
    end
    save_change_timestamp_to_settings
  end

  def to_json
    JSON.pretty_generate({"tasks": @list.map{|task| task.to_hash } })
  end

  # Start over. Delete all data in tasks.json, starters/, and answers/.
  def destroy_all
    if user_confirms_destruction
      # Actually perform the file deletions.
      system("rm data/tasks.json")
      system("rm data/settings.json")
      # Save the user's existing editor and default language in new settings file.
      update_settings_file({lang: $lang_defaults.name, texted: $texted})
      system("rm -f answers/*")
      system("rm -f starters/*")
    else
      puts "Nothing destroyed. Remember, you can back up your data with [a]rchive."
    end
    # Reload the goods.
    App.load_defaults_from_settings
    $tasks = TaskList.new
    sleep 2
    $tasks.display_tasks
    # Tell the user if it worked.
    puts "All tasks destroyed."
  end

  # Given an integer, return a task from the tasklist.
  def validate_edit_request(num)
    @list.find {|t| t.id == num }
  end

  def prepare_hash_of_tag_arrays
    @tag_hash = {}
    $tasks.list.each do |task|
      next unless task.tags
      task.tags.each do |tag|
        @tag_hash[tag] = [] unless @tag_hash[tag]
        @tag_hash[tag] << task
      end
    end
  end

  def clear_tag_search
    @default_tag = nil
    @tag_filtered_list = []
  end

  # Given a task list (whole or filtered), calculate and return the last page.
  def get_last_page(list)
    last_pg = (list.length/10.0).floor + 1
    # This gets rid of an empty page when user has multiples of 10.
    last_pg -= 1 if (list.length/10.0) == (list.length/10)
    last_pg
  end

  # Simply loads the next item (i.e., with the earliest review date).
  def show_next_item
    list = @default_tag ? @tag_filtered_list : @list
    list[0].edit
  end

end # of class TaskList

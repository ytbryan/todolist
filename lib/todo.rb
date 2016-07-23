require "todo/version"
require "fileutils"
require "thor"
require "date"

module Todo
  class Base < Thor
    check_unknown_options!
    package_name 'todo'
    default_task :show
    map 'g' => :generate,
        'd' => :destroy,
        'f' => :find

    desc :complete, 'mark a task complete'
    method_option :all, type: :string, aliases: '-a'
    def complete name
      #if option[:all] then remove all the files
      #-------
      #either the name or the number
      #move the folder to completed
      #write the complete date
    end

    desc :show, 'show task'
    def show name=nil
      allfiles = Dir.glob("#{Dir.home}/.todo/tasks/*.todo")
      if allfiles.count == 0
        puts "\nNothing to show.  You have 0 items."
        puts "ALL DONE. WELL DONE. 🙌🤗"
      else
        puts "\nYou have #{allfiles.count} items to complete."
      end
      # puts "---"
      # puts "Last item was added 17 hours 20 minute ago. And you added approximately 10 items."
      # puts "There is a total 10 items. You have done 4 items in the last 1 hour. You have 16 uncomplete tasks."
      # puts "Total: 10 uncompleted items."
      # puts "---"
      puts "----"

      allfiles.each_with_index do |value, index|
        well = File.basename(value, ".todo")
        # puts data = well.match(/([a-z 0-9]*-)*/)
        data = get_name(well)
        number = well.match(/-[0-9]+/)
        # well = File.basename(value, ".todo")
        final = data.to_s.gsub("-", " ") if value != nil

        puts  "[TODO] #{index+1}. #{final} "  #{return_time_stamp(number.to_s.gsub("-",""))} !!!"
        # puts  "#{index+2}. #{File.basename(value, ".todo")}    2 days ago !!!"
      end
      puts "----"
      # puts "Last item was added 3 days ago."
      # puts "Type `todo complete task_name` to remove the task"
      # puts "No tasks. Type `todo generate task_name` to generate one" if allfiles.count == 0
      # puts "---"
      # puts "Thank you for using Todo List. There is a paid minimalistic web version that I invite you to try out. http://todo-list.net"
    end

    desc :destroy, 'destroy a task'
    method_option :all, type: :string, aliases: '-a'
    method_option :name, type: :string, aliases: '-n'

    def destroy name=nil
      destination = "#{Dir.home}/.todo/everything/"
      origin = "#{Dir.home}/.todo/tasks/"

      if options[:name] == nil
        array = Dir.glob(File.join(origin, '*.todo'))
        file = array[name.to_i-1]
        puts file
        FileUtils.move file, File.join(destination, "1-#{File.basename(file)}")
      else #if options[:name] is not nil
        if options[:all] != nil
          Dir.glob(File.join(origin, '*.todo')).each do |file|
            if File.exists? File.join(destination, File.basename(file))
              FileUtils.move file, File.join(destination, "1-#{File.basename(file)}")
            else
              FileUtils.move file, File.join(destination, File.basename(file))
            end
          end
          puts "Destroy all. Done."
        else
          #if name is number, then okay, if not number
          allfiles = Dir.glob("#{Dir.home}/.todo/tasks/*.todo")
          counter = false
          well = ""
          allfiles.each do |value|
            # puts well = File.basename(value, ".todo")
            # puts value = well.match(/([a-z 0-9]*-)*/)
            # puts number = well.match(/-[0-9]+/)
            # puts final = value.to_s.gsub("-", " ") if value != nil
            if name.strip == final.strip
              FileUtils.rm "#{Dir.home}/.todo/tasks/#{well}.todo"
              puts "great, i deleted something"
              counter = true
            end
          end
          if counter == false
            puts "nothing deleted because nothing is found."
          else
            puts "#{Dir.home}/.todo/tasks/#{well}.todo deleted."
          end
        end
      end #if name
    end

    desc :generate, 'generate a task'
    def generate desc
      fingerprint = Time.now.to_i #1 #use time and hash
      name = "#{desc.gsub(" ","-").downcase}-#{fingerprint}"
      FileUtils.touch "#{Dir.home}/.todo/tasks/#{name}.todo"
    end

    desc :find, 'find a task'
    def find
      puts "find a task"
    end

    # desc :formula, 'do we need formula for repeated tasks'
    # def formula
    #   puts "do we need formula for repeated tasks"
    # end

    # desc :repeat, 'repeated tasks'
    # def repeat
    #   puts "repeated task"
    # end
    #
    # desc :month, 'month'
    # def month
    #   puts "month"
    # end
    #
    # desc :today, 'today'
    # def today
    #   puts "today"
    # end
    #
    # desc :week, 'this week'
    # def week
    #   puts "this week"
    # end
    #
    # desc :stat, 'stat'
    # def stat
    #   puts "stat"
    # end


    # desc :tags, 'find a tags'
    # def tags
    #   puts "find a tags"
    # end


    # desc :later, 'do later'
    # def later
    #   puts "doing later"
    # end
    #
    # desc :ing, 'currently doing'
    # def ing *tasks
    #   puts "#{tasks}"
    # end

    private

    def get_name str
      index = str.rindex(/-/) if str !=nil
      index != nil ? answer = str[0,index] : answer = nil
      return answer
    end

    def setup
      #~/.todo
    end

    def return_time_stamp unix_int
      data = DateTime.strptime(unix_int,'%s')
      return " #{data.to_s} sec ago"
    end

  end
end

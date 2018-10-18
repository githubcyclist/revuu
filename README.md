# revuu
Handy command line app for learning and reviewing programming tasks--improving
procedural (as opposed to declarative) knowledge--using spaced repetition
methods.

## User introduction

This app will help you review programming tasks, improving understanding and
keeping your skills fresh. It was written with the notion that programmers (and
others) need repetition of not declarative but procedural knowledge.

So when you perform a review, you don't try to answer a question in words.
Instead, you try to perform a task. Essentially, to use Revuu, you'd add
complex, not simple, tasks. Probably the ideal Revuu task would require
2-10 minutes to complete.

The basic functions of the program are adding tasks, using the handy answer
filing and editing system (which probably works with your favorite text editor),
running the script and seeing the results, and recording that you've done a
review and that the next review should be done on a certain date. The two basic
views of the app are a paginated list of tasks and an individual task view.

Currently, we support Ruby, Node.js (JavaScript), Java, C, and Bash scripting.
We also support many commonly-used text editors and IDEs.

Add copious, well-chosen tags in order to be able to sort tasks.

Revuu ships with a bunch of pre-made questions and answers by way of
demonstration. You can delete these and make your own, if you like. The
questions are mostly Ruby and JavaScript right now.

## Install and requirements
Clone the repo (instructions should be clear enough from Github). Should
probably make sure a recent version of Ruby (>2.2) is installed. Execute
`bundle install` to install the gem requirements.

Only works on \*nix systems (including modern Macs). I could make some changes
so that it works on Windows, if anybody cares.

## Run
Once Ruby, the app, and the gem dependencies are installed, you should be able
to start the app on your \*nix system just by typing `ruby revuu.rb`.

## Use
The app ships with both tasks (mostly Ruby) and answers. The tasks are in
data/revuu.json and the answers are in answers/, and, if you didn't want to
delete them all by hand, you could simply delete the data file and the app
should still work. (If you try and it doesn't, let me know and I'll fix it.)

Online help is available from the task list by pressing 'c' for 'commands'.

## Development to do list

* Refactoring of the detailed cleanup/editing still needed.
* Improve an "installation" or "first run" script, allowing the user to select
default language and default text editor. Think through the flow.
* Add starter code (for user to edit in his answer) rather than putting this
directly in the instructions. Ensure that, as with Java now, unedited starter
code is not interpreted as an answer (so it won't overwrite the archive). No
reason this bit can't be opened with the default text editor instead of Pico.
* Add wrapper code for C? Think about this.
* Create features to export and import some (tagged) or all items.
* Create features to mass-delete items (such as the pre-loaded questions, or
all of a language you're not studying, or just a tag you're putting aside for
a while).
* Add statistics (number of questions, averages, number overdue, number to do
today, etc.).
* Major improvement would be a feature to let user write and run Rails thangs
and play with CSS, HTML, and web-based JavaScript.

## MVC refactoring notes

In order to make the codebase more maintainable, I've decided to do a major
refactoring. My strategy is (1) move the various helper code to "controller"
and "view" modules associated with "models," although the controller and view
code will be in modules rather than classes, (2) starting from the basic
classes App, TaskList, and Task, I will add a few more classes corresponding
to major data-and-method groupings, to wit, TextEditor, ProgLang, and maybe a
few others.

Actually, I might end up converting the modules to classes later. Some method
calls can become class method calls.

## Version notes

### 1.0 (September 27, 2018)
First published version:

Features include new tasks, list all tasks, delete
task, sort by tags, and various user and programmer documentation. There are
several features related to answering/reviewing tasks: saving a new review
(including date and score), writing an answer using a (one supported) text
editor, running the answer (using at the options of Ruby, Node.js, Java, C,
Bash scripting, and text; including both compiled and interpreted languages),
archiving old answers, and running old answers. From the same screen, the user
can edit task instructions, tags, date of next review, and user's current
score. Task, review, and settings data are all saved in JSON files.

### 1.1 (September 28, 2018)
Text editor support:

Added support for Atom, Eclipse, Pico, Nano, Vi, Vim, and other text editors.
This checks the user's system to see which are available and shows only those.
The app now checks that the settings file exists, pre-populates it with
defaults if not, and makes some other improvements to settings. Also added a
simple 'refresh' function for the task review and edit screen.

### 1.2 (October 1, 2018)
Navigation:

Added pagination and page navigation. Data about any persisted tag searches
and navigation page was added as attributes to the global TaskList object. So
the user can navigate to the second page of tasks, view one, quit that view,
and then be placed back on the second page of tasks. If the user starts from
tag search results (even the second page of them), he is returned to that page.
That means users can search for one particular language (or method) without
having to redo the search in between tasks.

### 1.3 (October 6, 2018)
Lots of little improvements:

Automatically inserts language name and variants into tag list. Similarly,
inserts language name in parentheses before the page title, not in the data,
but when the task is rendered to the user. 'x' command shows the "next due"
task to the user. Let user abandon task instead of inputting instructions or
tags. Changed 'Node.js' to 'JavaScript'. Fixed several bugs; now pretty
stable, but badly needs refactoring; started adding notes for doing that.
Now, when a task list is the result of filtering, there is a green message
at the top of the list saying "Filtered by {language name}". Moved gems to
Gemfile and required them via `Bundler.require(:default)`.

### 2.0 (October 10, 2018)
Refactoring and instructions:

The biggest change that justifies the major version number change is that
the code has been completely rearranged into /models, /controllers, and
/views folders, on analogy with web-based MVC development. There is still
quite a bit of refactoring to do, but this is a big enough change to warrant
the new number. In addition, there is now a large, detailed help system
accessible from both task list and task views. There are also a number of
smaller improvements.

### 2.1 (October 15, 2018)
Added spaced repetition and refactored with Lang class:

Added spaced repetition method (which semi-intelligently suggests a next date
for review). Along with other refactoring, surgically extracted the
language-related methods and structures and placed them carefully within a
brand new Lang class. Consequently, user can now change default language, and
it is now a real default. Stopped calling many accessor methods on named
objects in favor of just using instance variables, after confirming that
controllers and views are adequately self-contained; hence the analogy to MVC
code structure is almost complete. Fixed bugs including a problem with the
"date prettifier."

### 2.2
Ongoing:

Added Python support. Fixed tag bug.

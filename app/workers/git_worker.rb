class GitWorker
  @queue = :git_queue
  def self.perform(user_id,repo_id)
        user = User.find(user_id)
        authtoken = user.everauth
        repo = Repo.find(repo_id)
        %x(git clone #{repo["clone_url"]} #{Rails.root.join('repos',repo["name"])})
        puts "get or create notebook #{repo["name"]}"
        client = EvernoteOAuth::Client.new(token: authtoken)
        note_store = client.note_store
        notebooks_list = note_store.listNotebooks
        nb = nil
        for notebk in notebooks_list
          if notebk.name == repo["name"]
            nb = notebk
          end
        end
        if nb == nil
          notebook = Evernote::EDAM::Type::Notebook.new
          notebook.name = repo["name"]
          nb = note_store.createNotebook(notebook)
          
        end
        ##########################
        note_filter = Evernote::EDAM::NoteStore::NoteFilter.new
        note_filter.notebookGuid = nb.guid
        allnbnotes = note_store.findNotes(note_filter, 0, 10)

        for anote in allnbnotes.notes
          note_store.deleteNote(anote.guid)
        end
        
        
        searchTerms = ["TODO","FIXME","XXX"]
        for searchTerm in searchTerms
        ss = %x(grep #{searchTerm} #{Rails.root.join('repos',repo["name"])} -nr -A 20)
        if ss.length>0
          ss = ss + "--"
          puts "ss greater than 0 length #{ss}"
          todos = ss.split("\n")
          todocontent = ""

          for todo in todos
            if todo.include?("Binary file ")
              next
            end
            todo = todo.sub("#{Rails.root.join('repos',repo["name"])}", "")
            if todo.include?(searchTerm) && todo.count(':') >= 2

              if todocontent.length>0
                puts "hit todo before --" 

@note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note><code>#{todocontent}</code></en-note>
EOF
                todocontent = ""
                note_store.createNote(@note)
              end
              directory = todo[0,todo.index(':')];
              @note = Evernote::EDAM::Type::Note.new
              @note.title = todo
              @note.notebookGuid = nb.guid

            elsif todo == "--"

@note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note><code>#{todocontent}</code></en-note>
EOF
            todocontent = ""
            note_store.createNote(@note)
            else
              todo = todo.sub(directory,"")
              todocontent = todocontent + todo.gsub(/["'<>&]/, '"' => "&quot;", "'" => "&apos;" , '<' => '&lt;' , '>' => '&gt;' , '&' => '&amp;') + "<br />"

          end
        end
        end  #closes ss.length
        end  #closes search terms

        #now delete the repository
        %x(rm -rf #{Rails.root.join('repos',repo["name"])})
        puts "done." + repo["name"]

  end
end